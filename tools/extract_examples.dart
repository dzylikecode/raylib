// Extracts raylib examples from src/raylib/examples/README.md and copies
// the corresponding .c files to example/ with zero-padded numeric prefixes.
//
// Usage: dart run tools/extract_examples.dart

import 'dart:convert';
import 'dart:io';

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
];

const readmePath =
    'https://raw.githubusercontent.com/raysan5/raylib/refs/heads/master/examples/README.md';
const srcBase = 'ref_code/raylib/examples';
const destDir = 'example';

class ExampleInfo {
  // Matches lines like: | 01 | [core_basic_window](core/core_basic_window.c)
  static final pattern = RegExp(
    r'^\|\s*(\d+)\s*\|\s*\[(\w+)\]\(([^)]+\.c)\)',
    multiLine: true,
  );

  final int num;
  final String name;
  final String relPath;

  ExampleInfo(this.num, this.name, this.relPath);

  static List<ExampleInfo> parseAll(String readme) {
    return pattern.allMatches(readme).map((m) {
      final num = int.parse(m.group(1)!);
      final name = m.group(2)!;
      final relPath = m.group(3)!;
      return ExampleInfo(num, name, relPath);
    }).toList();
  }
}


void main() async {
  final readme = await () async {
    final uri = Uri.parse(readmePath);
    final response = await HttpClient().getUrl(uri).then((req) => req.close());
    if (response.statusCode == 200) {
      return await response.transform(utf8.decoder).join();
    } else {
      throw Exception('Failed to load README.md: ${response.statusCode}');
    }
  }();

  var copied = 0;
  var skipped = 0;

  for (final example in ExampleInfo.parseAll(readme)) {
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
