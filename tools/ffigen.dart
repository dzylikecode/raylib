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
    macros: .includeAll,
    structs: .includeAll,
    functions: .includeAll,
    enums: .includeAll,
    typedefs: .includeAll,
  ).generate();
}
