import 'dart:io';

import 'package:test/test.dart';
import 'package:meta/meta.dart';
import 'package:raylib_c_translator/raylib_c_translator.dart';

void main() {
  Directory('example/generated').createSync(recursive: true);
  translate('001_core_basic_window', {Include.raylib, MatchCode.main});
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
  });
}
