// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
import 'package:native_toolchain_cmake/native_toolchain_cmake.dart';

const hash = 'c1ab645ca298a2801097931d1079b10ff7eb9df8 src/raylib (5.5)';

const repoHash = 'c1ab645ca298a2801097931d1079b10ff7eb9df8';
const repoTag = '5.5';

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
    if (!await fetch(input.packageRoot)) {
      throw Exception('Failed to fetch raylib submodule.');
    }

    // Prepare CMake defines based on target OS
    final defines = {'BUILD_SHARED_LIBS': 'ON', 'BUILD_EXAMPLES': 'OFF'};

    // For Android, disable GLFW (not needed) and prevent X11 lookup
    if (input.config.code.targetOS.name == 'android') {
      defines['GLFW_BUILD_X11'] = 'OFF';
      defines['GLFW_BUILD_WAYLAND'] = 'OFF';
      defines['PLATFORM'] = 'Android';
    }

    final builder = CMakeBuilder.create(
      name: input.packageName,
      sourceDir: input.packageRoot.resolveUri(.file('src/raylib/')),
      defines: defines,
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
            .android => 'raylib/libraylib.so',
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

Future<bool> isGitRepository(Uri root) =>
    Directory.fromUri(root.resolve('.git')).exists();

Future<bool> fetch(Uri root) async {
  if (await isGitRepository(root)) {
    logger.info('Git repository exists, fetching submodule');
    return await fetchSubmodule(root);
  } else {
    logger.info('Git repository not found, cloning raylib');
    // return await clone(
    //   root.resolve("src/raylib"),
    //   'https://github.com/raysan5/raylib.git',
    //   repoHash,
    // );
    return await cloneByTag(
      root.resolve("src/raylib"),
      'https://github.com/raysan5/raylib.git',
      repoTag,
    );
  }
}

Future<bool> cloneByTag(Uri destDir, String url, String tag) async {
  final dir = Directory.fromUri(destDir);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  } else if ((await dir.list().toList()).isNotEmpty) {
    logger.info(
      'Directory $destDir already exists with content, skipping clone',
    );
    return true;
  }

  logger.info('Cloning $url to ${dir.path} with tag $tag');
  final result = await Process.run('git', [
    'clone',
    '--depth',
    '1',
    '--branch',
    tag,
    url,
    dir.path,
  ]);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['clone', '--depth', '1', '--branch', tag, url, dir.path],
      'Failed to clone $url with tag $tag: ${result.stderr}',
      result.exitCode,
    );
  }

  logger.info('Successfully cloned and checked out tag $tag');
  return true;
}

Future<bool> clone(Uri destDir, String url, String repoHash) async {
  final dir = Directory.fromUri(destDir);
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  } else if ((await dir.list().toList()).isNotEmpty) {
    logger.info(
      'Directory $destDir already exists with content, skipping clone',
    );
    return true;
  }

  logger.info('Cloning $url to $destDir');
  final result = await Process.run('git', ['clone', url, dir.path]);

  if (result.exitCode != 0) {
    throw ProcessException(
      'git',
      ['clone', url, dir.path],
      'Failed to clone $url: ${result.stderr}',
      result.exitCode,
    );
  }

  logger.info('Checking out hash $repoHash');
  final checkoutResult = await Process.run('git', [
    'checkout',
    repoHash,
  ], workingDirectory: dir.path);

  if (checkoutResult.exitCode != 0) {
    throw ProcessException(
      'git',
      ['checkout', repoHash],
      'Failed to checkout hash $repoHash: ${checkoutResult.stderr}',
      checkoutResult.exitCode,
    );
  }

  logger.info('Successfully cloned and checked out hash $repoHash');
  return true;
}

Future<bool> fetchSubmodule(Uri repoUri) async {
  final path = Directory.fromUri(repoUri).path;

  logger.info('Checking for submodule at $path');

  if (await submoduleExists(path)) {
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
  return await submoduleExists(path);
}

Future<bool> submoduleExists(String path) async {
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
