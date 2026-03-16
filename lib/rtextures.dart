// ignore_for_file: non_constant_identifier_names
//
// 本文件封装 raylib 纹理模块。
//
// 尚未代理（需要先实现对应的 Dart 包装类）：
//   Image — 所有 LoadImage*, GenImage*, Image* 操作均需要 Image Dart 包装类
//   LoadImageColors, LoadImagePalette — 返回 Color* 数组，需要独立 API
//   GetPixelColor, SetPixelColor — 需要原始 void* 指针

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'package:image/image.dart' as img;
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

// ── NPatchInfo ───────────────────────────────────────────────────────────

/// Nine-patch image slice configuration.
class NPatchInfo {
  final Rectangle source;
  final int left;
  final int top;
  final int right;
  final int bottom;
  final consts.NPatchLayout layout;

  NPatchInfo({
    required this.source,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.layout,
  });
}

// ── Texture loading/management ───────────────────────────────────────────

Texture LoadTexture(String fileName) => ffi.using((arena) {
  return raylib.LoadTexture(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Texture LoadTextureFromImage(img.Image image) => ffi.using((arena) {
  return raylib.LoadTextureFromImage(arena.image(image).ref).toDart();
});

TextureCubemap LoadTextureCubemap(
  img.Image image,
  consts.CubemapLayout layout,
) => ffi.using((arena) {
  return raylib.LoadTextureCubemap(arena.image(image).ref, layout.value).toDart();
});

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
  final npi = arena<raylib.NPatchInfo>();
  npi.ref
    ..source.x = nPatchInfo.source.x
    ..source.y = nPatchInfo.source.y
    ..source.width = nPatchInfo.source.width
    ..source.height = nPatchInfo.source.height
    ..left = nPatchInfo.left
    ..top = nPatchInfo.top
    ..right = nPatchInfo.right
    ..bottom = nPatchInfo.bottom
    ..layout = nPatchInfo.layout.value;
  raylib.DrawTextureNPatch(
    arena.texture(texture).ref,
    npi.ref,
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
