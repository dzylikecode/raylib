// ignore_for_file: non_constant_identifier_names
//
// 本文件封装 raylib 纹理模块。

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'colors.dart';
import 'structs.dart';
import 'src/raylib_const.dart' as consts;

// ── Image loading ────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadImage;
// export 'src/raylib.g.dart' show LoadImageRaw;
// export 'src/raylib.g.dart' show LoadImageAnim;
// export 'src/raylib.g.dart' show LoadImageAnimFromMemory;
// export 'src/raylib.g.dart' show LoadImageFromMemory;
// export 'src/raylib.g.dart' show LoadImageFromTexture;
// export 'src/raylib.g.dart' show LoadImageFromScreen;
// export 'src/raylib.g.dart' show IsImageValid;
// export 'src/raylib.g.dart' show UnloadImage;
// export 'src/raylib.g.dart' show ExportImage;
// export 'src/raylib.g.dart' show ExportImageToMemory;
// export 'src/raylib.g.dart' show ExportImageAsCode;
// ── Image generation ─────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show GenImageColor;
// export 'src/raylib.g.dart' show GenImageGradientLinear;
// export 'src/raylib.g.dart' show GenImageGradientRadial;
// export 'src/raylib.g.dart' show GenImageGradientSquare;
// export 'src/raylib.g.dart' show GenImageChecked;
// export 'src/raylib.g.dart' show GenImageWhiteNoise;
// export 'src/raylib.g.dart' show GenImagePerlinNoise;
// export 'src/raylib.g.dart' show GenImageCellular;
// export 'src/raylib.g.dart' show GenImageText;
// ── Image manipulation ───────────────────────────────────────────────────
// export 'src/raylib.g.dart' show ImageCopy;
// export 'src/raylib.g.dart' show ImageFromImage;
// export 'src/raylib.g.dart' show ImageFromChannel;
// export 'src/raylib.g.dart' show ImageText;
// export 'src/raylib.g.dart' show ImageTextEx;
// export 'src/raylib.g.dart' show ImageFormat;
// export 'src/raylib.g.dart' show ImageToPOT;
// export 'src/raylib.g.dart' show ImageCrop;
// export 'src/raylib.g.dart' show ImageAlphaCrop;
// export 'src/raylib.g.dart' show ImageAlphaClear;
// export 'src/raylib.g.dart' show ImageAlphaMask;
// export 'src/raylib.g.dart' show ImageAlphaPremultiply;
// export 'src/raylib.g.dart' show ImageBlurGaussian;
// export 'src/raylib.g.dart' show ImageKernelConvolution;
// export 'src/raylib.g.dart' show ImageResize;
// export 'src/raylib.g.dart' show ImageResizeNN;
// export 'src/raylib.g.dart' show ImageResizeCanvas;
// export 'src/raylib.g.dart' show ImageMipmaps;
// export 'src/raylib.g.dart' show ImageDither;
// export 'src/raylib.g.dart' show ImageFlipVertical;
// export 'src/raylib.g.dart' show ImageFlipHorizontal;
// export 'src/raylib.g.dart' show ImageRotate;
// export 'src/raylib.g.dart' show ImageRotateCW;
// export 'src/raylib.g.dart' show ImageRotateCCW;
// export 'src/raylib.g.dart' show ImageColorTint;
// export 'src/raylib.g.dart' show ImageColorInvert;
// export 'src/raylib.g.dart' show ImageColorGrayscale;
// export 'src/raylib.g.dart' show ImageColorContrast;
// export 'src/raylib.g.dart' show ImageColorBrightness;
// export 'src/raylib.g.dart' show ImageColorReplace;
// export 'src/raylib.g.dart' show LoadImageColors;
// export 'src/raylib.g.dart' show LoadImagePalette;
// export 'src/raylib.g.dart' show UnloadImageColors;
// export 'src/raylib.g.dart' show UnloadImagePalette;
// export 'src/raylib.g.dart' show GetImageAlphaBorder;
// export 'src/raylib.g.dart' show GetImageColor;
// export 'src/raylib.g.dart' show ImageClearBackground;
// export 'src/raylib.g.dart' show ImageDrawPixel;
// export 'src/raylib.g.dart' show ImageDrawPixelV;
// export 'src/raylib.g.dart' show ImageDrawLine;
// export 'src/raylib.g.dart' show ImageDrawLineV;
// export 'src/raylib.g.dart' show ImageDrawLineEx;
// export 'src/raylib.g.dart' show ImageDrawCircle;
// export 'src/raylib.g.dart' show ImageDrawCircleV;
// export 'src/raylib.g.dart' show ImageDrawCircleLines;
// export 'src/raylib.g.dart' show ImageDrawCircleLinesV;
// export 'src/raylib.g.dart' show ImageDrawRectangle;
// export 'src/raylib.g.dart' show ImageDrawRectangleV;
// export 'src/raylib.g.dart' show ImageDrawRectangleRec;
// export 'src/raylib.g.dart' show ImageDrawRectangleLines;
// export 'src/raylib.g.dart' show ImageDrawTriangle;
// export 'src/raylib.g.dart' show ImageDrawTriangleEx;
// export 'src/raylib.g.dart' show ImageDrawTriangleLines;
// export 'src/raylib.g.dart' show ImageDrawTriangleFan;
// export 'src/raylib.g.dart' show ImageDrawTriangleStrip;
// export 'src/raylib.g.dart' show ImageDraw;
// export 'src/raylib.g.dart' show ImageDrawText;
// export 'src/raylib.g.dart' show ImageDrawTextEx;
// ── Texture loading/management ───────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadTexture;            // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadTextureFromImage;   // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadTextureCubemap;     // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadRenderTexture;      // → Dart wrapper below
// export 'src/raylib.g.dart' show IsTextureValid;         // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadTexture;          // → Dart wrapper below
// export 'src/raylib.g.dart' show IsRenderTextureValid;   // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadRenderTexture;    // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateTexture;          // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateTextureRec;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GenTextureMipmaps;      // → Dart wrapper below
// export 'src/raylib.g.dart' show SetTextureFilter;       // → Dart wrapper below
// export 'src/raylib.g.dart' show SetTextureWrap;         // → Dart wrapper below
// ── Texture drawing ──────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawTexture;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextureV;           // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextureEx;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextureRec;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTexturePro;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextureNPatch;      // → Dart wrapper below
// ── Color utilities ──────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show ColorIsEqual;           // → Dart wrapper below
// export 'src/raylib.g.dart' show Fade;                   // already in colors.dart
// export 'src/raylib.g.dart' show ColorToInt;             // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorNormalize;         // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorFromNormalized;    // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorToHSV;             // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorFromHSV;           // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorTint;              // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorBrightness;        // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorContrast;          // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorAlpha;             // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorAlphaBlend;        // → Dart wrapper below
// export 'src/raylib.g.dart' show ColorLerp;              // → Dart wrapper below
// export 'src/raylib.g.dart' show GetColor;               // → Dart wrapper below
// export 'src/raylib.g.dart' show GetPixelColor;          // needs void* pointer
// export 'src/raylib.g.dart' show SetPixelColor;          // needs void* pointer
// export 'src/raylib.g.dart' show GetPixelDataSize;       // → Dart wrapper below

// ── Image loading ────────────────────────────────────────────────────────

Image LoadImage(String fileName) => ffi.using((arena) {
  return raylib.LoadImage(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Image LoadImageRaw(
  String fileName,
  int width,
  int height,
  consts.PixelFormat format,
  int headerSize,
) => ffi.using((arena) {
  return raylib.LoadImageRaw(
    fileName.toNativeUtf8(allocator: arena).cast(),
    width, height, format.value, headerSize,
  ).toDart();
});

({Image image, int frames}) LoadImageAnim(String fileName) => ffi.using((arena) {
  final framesPtr = arena<Int>();
  final native = raylib.LoadImageAnim(
    fileName.toNativeUtf8(allocator: arena).cast(), framesPtr,
  );
  return (image: native.toDart(), frames: framesPtr.value);
});

({Image image, int frames}) LoadImageAnimFromMemory(
  String fileType,
  Uint8List fileData,
) => ffi.using((arena) {
  final framesPtr = arena<Int>();
  final dataPtr = arena<Uint8>(fileData.length);
  dataPtr.asTypedList(fileData.length).setAll(0, fileData);
  final native = raylib.LoadImageAnimFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    dataPtr.cast(), fileData.length, framesPtr,
  );
  return (image: native.toDart(), frames: framesPtr.value);
});

Image LoadImageFromMemory(String fileType, Uint8List fileData) => ffi.using((arena) {
  final dataPtr = arena<Uint8>(fileData.length);
  dataPtr.asTypedList(fileData.length).setAll(0, fileData);
  return raylib.LoadImageFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    dataPtr.cast(), fileData.length,
  ).toDart();
});

Image LoadImageFromTexture(Texture texture) => ffi.using((arena) {
  return raylib.LoadImageFromTexture(arena.texture(texture).ref).toDart();
});

Image LoadImageFromScreen() => raylib.LoadImageFromScreen().toDart();

bool IsImageValid(Image image) => raylib.IsImageValid(image.ptr.ref);

void UnloadImage(Image image) => image.dispose();

bool ExportImage(Image image, String fileName) => ffi.using((arena) {
  return raylib.ExportImage(
    image.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

Uint8List ExportImageToMemory(Image image, String fileType) => ffi.using((arena) {
  final sizePtr = arena<Int>();
  final data = raylib.ExportImageToMemory(
    image.ptr.ref,
    fileType.toNativeUtf8(allocator: arena).cast(),
    sizePtr,
  );
  final result = Uint8List.fromList(data.cast<Uint8>().asTypedList(sizePtr.value));
  ffi.malloc.free(data);
  return result;
});

bool ExportImageAsCode(Image image, String fileName) => ffi.using((arena) {
  return raylib.ExportImageAsCode(
    image.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

// ── Image generation ─────────────────────────────────────────────────────

Image GenImageColor(int width, int height, Color color) =>
    raylib.GenImageColor(width, height, color.ptr.ref).toDart();

Image GenImageGradientLinear(
  int width, int height, int direction, Color start, Color end,
) => raylib.GenImageGradientLinear(
  width, height, direction, start.ptr.ref, end.ptr.ref,
).toDart();

Image GenImageGradientRadial(
  int width, int height, double density, Color inner, Color outer,
) => raylib.GenImageGradientRadial(
  width, height, density, inner.ptr.ref, outer.ptr.ref,
).toDart();

Image GenImageGradientSquare(
  int width, int height, double density, Color inner, Color outer,
) => raylib.GenImageGradientSquare(
  width, height, density, inner.ptr.ref, outer.ptr.ref,
).toDart();

Image GenImageChecked(
  int width, int height, int checksX, int checksY, Color col1, Color col2,
) => raylib.GenImageChecked(
  width, height, checksX, checksY, col1.ptr.ref, col2.ptr.ref,
).toDart();

Image GenImageWhiteNoise(int width, int height, double factor) =>
    raylib.GenImageWhiteNoise(width, height, factor).toDart();

Image GenImagePerlinNoise(
  int width, int height, int offsetX, int offsetY, double scale,
) => raylib.GenImagePerlinNoise(width, height, offsetX, offsetY, scale).toDart();

Image GenImageCellular(int width, int height, int tileSize) =>
    raylib.GenImageCellular(width, height, tileSize).toDart();

Image GenImageText(int width, int height, String text) => ffi.using((arena) {
  return raylib.GenImageText(
    width, height, text.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

// ── Image manipulation ───────────────────────────────────────────────────

Image ImageCopy(Image image) =>
    raylib.ImageCopy(image.ptr.ref).toDart();

Image ImageFromImage(Image image, Rectangle rec) =>
    raylib.ImageFromImage(image.ptr.ref, rec.ptr.ref).toDart();

Image ImageFromChannel(Image image, int selectedChannel) =>
    raylib.ImageFromChannel(image.ptr.ref, selectedChannel).toDart();

Image ImageText(String text, int fontSize, Color color) => ffi.using((arena) {
  return raylib.ImageText(
    text.toNativeUtf8(allocator: arena).cast(), fontSize, color.ptr.ref,
  ).toDart();
});

Image ImageTextEx(
  Font font, String text, double fontSize, double spacing, Color tint,
) => ffi.using((arena) {
  return raylib.ImageTextEx(
    font.ptr.ref, text.toNativeUtf8(allocator: arena).cast(),
    fontSize, spacing, tint.ptr.ref,
  ).toDart();
});

void ImageFormat(Image image, consts.PixelFormat newFormat) =>
    raylib.ImageFormat(image.ptr, newFormat.value);

void ImageToPOT(Image image, Color fill) =>
    raylib.ImageToPOT(image.ptr, fill.ptr.ref);

void ImageCrop(Image image, Rectangle crop) =>
    raylib.ImageCrop(image.ptr, crop.ptr.ref);

void ImageAlphaCrop(Image image, double threshold) =>
    raylib.ImageAlphaCrop(image.ptr, threshold);

void ImageAlphaClear(Image image, Color color, double threshold) =>
    raylib.ImageAlphaClear(image.ptr, color.ptr.ref, threshold);

void ImageAlphaMask(Image image, Image alphaMask) =>
    raylib.ImageAlphaMask(image.ptr, alphaMask.ptr.ref);

void ImageAlphaPremultiply(Image image) =>
    raylib.ImageAlphaPremultiply(image.ptr);

void ImageBlurGaussian(Image image, int blurSize) =>
    raylib.ImageBlurGaussian(image.ptr, blurSize);

void ImageKernelConvolution(Image image, List<double> kernel) =>
    ffi.using((arena) {
      final kPtr = arena<Float>(kernel.length);
      for (var i = 0; i < kernel.length; i++) {
        kPtr[i] = kernel[i];
      }
      raylib.ImageKernelConvolution(image.ptr, kPtr, kernel.length);
    });

void ImageResize(Image image, int newWidth, int newHeight) =>
    raylib.ImageResize(image.ptr, newWidth, newHeight);

void ImageResizeNN(Image image, int newWidth, int newHeight) =>
    raylib.ImageResizeNN(image.ptr, newWidth, newHeight);

void ImageResizeCanvas(
  Image image, int newWidth, int newHeight,
  int offsetX, int offsetY, Color fill,
) => raylib.ImageResizeCanvas(
  image.ptr, newWidth, newHeight, offsetX, offsetY, fill.ptr.ref,
);

void ImageMipmaps(Image image) =>
    raylib.ImageMipmaps(image.ptr);

void ImageDither(Image image, int rBpp, int gBpp, int bBpp, int aBpp) =>
    raylib.ImageDither(image.ptr, rBpp, gBpp, bBpp, aBpp);

void ImageFlipVertical(Image image) =>
    raylib.ImageFlipVertical(image.ptr);

void ImageFlipHorizontal(Image image) =>
    raylib.ImageFlipHorizontal(image.ptr);

void ImageRotate(Image image, int degrees) =>
    raylib.ImageRotate(image.ptr, degrees);

void ImageRotateCW(Image image) =>
    raylib.ImageRotateCW(image.ptr);

void ImageRotateCCW(Image image) =>
    raylib.ImageRotateCCW(image.ptr);

void ImageColorTint(Image image, Color color) =>
    raylib.ImageColorTint(image.ptr, color.ptr.ref);

void ImageColorInvert(Image image) =>
    raylib.ImageColorInvert(image.ptr);

void ImageColorGrayscale(Image image) =>
    raylib.ImageColorGrayscale(image.ptr);

void ImageColorContrast(Image image, double contrast) =>
    raylib.ImageColorContrast(image.ptr, contrast);

void ImageColorBrightness(Image image, int brightness) =>
    raylib.ImageColorBrightness(image.ptr, brightness);

void ImageColorReplace(Image image, Color color, Color replace) =>
    raylib.ImageColorReplace(image.ptr, color.ptr.ref, replace.ptr.ref);

List<Color> LoadImageColors(Image image) {
  final colors = raylib.LoadImageColors(image.ptr.ref);
  final count = image.width * image.height;
  final result = List<Color>.generate(
    count,
    (i) => Color.fromRGBA(colors[i].r, colors[i].g, colors[i].b, colors[i].a),
  );
  raylib.UnloadImageColors(colors);
  return result;
}

List<Color> LoadImagePalette(Image image, int maxPaletteSize) => ffi.using((arena) {
  final countPtr = arena<Int>();
  final colors = raylib.LoadImagePalette(
    image.ptr.ref, maxPaletteSize, countPtr,
  );
  final count = countPtr.value;
  final result = List<Color>.generate(
    count,
    (i) => Color.fromRGBA(colors[i].r, colors[i].g, colors[i].b, colors[i].a),
  );
  raylib.UnloadImagePalette(colors);
  return result;
});

@Deprecated('Color list memory is managed by Dart. This is a no-op.')
void UnloadImageColors(List<Color> colors) {}

@Deprecated('Color list memory is managed by Dart. This is a no-op.')
void UnloadImagePalette(List<Color> colors) {}

Rectangle GetImageAlphaBorder(Image image, double threshold) =>
    raylib.GetImageAlphaBorder(image.ptr.ref, threshold).toDart();

Color GetImageColor(Image image, int x, int y) {
  final c = raylib.GetImageColor(image.ptr.ref, x, y);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

// ── Image drawing ────────────────────────────────────────────────────────

void ImageClearBackground(Image dst, Color color) =>
    raylib.ImageClearBackground(dst.ptr, color.ptr.ref);

void ImageDrawPixel(Image dst, int posX, int posY, Color color) =>
    raylib.ImageDrawPixel(dst.ptr, posX, posY, color.ptr.ref);

void ImageDrawPixelV(Image dst, Vector2 position, Color color) =>
    ffi.using((arena) {
      raylib.ImageDrawPixelV(dst.ptr, arena.vector2(position).ref, color.ptr.ref);
    });

void ImageDrawLine(
  Image dst, int startPosX, int startPosY,
  int endPosX, int endPosY, Color color,
) => raylib.ImageDrawLine(
  dst.ptr, startPosX, startPosY, endPosX, endPosY, color.ptr.ref,
);

void ImageDrawLineV(
  Image dst, Vector2 start, Vector2 end, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawLineV(
    dst.ptr, arena.vector2(start).ref, arena.vector2(end).ref, color.ptr.ref,
  );
});

void ImageDrawLineEx(
  Image dst, Vector2 start, Vector2 end, int thick, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawLineEx(
    dst.ptr, arena.vector2(start).ref, arena.vector2(end).ref, thick, color.ptr.ref,
  );
});

void ImageDrawCircle(
  Image dst, int centerX, int centerY, int radius, Color color,
) => raylib.ImageDrawCircle(dst.ptr, centerX, centerY, radius, color.ptr.ref);

void ImageDrawCircleV(
  Image dst, Vector2 center, int radius, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawCircleV(dst.ptr, arena.vector2(center).ref, radius, color.ptr.ref);
});

void ImageDrawCircleLines(
  Image dst, int centerX, int centerY, int radius, Color color,
) => raylib.ImageDrawCircleLines(dst.ptr, centerX, centerY, radius, color.ptr.ref);

void ImageDrawCircleLinesV(
  Image dst, Vector2 center, int radius, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawCircleLinesV(
    dst.ptr, arena.vector2(center).ref, radius, color.ptr.ref,
  );
});

void ImageDrawRectangle(
  Image dst, int posX, int posY, int width, int height, Color color,
) => raylib.ImageDrawRectangle(dst.ptr, posX, posY, width, height, color.ptr.ref);

void ImageDrawRectangleV(
  Image dst, Vector2 position, Vector2 size, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawRectangleV(
    dst.ptr, arena.vector2(position).ref, arena.vector2(size).ref, color.ptr.ref,
  );
});

void ImageDrawRectangleRec(Image dst, Rectangle rec, Color color) =>
    raylib.ImageDrawRectangleRec(dst.ptr, rec.ptr.ref, color.ptr.ref);

void ImageDrawRectangleLines(
  Image dst, Rectangle rec, int thick, Color color,
) => raylib.ImageDrawRectangleLines(dst.ptr, rec.ptr.ref, thick, color.ptr.ref);

void ImageDrawTriangle(
  Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawTriangle(
    dst.ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref,
    arena.vector2(v3).ref, color.ptr.ref,
  );
});

void ImageDrawTriangleEx(
  Image dst, Vector2 v1, Vector2 v2, Vector2 v3,
  Color c1, Color c2, Color c3,
) => ffi.using((arena) {
  raylib.ImageDrawTriangleEx(
    dst.ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref, arena.vector2(v3).ref,
    c1.ptr.ref, c2.ptr.ref, c3.ptr.ref,
  );
});

void ImageDrawTriangleLines(
  Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawTriangleLines(
    dst.ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref,
    arena.vector2(v3).ref, color.ptr.ref,
  );
});

void ImageDrawTriangleFan(Image dst, List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raylib.ImageDrawTriangleFan(
        dst.ptr, arena.vector2s(points), points.length, color.ptr.ref,
      );
    });

void ImageDrawTriangleStrip(Image dst, List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raylib.ImageDrawTriangleStrip(
        dst.ptr, arena.vector2s(points), points.length, color.ptr.ref,
      );
    });

void ImageDraw(
  Image dst, Image src,
  Rectangle srcRec, Rectangle dstRec, Color tint,
) => raylib.ImageDraw(
  dst.ptr, src.ptr.ref,
  srcRec.ptr.ref, dstRec.ptr.ref, tint.ptr.ref,
);

void ImageDrawText(
  Image dst, String text,
  int posX, int posY, int fontSize, Color color,
) => ffi.using((arena) {
  raylib.ImageDrawText(
    dst.ptr, text.toNativeUtf8(allocator: arena).cast(),
    posX, posY, fontSize, color.ptr.ref,
  );
});

void ImageDrawTextEx(
  Image dst, Font font, String text,
  Vector2 position, double fontSize, double spacing, Color tint,
) => ffi.using((arena) {
  raylib.ImageDrawTextEx(
    dst.ptr, font.ptr.ref, text.toNativeUtf8(allocator: arena).cast(),
    arena.vector2(position).ref, fontSize, spacing, tint.ptr.ref,
  );
});

// ── Texture loading/management ───────────────────────────────────────────

Texture LoadTexture(String fileName) => ffi.using((arena) {
  return raylib.LoadTexture(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Texture LoadTextureFromImage(Image image) =>
    raylib.LoadTextureFromImage(image.ptr.ref).toDart();

TextureCubemap LoadTextureCubemap(
  Image image,
  consts.CubemapLayout layout,
) => raylib.LoadTextureCubemap(image.ptr.ref, layout.value).toDart();

RenderTexture2D LoadRenderTexture(int width, int height) =>
    raylib.LoadRenderTexture(width, height).toDart();

bool IsTextureValid(Texture texture) => ffi.using((arena) {
  return raylib.IsTextureValid(arena.texture(texture).ref);
});

void UnloadTexture(Texture texture) => ffi.using((arena) {
  raylib.UnloadTexture(arena.texture(texture).ref);
});

bool IsRenderTextureValid(RenderTexture2D target) => ffi.using((arena) {
  return raylib.IsRenderTextureValid(arena.renderTexture(target).ref);
});

void UnloadRenderTexture(RenderTexture2D target) => ffi.using((arena) {
  raylib.UnloadRenderTexture(arena.renderTexture(target).ref);
});

void UpdateTexture(Texture texture, Uint8List pixels) => ffi.using((arena) {
  final ptr = arena<Uint8>(pixels.length);
  ptr.asTypedList(pixels.length).setAll(0, pixels);
  raylib.UpdateTexture(arena.texture(texture).ref, ptr.cast());
});

void UpdateTextureRec(
  Texture texture,
  Rectangle rec,
  Uint8List pixels,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(pixels.length);
  ptr.asTypedList(pixels.length).setAll(0, pixels);
  raylib.UpdateTextureRec(arena.texture(texture).ref, rec.ptr.ref, ptr.cast());
});

/// Generates mipmaps for [texture] and returns an updated [Texture] with the
/// new mipmap count.
Texture GenTextureMipmaps(Texture texture) => ffi.using((arena) {
  final ptr = arena.texture(texture);
  raylib.GenTextureMipmaps(ptr);
  return ptr.ref.toDart();
});

void SetTextureFilter(Texture texture, consts.TextureFilter filter) =>
    ffi.using((arena) {
      raylib.SetTextureFilter(arena.texture(texture).ref, filter.value);
    });

void SetTextureWrap(Texture texture, consts.TextureWrap wrap) =>
    ffi.using((arena) {
      raylib.SetTextureWrap(arena.texture(texture).ref, wrap.value);
    });

// ── Texture drawing ──────────────────────────────────────────────────────

void DrawTexture(Texture texture, int posX, int posY, Color tint) =>
    ffi.using((arena) {
      raylib.DrawTexture(arena.texture(texture).ref, posX, posY, tint.ptr.ref);
    });

void DrawTextureV(Texture texture, Vector2 position, Color tint) =>
    ffi.using((arena) {
      raylib.DrawTextureV(
        arena.texture(texture).ref,
        arena.vector2(position).ref,
        tint.ptr.ref,
      );
    });

void DrawTextureEx(
  Texture texture,
  Vector2 position,
  double rotation,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawTextureEx(
    arena.texture(texture).ref,
    arena.vector2(position).ref,
    rotation,
    scale,
    tint.ptr.ref,
  );
});

void DrawTextureRec(
  Texture texture,
  Rectangle source,
  Vector2 position,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawTextureRec(
    arena.texture(texture).ref,
    source.ptr.ref,
    arena.vector2(position).ref,
    tint.ptr.ref,
  );
});

void DrawTexturePro(
  Texture texture,
  Rectangle source,
  Rectangle dest,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawTexturePro(
    arena.texture(texture).ref,
    source.ptr.ref,
    dest.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    tint.ptr.ref,
  );
});

void DrawTextureNPatch(
  Texture texture,
  NPatchInfo nPatchInfo,
  Rectangle dest,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawTextureNPatch(
    arena.texture(texture).ref,
    arena.nPatchInfo(nPatchInfo).ref,
    dest.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    tint.ptr.ref,
  );
});

// ── Color utilities ──────────────────────────────────────────────────────

bool ColorIsEqual(Color col1, Color col2) =>
    raylib.ColorIsEqual(col1.ptr.ref, col2.ptr.ref);

int ColorToInt(Color color) => raylib.ColorToInt(color.ptr.ref);

/// Returns RGBA components normalized to [0, 1].
Vector4 ColorNormalize(Color color) {
  final v = raylib.ColorNormalize(color.ptr.ref);
  return Vector4(v.x, v.y, v.z, v.w);
}

Color ColorFromNormalized(Vector4 normalized) => ffi.using((arena) {
  final v = arena<raylib.Vector4>();
  v.ref
    ..x = normalized.x
    ..y = normalized.y
    ..z = normalized.z
    ..w = normalized.w;
  final c = raylib.ColorFromNormalized(v.ref);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
});

/// Returns hue, saturation, value as a [Vector3] (x=hue°, y=saturation, z=value).
Vector3 ColorToHSV(Color color) {
  final v = raylib.ColorToHSV(color.ptr.ref);
  return Vector3(v.x, v.y, v.z);
}

Color ColorFromHSV(double hue, double saturation, double value) {
  final c = raylib.ColorFromHSV(hue, saturation, value);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorTint(Color color, Color tint) {
  final c = raylib.ColorTint(color.ptr.ref, tint.ptr.ref);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorBrightness(Color color, double factor) {
  final c = raylib.ColorBrightness(color.ptr.ref, factor);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorContrast(Color color, double contrast) {
  final c = raylib.ColorContrast(color.ptr.ref, contrast);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorAlpha(Color color, double alpha) {
  final c = raylib.ColorAlpha(color.ptr.ref, alpha);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorAlphaBlend(Color dst, Color src, Color tint) {
  final c = raylib.ColorAlphaBlend(dst.ptr.ref, src.ptr.ref, tint.ptr.ref);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color ColorLerp(Color color1, Color color2, double factor) {
  final c = raylib.ColorLerp(color1.ptr.ref, color2.ptr.ref, factor);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

Color GetColor(int hexValue) {
  final c = raylib.GetColor(hexValue);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}

int GetPixelDataSize(int width, int height, consts.PixelFormat format) =>
    raylib.GetPixelDataSize(width, height, format.value);
