// https://github.com/raysan5/raylib.com/blob/master/cheatsheet/tool/generate_cheatsheet_code.py

import 'dart:io';

import 'package:args/args.dart';

const defaultIncludeDir = 'dist/include';

const modules = <String, List<String>>{
  'core': ['core', 'rgestures', 'rcamera'],
  'shapes': ['shapes'],
  'textures': ['textures'],
  'text': ['text'],
  'models': ['models'],
  'audio': ['audio'],
  'math': ['math'],
  'structs': ['structs'],
  'colors': ['colors'],
};

void main(List<String> args) {
  final parser = buildArgParser();
  final config = parseConfig(parser, args);

  if (config.showHelp) {
    printUsage(parser);
    return;
  }

  if (config.moduleName != null) {
    final generated = generateModule(config.moduleName!, config);
    writeSingleOutput(config.outputPath, generated);
    return;
  }

  final generatedModules = {
    for (final moduleName in modules.keys)
      moduleName: generateModule(moduleName, config),
  };
  writeAllOutputs(config.outputPath, generatedModules);
}

String generateModule(String moduleName, GeneratorConfig config) {
  final sourcePath = moduleName == 'math'
      ? config.raymathPath
      : config.raylibPath;
  final sourceLines = readLines(sourcePath);
  final moduleHeaders = modules[moduleName]!;

  return switch (moduleName) {
    'math' => parseMath(sourceLines),
    'structs' => parseStructs(sourceLines),
    'colors' => parseColors(sourceLines),
    _ => parseRaylibModule(sourceLines, moduleHeaders),
  };
}

String parseColors(List<String> lines) {
  const colorLiteral = 'CLITERAL(Color)';
  var previousLine = '';
  final colors = <String>[];

  for (final line in lines) {
    if (line.contains(colorLiteral) || previousLine.contains(colorLiteral)) {
      colors.add(previousLine.trim());
    }
    previousLine = line;
  }

  return colors
      .map(
        (line) =>
            indented(line.replaceAll('CLITERAL', '').replaceAll('NOTE: ', '')),
      )
      .joinWithTrailingNewline();
}

String parseStructs(List<String> lines) {
  const startSection = '// Structures Definition';
  const endSection = '// Enumerators Definition';
  const visualBreakBefore = [
    'Image',
    'Camera',
    'Wave',
    'VrDeviceInfo',
    'FilePathList',
  ];

  final structs = <StructSummary>[];
  var pendingComments = <String>[];
  var inStructSection = false;

  for (final line in lines) {
    if (line == startSection) {
      structs.clear();
      pendingComments = [];
      inStructSection = true;
      continue;
    }

    if (!inStructSection) continue;
    if (line == endSection) break;

    if (line.startsWith('////')) {
      continue;
    }

    if (line.startsWith('//')) {
      pendingComments.add(line.trim());
      continue;
    }

    final trimmedLine = line.trimLeft();
    if (trimmedLine.startsWith('typedef struct')) {
      final namePart = trimmedLine
          .substring('typedef struct'.length)
          .trimLeft();
      if (namePart.isNotEmpty && isUppercaseAscii(namePart.codeUnitAt(0))) {
        structs.add(
          StructSummary(
            declaration: line.trim().replaceAll(RegExp(r'[ {]+$'), ''),
            comments: pendingComments,
          ),
        );
      }
      pendingComments = [];
      continue;
    }

    if (trimmedLine.startsWith('typedef')) pendingComments = [];
  }

  final output = <String>[];
  for (final struct in structs) {
    final declaration =
        '${struct.declaration.replaceAll('CLITERAL', '').replaceFirst('typedef ', '')};';

    if (visualBreakBefore.any(declaration.contains)) output.add('');

    final comments = struct.comments.join('\n${' ' * 35}');
    output.add(indented('${declaration.padRight(30)} $comments'));
  }

  return output.joinWithTrailingNewline();
}

String parseMath(List<String> lines) {
  const tag = 'RMAPI';
  const sectionPrefix = '// Module Functions Definition - ';
  final entries = <MathEntry>[];
  var pendingComments = <String>[];

  for (final line in lines) {
    if (line.startsWith(sectionPrefix)) {
      entries.add(MathEntry.header(line.substring(sectionPrefix.length)));
      continue;
    }

    if (line.startsWith('//------')) continue;

    if (line.startsWith('//')) {
      pendingComments.add(line.replaceAll(RegExp(r'^[\n /]+|[\n /]+$'), ''));
      continue;
    }

    if (line.startsWith(tag)) {
      entries.add(
        MathEntry.function(
          line.substring(tag.length + 1).trim(),
          pendingComments,
        ),
      );
      pendingComments = [];
    }
  }

  final output = <String>[];
  for (final entry in entries) {
    switch (entry) {
      case MathHeader(:final title):
        output
          ..add('')
          ..add(indented('// $title'));
      case MathFunction(:final declaration, :final comments):
        final marker = comments.isEmpty ? '' : '//';
        output.add(
          indented('${declaration.padRight(75)} $marker ${comments.join(' ')}'),
        );
    }
  }

  return output.joinWithTrailingNewline();
}

String parseRaylibModule(List<String> lines, List<String> moduleHeaders) {
  const tag = 'RLAPI';
  const moduleHeaderMarker = '(Module: ';

  final data = <String>[];
  var currentModule = '';

  for (final line in lines) {
    if (line.contains(moduleHeaderMarker)) {
      final start =
          line.indexOf(moduleHeaderMarker) + moduleHeaderMarker.length;
      final end = line.indexOf(')', start);
      final previousModuleWasOutsideTarget = !moduleHeaders.contains(
        currentModule,
      );

      if (previousModuleWasOutsideTarget) data.clear();

      currentModule = line.substring(start, end);
      if (!previousModuleWasOutsideTarget &&
          !moduleHeaders.contains(currentModule)) {
        break;
      }
    }

    if (!moduleHeaders.contains(currentModule)) continue;

    if (line.startsWith('//')) {
      data.add(line.trim());
    } else if (line.isEmpty) {
      data.add('');
    } else if (line.startsWith(tag)) {
      data.add(line.substring(tag.length).trim());
    }
  }

  final content = data.length > 4
      ? data.sublist(3, data.length - 1)
      : const <String>[];
  return content.map(indented).joinWithTrailingNewline();
}

List<String> readLines(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    stderr.writeln('Error: input file not found: $path');
    exit(66);
  }
  return file.readAsLinesSync();
}

void writeSingleOutput(String outputPath, String content) {
  File(outputPath).writeAsStringSync(content);
}

void writeAllOutputs(String outputPath, Map<String, String> generatedModules) {

  final outputDir = Directory(outputPath);
  if (!outputDir.existsSync()) outputDir.createSync(recursive: true);

  for (final entry in generatedModules.entries) {
    final outFile = File(
      '${outputDir.path}${Platform.pathSeparator}${entry.key}.c',
    );
    outFile.writeAsStringSync(entry.value);
  }
}

ArgParser buildArgParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help.')
    ..addOption(
      'raylib',
      abbr: 'r',
      valueHelp: 'path',
      help: 'Path to raylib.h.',
      defaultsTo: '$defaultIncludeDir/raylib.h',
    )
    ..addOption(
      'raymath',
      abbr: 'm',
      valueHelp: 'path',
      help: 'Path to raymath.h.',
      defaultsTo: '$defaultIncludeDir/raymath.h',
    )
    ..addOption(
      'output',
      abbr: 'o',
      valueHelp: 'path',
      help: 'Output file, or output folder when generating all modules.',
      defaultsTo: 'cheatsheet',
    );
}

GeneratorConfig parseConfig(ArgParser parser, List<String> args) {
  late final ArgResults results;
  try {
    results = parser.parse(args);
  } on FormatException catch (error) {
    stderr.writeln('Error: ${error.message}');
    stderr.writeln();
    printUsage(parser);
    exit(64);
  }

  if (results.rest.length > 1) {
    stderr.writeln('Error: only one module can be specified');
    stderr.writeln();
    printUsage(parser);
    exit(64);
  }

  final moduleName = results.rest.isEmpty ? null : results.rest.single;
  if (moduleName != null && !modules.containsKey(moduleName)) {
    printUsage(parser);
    stderr.writeln('Error: $moduleName is not a valid module');
    exit(64);
  }

  return GeneratorConfig(
    moduleName: moduleName,
    raylibPath: results['raylib'] as String,
    raymathPath: results['raymath'] as String,
    outputPath: results['output'] as String,
    showHelp: results['help'] as bool,
  );
}

void printUsage(ArgParser parser) {
  stdout.writeln('''
Usage: dart run tools/generate_api.dart [options] [module]

Generator for cheatsheet c files for raylib.com.

Arguments:
  module                Module to generate. If omitted, generates all modules.
                        Must be one of: ${modules.keys.join(', ')}

Options:
${parser.usage}

Examples:
  dart run tools/generate_api.dart -o cheatsheet
  dart run tools/generate_api.dart core -o cheatsheet/raylib_core.c
''');
}

String indented(String line) => '    $line'.trimRight();

bool isUppercaseAscii(int codeUnit) => codeUnit >= 65 && codeUnit <= 90;

class GeneratorConfig {
  const GeneratorConfig({
    required this.moduleName,
    required this.raylibPath,
    required this.raymathPath,
    required this.outputPath,
    required this.showHelp,
  });

  final String? moduleName;
  final String raylibPath;
  final String raymathPath;
  final String outputPath;
  final bool showHelp;
}

class StructSummary {
  const StructSummary({required this.declaration, required this.comments});

  final String declaration;
  final List<String> comments;
}

sealed class MathEntry {
  const MathEntry();

  const factory MathEntry.header(String title) = MathHeader;
  const factory MathEntry.function(String declaration, List<String> comments) =
      MathFunction;
}

class MathHeader extends MathEntry {
  const MathHeader(this.title);

  final String title;
}

class MathFunction extends MathEntry {
  const MathFunction(this.declaration, this.comments);

  final String declaration;
  final List<String> comments;
}

extension StringListJoin on Iterable<String> {
  String joinWithTrailingNewline() {
    final text = join('\n');
    return text.isEmpty ? text : '$text\n';
  }
}
