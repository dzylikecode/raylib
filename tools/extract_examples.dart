// Extracts raylib examples from src/raylib/examples/README.md and copies
// the corresponding .c files to example/ with zero-padded numeric prefixes.
//
// Usage: dart run tools/extract_examples.dart

import 'dart:io';

void main() {
  const readmePath = 'src/raylib/examples/README.md';
  const srcBase = 'src/raylib/examples';
  const destDir = 'example';

  final readme = File(readmePath).readAsStringSync();

  // Matches lines like: | 01 | [core_basic_window](core/core_basic_window.c)
  final pattern = RegExp(r'^\|\s*(\d+)\s*\|\s*\[(\w+)\]\(([^)]+\.c)\)',
      multiLine: true);

  var copied = 0;
  var skipped = 0;

  for (final m in pattern.allMatches(readme)) {
    final num = int.parse(m.group(1)!);
    final name = m.group(2)!;
    final relPath = m.group(3)!;

    final src = File('$srcBase/$relPath');
    if (!src.existsSync()) {
      print('SKIP (not found): $relPath');
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
