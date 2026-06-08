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
import 'dart:typed_data';
import 'raylib_const.dart';
import 'structs.dart';
""",
    customInterfaces: {
      'LoadImageRaw':
          'Image LoadImageRaw(String fileName, int width, int height, PixelFormat format, int headerSize)',
      'LoadImageAnimFromMemory':
          'Image LoadImageAnimFromMemory(String fileType, Uint8List fileData, List<int> frames)',
      'LoadImageFromMemory':
          'Image LoadImageFromMemory(String fileType, Uint8List fileData)',
      'ExportImageToMemory':
          'Uint8List ExportImageToMemory(Image image, String fileType)',
      'ImageFormat': 'void ImageFormat(Image image, PixelFormat newFormat)',
      'ImageToPOT': 'void ImageToPOT(Image image, Color fill)',
      'ImageCrop': 'void ImageCrop(Image image, Rectangle crop)',
      'ImageAlphaCrop': 'void ImageAlphaCrop(Image image, double threshold)',
      'ImageAlphaClear':
          'void ImageAlphaClear(Image image, Color color, double threshold)',
      'ImageAlphaMask': 'void ImageAlphaMask(Image image, Image alphaMask)',
      'ImageAlphaPremultiply': 'void ImageAlphaPremultiply(Image image)',
      'ImageBlurGaussian': 'void ImageBlurGaussian(Image image, int blurSize)',
      'ImageKernelConvolution':
          'void ImageKernelConvolution(Image image, List<double> kernel)',
      'ImageResize':
          'void ImageResize(Image image, int newWidth, int newHeight)',
      'ImageResizeNN':
          'void ImageResizeNN(Image image, int newWidth, int newHeight)',
      'ImageResizeCanvas':
          'void ImageResizeCanvas(Image image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill)',
      'ImageMipmaps': 'void ImageMipmaps(Image image)',
      'ImageDither':
          'void ImageDither(Image image, int rBpp, int gBpp, int bBpp, int aBpp)',
      'ImageFlipVertical': 'void ImageFlipVertical(Image image)',
      'ImageFlipHorizontal': 'void ImageFlipHorizontal(Image image)',
      'ImageRotate': 'void ImageRotate(Image image, int degrees)',
      'ImageRotateCW': 'void ImageRotateCW(Image image)',
      'ImageRotateCCW': 'void ImageRotateCCW(Image image)',
      'ImageColorTint': 'void ImageColorTint(Image image, Color color)',
      'ImageColorInvert': 'void ImageColorInvert(Image image)',
      'ImageColorGrayscale': 'void ImageColorGrayscale(Image image)',
      'ImageColorContrast':
          'void ImageColorContrast(Image image, double contrast)',
      'ImageColorBrightness':
          'void ImageColorBrightness(Image image, int brightness)',
      'ImageColorReplace':
          'void ImageColorReplace(Image image, Color color, Color replace)',
      'LoadImagePalette':
          'List<Color> LoadImagePalette(Image image, int maxPaletteSize)',
      'ImageClearBackground':
          'void ImageClearBackground(Image dst, Color color)',
      'ImageDrawPixel':
          'void ImageDrawPixel(Image dst, int posX, int posY, Color color)',
      'ImageDrawPixelV':
          'void ImageDrawPixelV(Image dst, Vector2 position, Color color)',
      'ImageDrawLine':
          'void ImageDrawLine(Image dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color)',
      'ImageDrawLineV':
          'void ImageDrawLineV(Image dst, Vector2 start, Vector2 end, Color color)',
      'ImageDrawLineEx':
          'void ImageDrawLineEx(Image dst, Vector2 start, Vector2 end, int thick, Color color)',
      'ImageDrawCircle':
          'void ImageDrawCircle(Image dst, int centerX, int centerY, int radius, Color color)',
      'ImageDrawCircleV':
          'void ImageDrawCircleV(Image dst, Vector2 center, int radius, Color color)',
      'ImageDrawCircleLines':
          'void ImageDrawCircleLines(Image dst, int centerX, int centerY, int radius, Color color)',
      'ImageDrawCircleLinesV':
          'void ImageDrawCircleLinesV(Image dst, Vector2 center, int radius, Color color)',
      'ImageDrawRectangle':
          'void ImageDrawRectangle(Image dst, int posX, int posY, int width, int height, Color color)',
      'ImageDrawRectangleV':
          'void ImageDrawRectangleV(Image dst, Vector2 position, Vector2 size, Color color)',
      'ImageDrawRectangleRec':
          'void ImageDrawRectangleRec(Image dst, Rectangle rec, Color color)',
      'ImageDrawRectangleLines':
          'void ImageDrawRectangleLines(Image dst, Rectangle rec, int thick, Color color)',
      'ImageDrawTriangle':
          'void ImageDrawTriangle(Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color)',
      'ImageDrawTriangleEx':
          'void ImageDrawTriangleEx(Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color c1, Color c2, Color c3)',
      'ImageDrawTriangleLines':
          'void ImageDrawTriangleLines(Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color)',
      'ImageDrawTriangleFan':
          'void ImageDrawTriangleFan(Image dst, List<Vector2> points, Color color)',
      'ImageDrawTriangleStrip':
          'void ImageDrawTriangleStrip(Image dst, List<Vector2> points, Color color)',
      'ImageDraw':
          'void ImageDraw(Image dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint)',
      'ImageDrawText':
          'void ImageDrawText(Image dst, String text, int posX, int posY, int fontSize, Color color)',
      'ImageDrawTextEx':
          'void ImageDrawTextEx(Image dst, Font font, String text, Vector2 position, double fontSize, double spacing, Color tint)',
      'LoadTextureCubemap':
          'TextureCubemap LoadTextureCubemap(Image image, CubemapLayout layout)',
      'UpdateTexture':
          'void UpdateTexture(Texture2D texture, Uint8List pixels)',
      'UpdateTextureRec':
          'void UpdateTextureRec(Texture2D texture, Rectangle rec, Uint8List pixels)',
      'GenTextureMipmaps': 'Texture2D GenTextureMipmaps(Texture2D texture)',
      'SetTextureFilter':
          'void SetTextureFilter(Texture2D texture, TextureFilter filter)',
      'SetTextureWrap':
          'void SetTextureWrap(Texture2D texture, TextureWrap wrap)',
      'GetPixelColor': 'Color GetPixelColor(Uint8List src, PixelFormat format)',
      'SetPixelColor':
          'void SetPixelColor(Uint8List dst, Color color, PixelFormat format)',
      'GetPixelDataSize':
          'int GetPixelDataSize(int width, int height, PixelFormat format)',
    },
  ),
  'text': (
    deps: """
import 'dart:typed_data';
import 'structs.dart';
""",
    customInterfaces: {
      'LoadFontEx':
          'Font LoadFontEx(String fileName, int fontSize, List<int> codepoints)',
      'LoadFontFromMemory':
          'Font LoadFontFromMemory(String fileType, Uint8List fileData, int fontSize, List<int> codepoints)',
      'LoadFontData':
          'List<GlyphInfo> LoadFontData(Uint8List fileData, int fontSize, List<int> codepoints, int type)',
      'GenImageFontAtlas':
          '(Image, List<Rectangle>) GenImageFontAtlas(List<GlyphInfo> glyphs, int fontSize, int padding, int packMethod)',
      'UnloadFontData': 'void UnloadFontData(List<GlyphInfo> glyphs)',
      'DrawTextCodepoints':
          'void DrawTextCodepoints(Font font, List<int> codepoints, Vector2 position, double fontSize, double spacing, Color tint)',
      'MeasureTextCodepoints':
          'Vector2 MeasureTextCodepoints(Font font, List<int> codepoints, double fontSize, double spacing)',
      'LoadUTF8': 'String LoadUTF8(List<int> codepoints)',
      'UnloadUTF8': 'void UnloadUTF8(String text)',
      'LoadCodepoints': 'List<int> LoadCodepoints(String text)',
      'UnloadCodepoints': 'void UnloadCodepoints(List<int> codepoints)',
      'GetCodepoint': '(int, int) GetCodepoint(String text)',
      'GetCodepointNext': '(int, int) GetCodepointNext(String text)',
      'GetCodepointPrevious': '(int, int) GetCodepointPrevious(String text)',
      'CodepointToUTF8': 'String CodepointToUTF8(int codepoint)',
      'LoadTextLines': 'List<String> LoadTextLines(String text)',
      'UnloadTextLines': 'void UnloadTextLines(List<String> text)',
      'TextCopy': 'String TextCopy(String src)',
      'TextFormat': 'String TextFormat(String text, List<Object> args)',
      'TextJoin': 'String TextJoin(List<String> textList, String delimiter)',
      'TextSplit': 'List<String> TextSplit(String text, String delimiter)',
      'TextAppend': 'String TextAppend(String text, String append)',
    },
  ),
  'models': (
    deps: """
import 'dart:typed_data';
import 'raylib_const.dart';
import 'structs.dart';
""",
    customInterfaces: {
      'DrawTriangleStrip3D':
          'void DrawTriangleStrip3D(List<Vector3> points, Color color)',
      'UploadMesh': 'void UploadMesh(Mesh mesh, bool dynamic)',
      'UpdateMeshBuffer':
          'void UpdateMeshBuffer(Mesh mesh, int index, Uint8List data, int offset)',
      'DrawMeshInstanced':
          'void DrawMeshInstanced(Mesh mesh, Material material, List<Matrix4> transforms)',
      'GenMeshTangents': 'void GenMeshTangents(Mesh mesh)',
      'LoadMaterials': 'List<Material> LoadMaterials(String fileName)',
      'SetMaterialTexture':
          'void SetMaterialTexture(Material material, int mapType, Texture2D texture)',
      'SetModelMeshMaterial':
          'void SetModelMeshMaterial(Model model, int meshId, int materialId)',
      'LoadModelAnimations':
          'List<ModelAnimation> LoadModelAnimations(String fileName)',
      'UnloadModelAnimations':
          'void UnloadModelAnimations(List<ModelAnimation> animations)',
      'UpdateModelAnimation':
          'void UpdateModelAnimation(Model model, ModelAnimation anim, double frame)',
      'UpdateModelAnimationEx':
          'void UpdateModelAnimationEx(Model model, ModelAnimation animA, double frameA, ModelAnimation animB, double frameB, double blend)',
      'IsModelAnimationValid':
          'bool IsModelAnimationValid(Model model, ModelAnimation anim)',
    },
  ),
  'audio': (
    deps: """
import 'dart:typed_data';
import 'structs.dart';
""",
    customInterfaces: {
      'LoadWaveFromMemory':
          'Wave LoadWaveFromMemory(String fileType, Uint8List fileData)',
      'UpdateSound':
          'void UpdateSound(Sound sound, Uint8List data, int sampleCount)',
      'WaveCrop': 'void WaveCrop(Wave wave, int initFrame, int finalFrame)',
      'WaveFormat':
          'void WaveFormat(Wave wave, int sampleRate, int sampleSize, int channels)',
      'LoadWaveSamples': 'Float32List LoadWaveSamples(Wave wave)',
      'LoadMusicStreamFromMemory':
          'Music LoadMusicStreamFromMemory(String fileType, Uint8List data)',
      'UpdateAudioStream':
          'void UpdateAudioStream(AudioStream stream, Uint8List data, int frameCount)',
    },
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
    final function = parseCFunctionPrototype(api);
    final customInterface = customInterfaces[function.name];
    final returnType = toDartType(function.returnType);
    final interfaceFunc =
        customInterface ??
        '$returnType ${function.name}(${funcParamList(function.params)})';
    final needProxy =
        customInterface != null || proxyFunctions.contains(function.name);
    final callArgs = customInterface != null
        ? dartParamNames(customInterface) // 用来改变调用，比如两个参数变成了一个
        : funcCall(function.params);

    return '$interfaceFunc => '
        '${needProxy ? 'proxy' : 'raw'}.${function.name}($callArgs);';
  }

  String funcCall(List<CParam> params) {
    if (params.length == 1 && params[0].type.isVoid) {
      return '';
    }
    return params.map((p) => paramName(p.name)).join(', ');
  }

  String paramName(String name) => name == '...' ? 'args' : name;

  String dartParamNames(String interface) {
    final result = parseString(
      content: 'external $interface;',
      throwIfDiagnostics: false,
    );
    final declaration = result.unit.declarations
        .whereType<FunctionDeclaration>()
        .single;
    final params = declaration.functionExpression.parameters?.parameters ?? [];
    return params.map((p) => p.name?.lexeme).whereType<String>().join(', ');
  }

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
