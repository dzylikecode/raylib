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
  static const main = MatchCode(r'\bint\s*main\s*\(void\)', 'int main()');

  final String pattern;
  final String replacement;
}

class RaylibTranslator {
  final Set<TranslateRule> rules;
  final Set<Include> includes;
  final List<MatchCode> matchCodes;

  RaylibTranslator(this.rules)
    : includes = rules.whereType<Include>().toSet(),
      matchCodes = rules.whereType<MatchCode>().toList();

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
            translatedLine = translatedLine.replaceAll(
              RegExp(matchCode.pattern),
              matchCode.replacement,
            );
          }
          translatedLines.add(translatedLine);
      }
    }

    return translatedLines.join('\n');
  }
}
