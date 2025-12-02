// ignore_for_file: non_constant_identifier_names

// Text strings management functions

@Deprecated('Use string interpolation instead')
String TextFormat(String format, List<Object?> args) {
  int index = 0;

  final regex = RegExp(
    r'%'
    r'([0\- ]*)' // flags: 0, -, space
    r'(\d*)' // width
    r'(?:\.(\d+))?' // precision
    r'([idfs])', // type
  );

  return format.replaceAllMapped(regex, (match) {
    if (index >= args.length) {
      throw ArgumentError('Missing arguments for format string');
    }
    final flags = match[1] ?? "";
    final width = match[2]?.isNotEmpty ?? false ? int.parse(match[2]!) : null;
    final precision = match[3] != null ? int.parse(match[3]!) : null;
    final type = match[4]!;

    final value = args[index++];
    late String result;

    switch (type) {
      case 'i' || 'd':
        result = (value as num).toInt().toString();
      case 'f':
        final p = precision ?? 6;
        result = (value as num).toStringAsFixed(p);
      case 's':
        result = value.toString();
      default:
        throw UnsupportedError("Unknown format type: $type");
    }

    // Width + padding
    if (width != null && result.length < width) {
      final padChar = flags.contains('0') ? '0' : ' ';
      if (flags.contains('-')) {
        // left-align
        result = result.padRight(width, padChar);
      } else {
        // right-align
        result = result.padLeft(width, padChar);
      }
    }

    return result;
  });
}

@Deprecated('Use .toLowerCase() instead')
String TextToLower(String text) => text.toLowerCase();
@Deprecated('Use .indexOf() instead')
int TextFindIndex(String text, String find) => text.indexOf(find);
