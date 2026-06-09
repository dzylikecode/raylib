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

class RaylibTranslator {
  final Set<TranslateRule> rules;
  final Set<Include> includes;
  final Set<MatchCode> matchCodes;

  RaylibTranslator(this.rules)
    : includes = rules.whereType<Include>().toSet(),
      matchCodes = rules.whereType<MatchCode>().toSet();

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
          for (final matchCode in matchCodes) {
            translatedLine = _replacePattern(translatedLine, matchCode);
          }
          translatedLines.add(translatedLine);
      }
    }

    return translatedLines.join('\n');
  }
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
