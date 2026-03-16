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

// ── Image helpers (private) ─────────────────────────────────────────────

/// Allocates a native raylib.Image with C-malloc'd pixel data.
/// Compatible with raylib's RL_FREE; use for in-place Image operations.
Pointer<raylib.Image> _mallocImage(img.Image value) {
  final Uint8List bytes;
  if (value.numChannels == 4 && value.format == img.Format.uint8) {
    bytes = value.getBytes(order: img.ChannelOrder.rgba);
  } else {
    bytes = Uint8List(value.width * value.height * 4);
    var i = 0;
    for (final pixel in value) {
      bytes[i++] = (pixel.rNormalized * 255).round();
      bytes[i++] = (pixel.gNormalized * 255).round();
      bytes[i++] = (pixel.bNormalized * 255).round();
      bytes[i++] = (pixel.aNormalized * 255).round();
    }
  }
  final dataPtr = ffi.malloc<Uint8>(bytes.length);
  dataPtr.asTypedList(bytes.length).setAll(0, bytes);
  final ptr = ffi.malloc<raylib.Image>();
  ptr.ref
    ..data = dataPtr.cast()
    ..width = value.width
    ..height = value.height
    ..mipmaps = 1
    ..format = consts.PixelFormat.uncompressedR8g8b8a8.value;
  return ptr;
}

/// Converts img.Image → native, runs [fn] (may modify in-place),
/// converts back to img.Image, and frees native memory.
img.Image _withMutableImage(img.Image image, void Function(Pointer<raylib.Image>) fn) {
  final ptr = _mallocImage(image);
  fn(ptr);
  final result = ptr.ref.toDart();
  raylib.UnloadImage(ptr.ref);
  ffi.malloc.free(ptr);
  return result;
}

// ── Image loading ────────────────────────────────────────────────────────

img.Image LoadImage(String fileName) => ffi.using((arena) {
  final native = raylib.LoadImage(fileName.toNativeUtf8(allocator: arena).cast());
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image LoadImageRaw(
  String fileName,
  int width,
  int height,
  consts.PixelFormat format,
  int headerSize,
) => ffi.using((arena) {
  final native = raylib.LoadImageRaw(
    fileName.toNativeUtf8(allocator: arena).cast(),
    width, height, format.value, headerSize,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

({img.Image image, int frames}) LoadImageAnim(String fileName) => ffi.using((arena) {
  final framesPtr = arena<Int>();
  final native = raylib.LoadImageAnim(
    fileName.toNativeUtf8(allocator: arena).cast(), framesPtr,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return (image: result, frames: framesPtr.value);
});

({img.Image image, int frames}) LoadImageAnimFromMemory(
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
  final result = native.toDart();
  raylib.UnloadImage(native);
  return (image: result, frames: framesPtr.value);
});

img.Image LoadImageFromMemory(String fileType, Uint8List fileData) => ffi.using((arena) {
  final dataPtr = arena<Uint8>(fileData.length);
  dataPtr.asTypedList(fileData.length).setAll(0, fileData);
  final native = raylib.LoadImageFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    dataPtr.cast(), fileData.length,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image LoadImageFromTexture(Texture texture) => ffi.using((arena) {
  final native = raylib.LoadImageFromTexture(arena.texture(texture).ref);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image LoadImageFromScreen() {
  final native = raylib.LoadImageFromScreen();
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

bool IsImageValid(img.Image image) => ffi.using((arena) {
  return raylib.IsImageValid(arena.image(image).ref);
});

@Deprecated('Image memory is managed by Dart. This is a no-op.')
void UnloadImage(img.Image image) {}

bool ExportImage(img.Image image, String fileName) => ffi.using((arena) {
  return raylib.ExportImage(
    arena.image(image).ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

Uint8List ExportImageToMemory(img.Image image, String fileType) => ffi.using((arena) {
  final sizePtr = arena<Int>();
  final data = raylib.ExportImageToMemory(
    arena.image(image).ref,
    fileType.toNativeUtf8(allocator: arena).cast(),
    sizePtr,
  );
  final result = Uint8List.fromList(data.cast<Uint8>().asTypedList(sizePtr.value));
  ffi.malloc.free(data);
  return result;
});

bool ExportImageAsCode(img.Image image, String fileName) => ffi.using((arena) {
  return raylib.ExportImageAsCode(
    arena.image(image).ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

// ── Image generation ─────────────────────────────────────────────────────

img.Image GenImageColor(int width, int height, Color color) {
  final native = raylib.GenImageColor(width, height, color.ptr.ref);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageGradientLinear(
  int width, int height, int direction, Color start, Color end,
) {
  final native = raylib.GenImageGradientLinear(
    width, height, direction, start.ptr.ref, end.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageGradientRadial(
  int width, int height, double density, Color inner, Color outer,
) {
  final native = raylib.GenImageGradientRadial(
    width, height, density, inner.ptr.ref, outer.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageGradientSquare(
  int width, int height, double density, Color inner, Color outer,
) {
  final native = raylib.GenImageGradientSquare(
    width, height, density, inner.ptr.ref, outer.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageChecked(
  int width, int height, int checksX, int checksY, Color col1, Color col2,
) {
  final native = raylib.GenImageChecked(
    width, height, checksX, checksY, col1.ptr.ref, col2.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageWhiteNoise(int width, int height, double factor) {
  final native = raylib.GenImageWhiteNoise(width, height, factor);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImagePerlinNoise(
  int width, int height, int offsetX, int offsetY, double scale,
) {
  final native = raylib.GenImagePerlinNoise(
    width, height, offsetX, offsetY, scale,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageCellular(int width, int height, int tileSize) {
  final native = raylib.GenImageCellular(width, height, tileSize);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
}

img.Image GenImageText(int width, int height, String text) => ffi.using((arena) {
  final native = raylib.GenImageText(
    width, height, text.toNativeUtf8(allocator: arena).cast(),
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

// ── Image manipulation ───────────────────────────────────────────────────

img.Image ImageCopy(img.Image image) => ffi.using((arena) {
  final native = raylib.ImageCopy(arena.image(image).ref);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image ImageFromImage(img.Image image, Rectangle rec) => ffi.using((arena) {
  final native = raylib.ImageFromImage(arena.image(image).ref, rec.ptr.ref);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image ImageFromChannel(img.Image image, int selectedChannel) => ffi.using((arena) {
  final native = raylib.ImageFromChannel(arena.image(image).ref, selectedChannel);
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image ImageText(String text, int fontSize, Color color) => ffi.using((arena) {
  final native = raylib.ImageText(
    text.toNativeUtf8(allocator: arena).cast(), fontSize, color.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image ImageTextEx(
  Font font, String text, double fontSize, double spacing, Color tint,
) => ffi.using((arena) {
  final native = raylib.ImageTextEx(
    font.ptr.ref, text.toNativeUtf8(allocator: arena).cast(),
    fontSize, spacing, tint.ptr.ref,
  );
  final result = native.toDart();
  raylib.UnloadImage(native);
  return result;
});

img.Image ImageFormat(img.Image image, consts.PixelFormat newFormat) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageFormat(ptr, newFormat.value);
    });

img.Image ImageToPOT(img.Image image, Color fill) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageToPOT(ptr, fill.ptr.ref);
    });

img.Image ImageCrop(img.Image image, Rectangle crop) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageCrop(ptr, crop.ptr.ref);
    });

img.Image ImageAlphaCrop(img.Image image, double threshold) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageAlphaCrop(ptr, threshold);
    });

img.Image ImageAlphaClear(img.Image image, Color color, double threshold) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageAlphaClear(ptr, color.ptr.ref, threshold);
    });

img.Image ImageAlphaMask(img.Image image, img.Image alphaMask) =>
    _withMutableImage(image, (ptr) => ffi.using((arena) {
      raylib.ImageAlphaMask(ptr, arena.image(alphaMask).ref);
    }));

img.Image ImageAlphaPremultiply(img.Image image) =>
    _withMutableImage(image, raylib.ImageAlphaPremultiply);

img.Image ImageBlurGaussian(img.Image image, int blurSize) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageBlurGaussian(ptr, blurSize);
    });

img.Image ImageKernelConvolution(img.Image image, List<double> kernel) =>
    _withMutableImage(image, (ptr) => ffi.using((arena) {
      final kPtr = arena<Float>(kernel.length);
      for (var i = 0; i < kernel.length; i++) {
        kPtr[i] = kernel[i];
      }
      raylib.ImageKernelConvolution(ptr, kPtr, kernel.length);
    }));

img.Image ImageResize(img.Image image, int newWidth, int newHeight) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageResize(ptr, newWidth, newHeight);
    });

img.Image ImageResizeNN(img.Image image, int newWidth, int newHeight) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageResizeNN(ptr, newWidth, newHeight);
    });

img.Image ImageResizeCanvas(
  img.Image image, int newWidth, int newHeight,
  int offsetX, int offsetY, Color fill,
) => _withMutableImage(image, (ptr) {
  raylib.ImageResizeCanvas(
    ptr, newWidth, newHeight, offsetX, offsetY, fill.ptr.ref,
  );
});

img.Image ImageMipmaps(img.Image image) =>
    _withMutableImage(image, raylib.ImageMipmaps);

img.Image ImageDither(img.Image image, int rBpp, int gBpp, int bBpp, int aBpp) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageDither(ptr, rBpp, gBpp, bBpp, aBpp);
    });

img.Image ImageFlipVertical(img.Image image) =>
    _withMutableImage(image, raylib.ImageFlipVertical);

img.Image ImageFlipHorizontal(img.Image image) =>
    _withMutableImage(image, raylib.ImageFlipHorizontal);

img.Image ImageRotate(img.Image image, int degrees) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageRotate(ptr, degrees);
    });

img.Image ImageRotateCW(img.Image image) =>
    _withMutableImage(image, raylib.ImageRotateCW);

img.Image ImageRotateCCW(img.Image image) =>
    _withMutableImage(image, raylib.ImageRotateCCW);

img.Image ImageColorTint(img.Image image, Color color) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageColorTint(ptr, color.ptr.ref);
    });

img.Image ImageColorInvert(img.Image image) =>
    _withMutableImage(image, raylib.ImageColorInvert);

img.Image ImageColorGrayscale(img.Image image) =>
    _withMutableImage(image, raylib.ImageColorGrayscale);

img.Image ImageColorContrast(img.Image image, double contrast) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageColorContrast(ptr, contrast);
    });

img.Image ImageColorBrightness(img.Image image, int brightness) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageColorBrightness(ptr, brightness);
    });

img.Image ImageColorReplace(img.Image image, Color color, Color replace) =>
    _withMutableImage(image, (ptr) {
      raylib.ImageColorReplace(ptr, color.ptr.ref, replace.ptr.ref);
    });

List<Color> LoadImageColors(img.Image image) => ffi.using((arena) {
  final colors = raylib.LoadImageColors(arena.image(image).ref);
  final count = image.width * image.height;
  final result = List<Color>.generate(
    count,
    (i) => Color.fromRGBA(colors[i].r, colors[i].g, colors[i].b, colors[i].a),
  );
  raylib.UnloadImageColors(colors);
  return result;
});

List<Color> LoadImagePalette(img.Image image, int maxPaletteSize) => ffi.using((arena) {
  final countPtr = arena<Int>();
  final colors = raylib.LoadImagePalette(
    arena.image(image).ref, maxPaletteSize, countPtr,
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

Rectangle GetImageAlphaBorder(img.Image image, double threshold) => ffi.using((arena) {
  return raylib.GetImageAlphaBorder(arena.image(image).ref, threshold).toDart();
});

Color GetImageColor(img.Image image, int x, int y) => ffi.using((arena) {
  final c = raylib.GetImageColor(arena.image(image).ref, x, y);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
});

// ── Image drawing ────────────────────────────────────────────────────────

img.Image ImageClearBackground(img.Image dst, Color color) =>
    _withMutableImage(dst, (ptr) {
      raylib.ImageClearBackground(ptr, color.ptr.ref);
    });

img.Image ImageDrawPixel(img.Image dst, int posX, int posY, Color color) =>
    _withMutableImage(dst, (ptr) {
      raylib.ImageDrawPixel(ptr, posX, posY, color.ptr.ref);
    });

img.Image ImageDrawPixelV(img.Image dst, Vector2 position, Color color) =>
    _withMutableImage(dst, (ptr) => ffi.using((arena) {
      raylib.ImageDrawPixelV(ptr, arena.vector2(position).ref, color.ptr.ref);
    }));

img.Image ImageDrawLine(
  img.Image dst, int startPosX, int startPosY,
  int endPosX, int endPosY, Color color,
) => _withMutableImage(dst, (ptr) {
  raylib.ImageDrawLine(
    ptr, startPosX, startPosY, endPosX, endPosY, color.ptr.ref,
  );
});

img.Image ImageDrawLineV(
  img.Image dst, Vector2 start, Vector2 end, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawLineV(
    ptr, arena.vector2(start).ref, arena.vector2(end).ref, color.ptr.ref,
  );
}));

img.Image ImageDrawLineEx(
  img.Image dst, Vector2 start, Vector2 end, int thick, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawLineEx(
    ptr, arena.vector2(start).ref, arena.vector2(end).ref, thick, color.ptr.ref,
  );
}));

img.Image ImageDrawCircle(
  img.Image dst, int centerX, int centerY, int radius, Color color,
) => _withMutableImage(dst, (ptr) {
  raylib.ImageDrawCircle(ptr, centerX, centerY, radius, color.ptr.ref);
});

img.Image ImageDrawCircleV(
  img.Image dst, Vector2 center, int radius, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawCircleV(ptr, arena.vector2(center).ref, radius, color.ptr.ref);
}));

img.Image ImageDrawCircleLines(
  img.Image dst, int centerX, int centerY, int radius, Color color,
) => _withMutableImage(dst, (ptr) {
  raylib.ImageDrawCircleLines(ptr, centerX, centerY, radius, color.ptr.ref);
});

img.Image ImageDrawCircleLinesV(
  img.Image dst, Vector2 center, int radius, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawCircleLinesV(
    ptr, arena.vector2(center).ref, radius, color.ptr.ref,
  );
}));

img.Image ImageDrawRectangle(
  img.Image dst, int posX, int posY, int width, int height, Color color,
) => _withMutableImage(dst, (ptr) {
  raylib.ImageDrawRectangle(ptr, posX, posY, width, height, color.ptr.ref);
});

img.Image ImageDrawRectangleV(
  img.Image dst, Vector2 position, Vector2 size, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawRectangleV(
    ptr, arena.vector2(position).ref, arena.vector2(size).ref, color.ptr.ref,
  );
}));

img.Image ImageDrawRectangleRec(img.Image dst, Rectangle rec, Color color) =>
    _withMutableImage(dst, (ptr) {
      raylib.ImageDrawRectangleRec(ptr, rec.ptr.ref, color.ptr.ref);
    });

img.Image ImageDrawRectangleLines(
  img.Image dst, Rectangle rec, int thick, Color color,
) => _withMutableImage(dst, (ptr) {
  raylib.ImageDrawRectangleLines(ptr, rec.ptr.ref, thick, color.ptr.ref);
});

img.Image ImageDrawTriangle(
  img.Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawTriangle(
    ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref,
    arena.vector2(v3).ref, color.ptr.ref,
  );
}));

img.Image ImageDrawTriangleEx(
  img.Image dst, Vector2 v1, Vector2 v2, Vector2 v3,
  Color c1, Color c2, Color c3,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawTriangleEx(
    ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref, arena.vector2(v3).ref,
    c1.ptr.ref, c2.ptr.ref, c3.ptr.ref,
  );
}));

img.Image ImageDrawTriangleLines(
  img.Image dst, Vector2 v1, Vector2 v2, Vector2 v3, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawTriangleLines(
    ptr,
    arena.vector2(v1).ref, arena.vector2(v2).ref,
    arena.vector2(v3).ref, color.ptr.ref,
  );
}));

img.Image ImageDrawTriangleFan(img.Image dst, List<Vector2> points, Color color) =>
    _withMutableImage(dst, (ptr) => ffi.using((arena) {
      raylib.ImageDrawTriangleFan(
        ptr, arena.vector2s(points), points.length, color.ptr.ref,
      );
    }));

img.Image ImageDrawTriangleStrip(img.Image dst, List<Vector2> points, Color color) =>
    _withMutableImage(dst, (ptr) => ffi.using((arena) {
      raylib.ImageDrawTriangleStrip(
        ptr, arena.vector2s(points), points.length, color.ptr.ref,
      );
    }));

img.Image ImageDraw(
  img.Image dst, img.Image src,
  Rectangle srcRec, Rectangle dstRec, Color tint,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDraw(
    ptr, arena.image(src).ref,
    srcRec.ptr.ref, dstRec.ptr.ref, tint.ptr.ref,
  );
}));

img.Image ImageDrawText(
  img.Image dst, String text,
  int posX, int posY, int fontSize, Color color,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawText(
    ptr, text.toNativeUtf8(allocator: arena).cast(),
    posX, posY, fontSize, color.ptr.ref,
  );
}));

img.Image ImageDrawTextEx(
  img.Image dst, Font font, String text,
  Vector2 position, double fontSize, double spacing, Color tint,
) => _withMutableImage(dst, (ptr) => ffi.using((arena) {
  raylib.ImageDrawTextEx(
    ptr, font.ptr.ref, text.toNativeUtf8(allocator: arena).cast(),
    arena.vector2(position).ref, fontSize, spacing, tint.ptr.ref,
  );
}));

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
