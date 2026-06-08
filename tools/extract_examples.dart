// Extracts raylib examples from src/raylib/examples/README.md and copies
// the corresponding .c files to example/ with zero-padded numeric prefixes.
//
// Usage: dart run tools/extract_examples.dart

import 'dart:io';

const range = 15;

const skips = [
  'core_loading_thread', // not cross-platform
  'core_3d_camera_first_person',
  'models_loading_vox',
  'shaders_basic_lighting',
  'shaders_fog',
  'shaders_mesh_instancing',
  'shaders_deferred_render',
  'rlgl_standalone',
  'raylib_opengl_interop',
  'embedded_files_loading',
  'core_screen_recording',
  'shapes_easings_ball',
];


const raylibRepoUrl = 'https://github.com/raysan5/raylib.git';
const refCodeDir = 'ref_code';
const raylibRefDir = '$refCodeDir/raylib';
const srcBase = '$raylibRefDir/examples';
const destDir = 'example/c';
const readmePath = '$srcBase/README.md';

class ExampleInfo {
  // Matches lines like: | [core_basic_window](core/core_basic_window.c) | ...
  static final pattern = RegExp(
    r'^\|\s*\[(\w+)\]\(([^)]+\.c)\)',
    multiLine: true,
  );

  final int num;
  final String name;
  final String relPath;

  ExampleInfo(this.num, this.name, this.relPath);

  static List<ExampleInfo> parseAll(String readme) {
    return pattern.allMatches(readme).indexed.map((entry) {
      final (index, m) = entry;
      final num = index + 1;
      final name = m.group(1)!;
      final relPath = m.group(2)!;
      return ExampleInfo(num, name, relPath);
    }).toList();
  }
}

void main() async {
  await ensureRaylibRepo();

  final readme = await File(readmePath).readAsString();

  var copied = 0;
  var skipped = 0;

  final examplesDir = Directory(destDir);
  if (examplesDir.existsSync()) {
    print('Clearing existing examples in $destDir...');
    examplesDir.deleteSync(recursive: true);
  }
  Directory(destDir).createSync(recursive: true);


  for (final example in ExampleInfo.parseAll(readme).take(range)) {
    final num = example.num;
    final name = example.name;
    final relPath = example.relPath;

    final src = File('$srcBase/$relPath');
    if (!src.existsSync() || skips.contains(name)) {
      print('SKIP (not found or skipped): $relPath');
      skipped++;
      continue;
    }

    final padded = num.toString().padLeft(3, '0');
    final dest = File('$destDir/${padded}_$name.c');
    dest.writeAsStringSync(src.readAsStringSync());
    print('  $padded  $name');
    copied++;
  }

  print('\nDone: $copied copied, $skipped skipped → $destDir/');
}

Future<void> ensureRaylibRepo() async {
  final raylibDir = Directory(raylibRefDir);
  if (raylibDir.existsSync()) return;

  Directory(refCodeDir).createSync(recursive: true);
  print('Cloning raylib into $raylibRefDir...');

  final result = await Process.run('git', [
    'clone',
    raylibRepoUrl,
    raylibRefDir,
  ]);

  if (result.exitCode != 0) {
    stderr.write(result.stderr);
    throw ProcessException(
      'git',
      ['clone', raylibRepoUrl, raylibRefDir],
      'Failed to clone raylib',
      result.exitCode,
    );
  }
}
