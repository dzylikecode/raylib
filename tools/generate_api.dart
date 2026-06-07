/**
 * 基本思路就是将 C 函数原型转换为 Dart 函数签名
 * 
 * 如果 proxy 文件里面有对应的函数实现，则转发给 proxy，否则转发给 raw。
 * 
 * 
 */

import 'dart:io';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:c_proto_parser/c_proto_parser.dart';

final modules = <String, ({String deps, Map<String, String> customInterfaces})>{
  'core': (
    deps: """
import 'raylib_const.dart';
import 'structs.dart';
import 'dart:typed_data';
""",
    customInterfaces: {
      'IsWindowState': 'bool IsWindowState(ConfigFlags flag)',
      'SetWindowState': 'void SetWindowState(ConfigFlags flags)',
      'ClearWindowState': 'void ClearWindowState(ConfigFlags flags)',
      'BeginBlendMode': 'void BeginBlendMode(BlendMode mode)',
      'SetShaderValue':
          'void SetShaderValue(Shader shader, int locIndex, TypedData value, ShaderUniformDataType uniformType)',
      'SetShaderValueV':
          'void SetShaderValueV(Shader shader, int locIndex, TypedData value, ShaderUniformDataType uniformType, int count)',
      'SetConfigFlags': 'void SetConfigFlags(ConfigFlags flags)',
      'SetTraceLogLevel': 'void SetTraceLogLevel(TraceLogLevel logLevel)',
      'TraceLog':
          'void TraceLog(TraceLogLevel logLevel, String text, List<Object> args)',
      'LoadFileData': 'Uint8List LoadFileData(String fileName)',
      'UnloadFileData': 'void UnloadFileData(Uint8List data)',
      'SaveFileData': 'bool SaveFileData(String fileName, Uint8List data)',
      'ExportDataAsCode':
          'bool ExportDataAsCode(Uint8List data, String fileName)',
      'CompressData': 'Uint8List CompressData(Uint8List data)',
      'DecompressData': 'Uint8List DecompressData(Uint8List compData)',
      'EncodeDataBase64': 'String EncodeDataBase64(Uint8List data)',
      'DecodeDataBase64': 'Uint8List DecodeDataBase64(Uint8List data)',
      'ComputeCRC32': 'int ComputeCRC32(Uint8List data)',
      'ComputeMD5': 'Uint8List ComputeMD5(Uint8List data)',
      'ComputeSHA1': 'Uint8List ComputeSHA1(Uint8List data)',
      'ComputeSHA256': 'Uint8List ComputeSHA256(Uint8List data)',
      'SetAutomationEventList':
          'void SetAutomationEventList(AutomationEventList list)',
      'IsKeyPressed': 'bool IsKeyPressed(KeyboardKey key)',
      'IsKeyPressedRepeat': 'bool IsKeyPressedRepeat(KeyboardKey key)',
      'IsKeyDown': 'bool IsKeyDown(KeyboardKey key)',
      'IsKeyReleased': 'bool IsKeyReleased(KeyboardKey key)',
      'IsKeyUp': 'bool IsKeyUp(KeyboardKey key)',
      'GetKeyPressed': 'KeyboardKey GetKeyPressed()',
      'GetKeyName': 'String GetKeyName(KeyboardKey key)',
      'SetExitKey': 'void SetExitKey(KeyboardKey key)',
      'IsGamepadButtonPressed':
          'bool IsGamepadButtonPressed(int gamepad, GamepadButton button)',
      'IsGamepadButtonDown':
          'bool IsGamepadButtonDown(int gamepad, GamepadButton button)',
      'IsGamepadButtonReleased':
          'bool IsGamepadButtonReleased(int gamepad, GamepadButton button)',
      'IsGamepadButtonUp':
          'bool IsGamepadButtonUp(int gamepad, GamepadButton button)',
      'GetGamepadButtonPressed': 'GamepadButton GetGamepadButtonPressed()',
      'GetGamepadAxisMovement':
          'double GetGamepadAxisMovement(int gamepad, GamepadAxis axis)',
      'IsMouseButtonPressed': 'bool IsMouseButtonPressed(MouseButton button)',
      'IsMouseButtonDown': 'bool IsMouseButtonDown(MouseButton button)',
      'IsMouseButtonReleased': 'bool IsMouseButtonReleased(MouseButton button)',
      'IsMouseButtonUp': 'bool IsMouseButtonUp(MouseButton button)',
      'SetMouseCursor': 'void SetMouseCursor(MouseCursor cursor)',
      'SetGesturesEnabled': 'void SetGesturesEnabled(Gesture gesture)',
      'IsGestureDetected': 'bool IsGestureDetected(Gesture gesture)',
      'GetGestureDetected': 'Gesture GetGestureDetected()',
      'UpdateCamera': 'void UpdateCamera(Camera3D camera, CameraMode mode)',
      'UpdateCameraPro':
          'void UpdateCameraPro(Camera3D camera, Vector3 movement, Vector3 rotation, double zoom)',
    },
  ),
  'shapes': (
    deps: """
import 'structs.dart';
""",
    customInterfaces: {
      'DrawLineStrip': 'void DrawLineStrip(List<Vector2> points, Color color)',
      'DrawTriangleFan':
          'void DrawTriangleFan(List<Vector2> points, Color color)',
      'DrawTriangleStrip':
          'void DrawTriangleStrip(List<Vector2> points, Color color)',
      'DrawSplineLinear':
          'void DrawSplineLinear(List<Vector2> points, double thick, Color color)',
      'DrawSplineBasis':
          'void DrawSplineBasis(List<Vector2> points, double thick, Color color)',
      'DrawSplineCatmullRom':
          'void DrawSplineCatmullRom(List<Vector2> points, double thick, Color color)',
      'DrawSplineBezierQuadratic':
          'void DrawSplineBezierQuadratic(List<Vector2> points, double thick, Color color)',
      'DrawSplineBezierCubic':
          'void DrawSplineBezierCubic(List<Vector2> points, double thick, Color color)',
      'CheckCollisionPointPoly':
          'bool CheckCollisionPointPoly(Vector2 point, List<Vector2> points)',
    },
  ),
  'textures': (
    deps: """
import 'structs.dart';
""",
    customInterfaces: {},
  ),
};

String toDartType(CType type) {
  if (type.isVoid) return 'void';
  if (type.base == 'void' && type.pointerDepth == 1) return 'int';
  if (type.base.contains('char') && type.pointerDepth == 1) return 'String';
  if (type.pointerDepth > 0)
    return 'List<${toDartType(type.copyWith(pointerDepth: type.pointerDepth - 1))}>';

  return switch (type.base) {
    'int' || 'unsigned int' || 'short' || 'long' => 'int',
    'float' || 'double' => 'double',
    'bool' || '_Bool' => 'bool',
    'variadic' => 'List<Object>',
    _ => type.base,
  };
}

void main() async {
  for (final MapEntry(key: name, value: overrides) in modules.entries) {
    final api = await apiOf(name);
    final proxy = await proxyOf(name);
    final rule = ApiMapRule(
      overrides.customInterfaces,
      topLevelFunctionNamesFromSource(proxy),
    );
    final dartApi = translate(api, rule);
    await generateModule(name, overrides.deps, dartApi);
  }
}

Future<void> generateModule(String module, String deps, String dartApi) async {
  final file = File('lib/src/$module.g.dart');
  await file.writeAsString("""
// generated by tools/generate_api.dart, do not edit by hand
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'raylib.g.dart' as raw;
import '${module}_proxy.dart' as proxy;
$deps
$dartApi
""");
}

Future<String> apiOf(String module) async {
  final file = File('cheatsheet/$module.c');
  return file.readAsString();
}

Future<String> proxyOf(String module) async {
  final file = File('lib/src/${module}_proxy.dart');
  if (!file.existsSync()) return '';
  return file.readAsString();
}

/// Splits a line into a comment and code part
/// void f(int a); // This is a comment => ('void f(int a);', 'This is a comment')
(String, String) splitComment(String line) {
  final commentIndex = line.indexOf('//');
  if (commentIndex == -1) return (line.trim(), '');
  final codePart = line.substring(0, commentIndex).trim();
  final commentPart = line.substring(commentIndex + 2).trim();
  return (codePart, commentPart);
}

enum LineType {
  code,
  comment,
  empty;

  factory LineType.of(String line) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) return .empty;
    if (trimmed.startsWith('//')) return .comment;
    return .code;
  }
}

class ApiMapRule {
  final Map<String, String> customInterfaces;
  final Set<String> proxyFunctions;

  ApiMapRule(this.customInterfaces, this.proxyFunctions);

  String call(String api) {
    var function = parseCFunctionPrototype(api);
    // 用来改变调用，比如两个参数变成了一个
    if (customInterfaces.containsKey(function.name)) {
      function = parseCFunctionPrototype(customInterfaces[function.name]!);
    }
    final returnType = toDartType(function.returnType);
    final interfaceFunc =
        customInterfaces[function.name] ??
        '$returnType ${function.name}(${funcParamList(function.params)})';
    final needProxy =
        customInterfaces[function.name] != null ||
        proxyFunctions.contains(function.name);

    return '$interfaceFunc => '
        '${needProxy ? 'proxy' : 'raw'}.${function.name}(${funcCall(function.params)});';
  }

  String funcCall(List<CParam> params) {
    if (params.length == 1 && params[0].type.isVoid) {
      return '';
    }
    return params.map((p) => paramName(p.name)).join(', ');
  }

  String paramName(String name) => name == '...' ? 'args' : name;

  String funcParamList(List<CParam> params) {
    if (params.length == 1 && params[0].type.isVoid) {
      return '';
    }
    return params
        .map((p) => '${toDartType(p.type)} ${paramName(p.name)}')
        .join(', ');
  }
}

String translate(String source, ApiMapRule rule) {
  final lines = source.split('\n');
  final translatedLines = lines.map(
    (line) => switch (LineType.of(line)) {
      // dart format off
      .code    => () {
                    final (codePart, commentPart) = splitComment(line);
                    return '/// $commentPart\n${rule(codePart)}';
                  }(),
      .comment => line.trim(),
      .empty   => line,
      // dart format on
    },
  );
  return translatedLines.join('\n');
}

Set<String> topLevelFunctionNamesFromSource(String source) {
  final result = parseString(content: source, throwIfDiagnostics: false);

  return {
    for (final declaration in result.unit.declarations)
      if (declaration is FunctionDeclaration) declaration.name.lexeme,
  };
}
