import 'dart:io';

import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:raylib_c_translator/raylib_c_translator.dart';

void main() {
  Directory('example/generated').createSync(recursive: true);
  translate('001_core_basic_window', {Include.raylib, MatchCode.main});
  translate('002_core_delta_time', {
    Include.raylib,
    MatchCode.main,
    MatchCode.floatSuffix,
    MatchCode('const char *fpsText = 0;', 'late final String fpsText;'),
    CastCode.numericLoose,
    StructInitializer.vector2,
  });

  translate('003_core_input_keys', {
    Include.raylib,
    MatchCode.main,
    MatchCode.floatSuffix,
    CastCode.numericLoose,
    StructInitializer.vector2,
  });

  translate('004_core_input_mouse', {
    Include.raylib,
    MatchCode.main,
    MatchCode.floatSuffix,
    CastCode.numericLoose,
    StructInitializer.vector2,
  });

  translate('005_core_input_mouse_wheel', {
    Include.raylib,
    MatchCode.main,
    MatchCode.floatSuffix,
    CastCode.numericLoose,
    MatchCode('screenHeight/2', 'screenHeight~/2'),
    MatchCode('screenWidth/2', 'screenWidth~/2'),
  });
}

@isTest
void translate(String target, Set<TranslateRule> rules) {
  test(target, () {
    final filePath = 'example/c/$target.c';
    final content = File(filePath).readAsStringSync();
    final translator = RaylibTranslator(rules);
    final translated = translator(content);
    final outputPath = 'example/generated/$target.g.dart';
    final outputFile = File(outputPath);
    outputFile.createSync(recursive: true);
    outputFile.writeAsStringSync(translated);
    expect(
      analyze(outputPath),
      isTrue,
      reason: 'Translated code should pass analysis',
    );
  });
}

bool analyze(String filePath) {
  ProcessResult result = Process.runSync('dart', ['analyze', filePath]);
  if (result.exitCode != 0) {
    print('Analysis failed for $filePath:');
    print(result.stdout);
    print(result.stderr);
    return false;
  }
  return true;
}
