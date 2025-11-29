// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
import 'package:native_toolchain_cmake/native_toolchain_cmake.dart';

const hash =
    'ebce9fa97ae643b2b1b17cfac3a8d45dba6de3a9 src/raylib (5.5-1406-gebce9fa9)';

final Logger logger = Logger('raylib hook');

Future<void> main(List<String> args) async {
  Logger.root
    ..level = Level.ALL
    ..onRecord.listen(
      (record) => print(
        '[${record.level.name}] [${record.loggerName}] ${record.time}: ${record.message}',
      ),
    );

  await build(args, (input, output) async {
    if (!await fetchSubmodule(input.packageRoot.resolveUri(.file('.')))) {
      throw Exception('Failed to fetch raylib submodule.');
    }

    final builder = CMakeBuilder.create(
      name: input.packageName,
      sourceDir: input.packageRoot.resolveUri(.file('src/raylib/')),
      defines: {'BUILD_SHARED_LIBS': 'ON', 'BUILD_EXAMPLES': 'OFF'},
      logger: logger,
    );
    await builder.run(input: input, output: output, logger: logger);

    output.assets.code.add(
      CodeAsset(
        package: input.packageName,
        name: 'src/raylib.g.dart',
        file: input.outputDirectory.resolve(
          switch (input.config.code.targetOS) {
            .linux => 'raylib/libraylib.so',
            .macOS => 'raylib/libraylib.dylib',
            .windows => 'raylib/raylib.dll',
            _ => throw UnsupportedError(
              'Unsupported OS: ${input.config.code.targetOS}',
            ),
          },
        ),
        linkMode: DynamicLoadingBundled(),
      ),
    );
  });
}

Future<bool> fetchSubmodule(Uri repoUri) async {
  final path = repoUri.path;
  final repoDir = Directory.fromUri(repoUri);

  logger.info('Checking for submodule at $path');

  if (await submoduleExists(repoDir)) {
    logger.info('Submodule already exists at $path');
    return true;
  }

  logger.info('Fetching submodule at $path');
  final result = await Process.run('git', [
    'submodule',
    'update',
    '--init',
    '--recursive',
  ], workingDirectory: path);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['submodule', 'update', '--init', '--recursive'],
      'Failed to fetch $path: ${result.stderr}',
      result.exitCode,
    );
  }
  return await submoduleExists(repoDir);
}

Future<bool> submoduleExists(Directory repoDir) async {
  final path = repoDir.path;
  // Run `git submodule status`, read result
  final result = await Process.run('git', [
    'submodule',
    'status',
  ], workingDirectory: path);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['submodule', 'status'],
      'Failed to check $path: ${result.stderr}',
      result.exitCode,
    );
  }

  final output = result.stdout.toString().trim();
  if (output.isEmpty) return false;

  return output == hash;
}
