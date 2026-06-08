// TODO: Put public facing types in this file.

/// Checks if you are awesome. Spoiler: you are.
class CFunction {
  const CFunction({
    required this.name,
    required this.returnType,
    required this.params,
  });

  final String name;
  final CType returnType;
  final List<CParam> params;

  @override
  String toString() {
    return 'CFunction(name: $name, returnType: $returnType, params: $params)';
  }
}

class CParam {
  const CParam({required this.name, required this.type});

  final String name;
  final CType type;

  @override
  String toString() => 'CParam(name: $name, type: $type)';
}

class CType {
  const CType({
    required this.base,
    this.isConst = false,
    this.pointerDepth = 0,
    this.arraySuffix,
  });

  final String base;
  final bool isConst;
  final int pointerDepth;
  final String? arraySuffix;

  bool get isVoid => base == 'void' && pointerDepth == 0;
  bool get isConstCharPointer => isConst && base == 'char' && pointerDepth == 1;
  bool get isPointer => pointerDepth > 0;
  bool get isArray => arraySuffix != null;

  CType copyWith({
    String? base,
    bool? isConst,
    int? pointerDepth,
    String? arraySuffix,
  }) {
    return CType(
      base: base ?? this.base,
      isConst: isConst ?? this.isConst,
      pointerDepth: pointerDepth ?? this.pointerDepth,
      arraySuffix: arraySuffix ?? this.arraySuffix,
    );
  }

  @override
  String toString() {
    final parts = <String>[
      if (isConst) 'const',
      base,
      if (pointerDepth > 0) '*' * pointerDepth,
      ?arraySuffix,
    ];
    return parts.join(' ');
  }
}

class CPrototypeParseException implements Exception {
  CPrototypeParseException(this.message);

  final String message;

  @override
  String toString() => 'CPrototypeParseException: $message';
}

CFunction parseCFunctionPrototype(String line) {
  final source = _normalizePrototype(line);
  final openParen = source.indexOf('(');
  final closeParen = _findMatchingParen(source, openParen);

  if (openParen <= 0 || closeParen != source.length - 1) {
    throw CPrototypeParseException(
      'Expected a single C function prototype: $line',
    );
  }

  final head = source.substring(0, openParen).trim();
  final paramsSource = source.substring(openParen + 1, closeParen).trim();
  final nameMatch = RegExp(r'([A-Za-z_]\w*)$').firstMatch(head);

  if (nameMatch == null) {
    throw CPrototypeParseException('Could not find function name: $line');
  }

  final name = nameMatch.group(1)!;
  final returnTypeSource = head.substring(0, nameMatch.start).trim();

  if (returnTypeSource.isEmpty) {
    throw CPrototypeParseException('Could not find return type: $line');
  }

  return CFunction(
    name: name,
    returnType: _parseCType(returnTypeSource),
    params: _parseParams(paramsSource),
  );
}

String _normalizePrototype(String line) {
  final withoutLineComment = line.replaceFirst(RegExp(r'//.*$'), '');
  final trimmed = withoutLineComment.trim();
  final withoutSemicolon = trimmed.endsWith(';')
      ? trimmed.substring(0, trimmed.length - 1).trim()
      : trimmed;
  return withoutSemicolon.replaceAll(RegExp(r'\s+'), ' ');
}

List<CParam> _parseParams(String source) {
  if (source.isEmpty || source == 'void') {
    return const [];
  }

  return _splitTopLevel(source, ',')
      .map((part) {
        final param = part.trim();

        if (param == '...') {
          return const CParam(
            name: '...',
            type: CType(base: 'variadic'),
          );
        }

        if (param.contains(RegExp(r'\(\s*\*'))) {
          throw CPrototypeParseException(
            'Function pointer parameters are not supported yet: $param',
          );
        }

        final arrayMatch = RegExp(r'(\[[^\]]*\])$').firstMatch(param);
        final arraySuffix = arrayMatch?.group(1);
        final withoutArray = arrayMatch == null
            ? param
            : param.substring(0, arrayMatch.start).trim();

        final nameMatch = RegExp(r'([A-Za-z_]\w*)$').firstMatch(withoutArray);
        if (nameMatch == null) {
          throw CPrototypeParseException(
            'Could not find parameter name: $param',
          );
        }

        final name = nameMatch.group(1)!;
        final typeSource = withoutArray.substring(0, nameMatch.start).trim();
        if (typeSource.isEmpty) {
          throw CPrototypeParseException(
            'Could not find parameter type: $param',
          );
        }

        return CParam(
          name: name,
          type: _parseCType(typeSource, arraySuffix: arraySuffix),
        );
      })
      .toList(growable: false);
}

CType _parseCType(String source, {String? arraySuffix}) {
  final spaced = source
      .replaceAll('*', ' * ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  final tokens = spaced.split(' ').where((token) => token.isNotEmpty).toList();

  final pointerDepth = tokens.where((token) => token == '*').length;
  final qualifiers = {'const', 'volatile', 'restrict'};
  final isConst = tokens.contains('const');
  final baseTokens = tokens
      .where((token) => token != '*' && !qualifiers.contains(token))
      .toList();

  if (baseTokens.isEmpty) {
    throw CPrototypeParseException('Could not parse C type: $source');
  }

  return CType(
    base: baseTokens.join(' '),
    isConst: isConst,
    pointerDepth: pointerDepth,
    arraySuffix: arraySuffix,
  );
}

List<String> _splitTopLevel(String source, String separator) {
  final result = <String>[];
  var depthParen = 0;
  var depthBracket = 0;
  var start = 0;

  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (char == '(') depthParen++;
    if (char == ')') depthParen--;
    if (char == '[') depthBracket++;
    if (char == ']') depthBracket--;

    if (char == separator && depthParen == 0 && depthBracket == 0) {
      result.add(source.substring(start, i));
      start = i + 1;
    }
  }

  result.add(source.substring(start));
  return result;
}

int _findMatchingParen(String source, int openIndex) {
  if (openIndex < 0 || source[openIndex] != '(') {
    return -1;
  }

  var depth = 0;
  for (var i = openIndex; i < source.length; i++) {
    final char = source[i];
    if (char == '(') depth++;
    if (char == ')') {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}
