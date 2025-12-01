import 'dart:io';

import 'package:ffigen/ffigen.dart';

void main() {
  final packageRoot = Platform.script.resolve('../');
  FfiGenerator(
    output: .new(dartFile: packageRoot.resolve('lib/src/raylib.g.dart')),
    headers: .new(
      entryPoints: [
        packageRoot.resolve('src/raylib/src/raylib.h'),
        packageRoot.resolve('src/raylib/src/rlgl.h'),
      ],
      include: (header) => header.path.contains('raylib'),
    ),
    structs: .includeAll,
    functions: .includeAll,
    typedefs: .includeAll,
  ).generate();

  FfiGenerator(
    output: .new(dartFile: packageRoot.resolve('lib/src/raylib_const.g.dart')),
    headers: .new(
      entryPoints: [
        packageRoot.resolve('src/raylib/src/raylib.h'),
        packageRoot.resolve('src/raylib/src/rlgl.h'),
      ],
      include: (header) => header.path.contains('raylib'),
    ),
    macros: .includeAll,
    enums: .includeAll,
  ).generate();
}
