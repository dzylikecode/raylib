class CInclude {
  const CInclude({required this.path});

  final String path;

  @override
  String toString() => 'CInclude(path: $path)';
}

class CIncludeParseException implements Exception {
  CIncludeParseException(this.message);

  final String message;

  @override
  String toString() => 'CIncludeParseException: $message';
}

CInclude parseCInclude(String line) {
  final source = _stripLineComment(line).trim();
  final match = RegExp(r'^#\s*include\s*"([^"]+)"\s*$').firstMatch(source);

  if (match == null) {
    throw CIncludeParseException('Expected a local C include: $line');
  }

  return CInclude(path: match.group(1)!);
}

List<CInclude> parseCIncludes(String source) {
  return source
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.startsWith('#'))
      .where((line) => RegExp(r'^#\s*include\b').hasMatch(line))
      .map(parseCInclude)
      .toList(growable: false);
}

String _stripLineComment(String line) {
  final index = line.indexOf('//');
  return index == -1 ? line : line.substring(0, index);
}
