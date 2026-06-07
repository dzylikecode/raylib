export 'src/vfprintf.dart' show vfprintf;         // → Dart wrapper below
export 'src/vfprintf.dart' show sprintf;          // → Dart wrapper below

import 'dart:io';

import 'src/stdio_impl.dart';

final printf = stdout.write;

bool ferror(FILE? file) => file?.hasError ?? false;
