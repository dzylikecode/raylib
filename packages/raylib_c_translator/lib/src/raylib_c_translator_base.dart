import 'package:c_proto_parser/c_proto_parser.dart';

enum _LineType {
  include,
  commentStart,
  commentEnd,
  comment,
  other;

  factory _LineType.fromLine(String line) {
    if (line.trim().startsWith('#include')) {
      return include;
    }
    if (line.trim().startsWith('//') ||
        (line.trim().startsWith('/*') && line.trim().endsWith('*/'))) {
      return comment;
    }
    if (line.trim().startsWith('/*')) {
      return commentStart;
    }
    if (line.contains('*/')) {
      return commentEnd;
    }

    return other;
  }
}

sealed class TranslateRule {
  const TranslateRule();
}

class Include extends TranslateRule {
  const Include({required this.c, required this.dart});
  static const raylib = Include(
    c: 'raylib.h',
    dart: 'package:raylib_dart/raylib_dart.dart',
  );

  final String c;
  final String dart;

  @override
  bool operator ==(Object other) {
    if (other is Include) {
      return c == other.c && dart == other.dart;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(c, dart);
}

class MatchCode extends TranslateRule {
  const MatchCode(this.pattern, this.replacement);
  static final main = MatchCode(
    RegExp(r'\bint\s*main\s*\(void\)'),
    'int main()',
  );
  static final floatSuffix = MatchCode(
    RegExp(r'(?<![A-Za-z_])(\d+\.\d*|\.\d+|\d+)[fF]\b'),
    r'$1',
  );
  static const cFloatCast = CastCode.float;
  static const cDoubleCast = CastCode.double_;
  static const cFloatingCast = CastCode.floating;
  static const cNumericCastLoose = CastCode.numericLoose;

  final Pattern pattern;
  final String replacement;

  @override
  bool operator ==(Object other) => switch (other) {
    MatchCode(:final pattern, :final replacement) =>
      this.pattern == pattern && this.replacement == replacement,
    _ => false,
  };

  @override
  int get hashCode => Object.hash(pattern, replacement);
}

class CastCode extends TranslateRule {
  const CastCode(this.conversions);

  static const float = CastCode({'float': 'toDouble'});
  static const double_ = CastCode({'double': 'toDouble'});
  static const floating = CastCode({'float': 'toDouble', 'double': 'toDouble'});
  static const numericLoose = CastCode({
    'char': 'toInt',
    'signed char': 'toInt',
    'unsigned char': 'toInt',
    'short': 'toInt',
    'signed short': 'toInt',
    'unsigned short': 'toInt',
    'int': 'toInt',
    'signed int': 'toInt',
    'unsigned int': 'toInt',
    'long': 'toInt',
    'signed long': 'toInt',
    'unsigned long': 'toInt',
    'float': 'toDouble',
    'double': 'toDouble',
  });

  final Map<String, String> conversions;

  @override
  bool operator ==(Object other) => switch (other) {
    CastCode(:final conversions) => _mapEquals(this.conversions, conversions),
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll(
    conversions.entries.map((entry) => Object.hash(entry.key, entry.value)),
  );
}

class StructInitializer extends TranslateRule {
  const StructInitializer(this.type);

  static const vector2 = StructInitializer('Vector2');
  static const vector3 = StructInitializer('Vector3');
  static const vector4 = StructInitializer('Vector4');
  static const rectangle = StructInitializer('Rectangle');
  static const color = StructInitializer('Color');

  final String type;

  @override
  bool operator ==(Object other) => switch (other) {
    StructInitializer(:final type) => this.type == type,
    _ => false,
  };

  @override
  int get hashCode => type.hashCode;
}

class RaylibTranslator {
  final Set<TranslateRule> rules;
  final Set<Include> includes;
  final Set<MatchCode> matchCodes;
  final Set<CastCode> castCodes;
  final Set<StructInitializer> structInitializers;

  RaylibTranslator(this.rules)
    : includes = rules.whereType<Include>().toSet(),
      matchCodes = rules.whereType<MatchCode>().toSet(),
      castCodes = rules.whereType<CastCode>().toSet(),
      structInitializers = rules.whereType<StructInitializer>().toSet();

  String call(String content) {
    final lines = content.split('\n');
    bool inBlockComment = false;
    final translatedLines = <String>[];
    for (final line in lines) {
      final lineType = _LineType.fromLine(line);
      if (inBlockComment && lineType != .commentEnd) {
        translatedLines.add(line);
        continue;
      }
      switch (lineType) {
        case .commentStart:
          inBlockComment = true;
          translatedLines.add(line);
        case .commentEnd:
          inBlockComment = false;
          translatedLines.add(line);
        case .comment:
          translatedLines.add(line);
        case .include:
          final c = parseCInclude(line);
          final include = includes.firstWhere(
            (include) => include.c == c.path,
            orElse: () =>
                throw Exception('No translation rule for include: ${c.path}'),
          );
          translatedLines.add("import '${include.dart}';");
        case .other:
          var translatedLine = line;
          for (final castCode in castCodes) {
            translatedLine = _replaceCast(translatedLine, castCode);
          }
          for (final matchCode in matchCodes) {
            translatedLine = _replacePattern(translatedLine, matchCode);
          }
          for (final structInitializer in structInitializers) {
            translatedLine = _replaceStructInitializer(
              translatedLine,
              structInitializer,
            );
          }
          translatedLines.add(translatedLine);
      }
    }

    return translatedLines.join('\n');
  }
}

bool _mapEquals(Map<String, String> a, Map<String, String> b) {
  if (a.length != b.length) return false;
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

String _replaceCast(String source, CastCode castCode) {
  if (castCode.conversions.isEmpty) return source;
  final typePattern = castCode.conversions.keys
      .map(RegExp.escape)
      .join('|')
      .replaceAll(r'\ ', r'\s+');
  final castPattern = RegExp(
    r'\(\s*('
    '$typePattern'
    r')\s*\)\s*(\([^()]*\)|[A-Za-z_]\w*(?:\s*(?:\.[A-Za-z_]\w*|\[[^\]]+\]|\([^()]*\)))*)',
  );

  return source.replaceAllMapped(castPattern, (match) {
    final type = match.group(1)!.trim().replaceAll(RegExp(r'\s+'), ' ');
    final operand = match.group(2)!;
    final method = castCode.conversions[type];
    if (method == null) return match.group(0)!;
    return '$operand.$method()';
  });
}

String _replaceStructInitializer(
  String source,
  StructInitializer structInitializer,
) {
  final type = RegExp.escape(structInitializer.type);
  var translated = source.replaceAllMapped(
    RegExp(r'\b(' + type + r'\s+[A-Za-z_]\w*\s*=\s*)\{([^{}]*)\}'),
    (match) =>
        '${match.group(1)!}${structInitializer.type}'
        '(${match.group(2)!.trim()})',
  );
  translated = translated.replaceAllMapped(
    RegExp(r'\(\s*' + type + r'\s*\)\s*\{([^{}]*)\}'),
    (match) => '${structInitializer.type}(${match.group(1)!.trim()})',
  );
  return translated;
}

String _replacePattern(String source, MatchCode matchCode) {
  final pattern = matchCode.pattern;
  if (pattern is RegExp) {
    return source.replaceAllMapped(
      pattern,
      (match) => _expandReplacement(matchCode.replacement, match),
    );
  }

  return source.replaceAll(pattern, matchCode.replacement);
}

String _expandReplacement(String replacement, Match match) {
  return replacement.replaceAllMapped(RegExp(r'\$(\d+)'), (groupMatch) {
    final groupIndex = int.parse(groupMatch.group(1)!);
    return match.group(groupIndex) ?? '';
  });
}
