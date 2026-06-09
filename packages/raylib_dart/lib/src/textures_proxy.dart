// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'raylib_const.dart';
import 'structs.dart';

raw.Color _color(Color color) => color.ptr.ref;

Color _dartColor(raw.Color color) =>
    Color.fromRGBA(color.r, color.g, color.b, color.a);

Pointer<Uint8> _uint8s(ffi.Arena arena, Uint8List data) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return ptr;
}

Pointer<Float> _floats(ffi.Arena arena, List<double> values) {
  final ptr = arena<Float>(values.length);
  ptr.asTypedList(values.length).setAll(0, values);
  return ptr;
}

Pointer<raw.Vector4> _vector4(ffi.Arena arena, Vector4 value) {
  final ptr = arena<raw.Vector4>();
  ptr.ref
    ..x = value.x
    ..y = value.y
    ..z = value.z
    ..w = value.w;
  return ptr;
}

void _setOutInt(List<int> output, int value) {
  if (output.isEmpty) {
    output.add(value);
  } else {
    output[0] = value;
  }
}

Image LoadImage(String fileName) => ffi.using((arena) {
  return raw.LoadImage(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Image LoadImageRaw(
  String fileName,
  int width,
  int height,
  PixelFormat format,
  int headerSize,
) => ffi.using((arena) {
  return raw.LoadImageRaw(
    fileName.toNativeUtf8(allocator: arena).cast(),
    width,
    height,
    format.value,
    headerSize,
  ).toDart();
});

Image LoadImageAnim(String fileName, List<int> frames) => ffi.using((arena) {
  final framesPtr = arena<Int>();
  final image = raw.LoadImageAnim(
    fileName.toNativeUtf8(allocator: arena).cast(),
    framesPtr,
  );
  _setOutInt(frames, framesPtr.value);
  return image.toDart();
});

Image LoadImageAnimFromMemory(
  String fileType,
  Uint8List fileData,
  List<int> frames,
) => ffi.using((arena) {
  final framesPtr = arena<Int>();
  final image = raw.LoadImageAnimFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    _uint8s(arena, fileData).cast<UnsignedChar>(),
    fileData.length,
    framesPtr,
  );
  _setOutInt(frames, framesPtr.value);
  return image.toDart();
});

Image LoadImageFromMemory(String fileType, Uint8List fileData) =>
    ffi.using((arena) {
      return raw.LoadImageFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        _uint8s(arena, fileData).cast<UnsignedChar>(),
        fileData.length,
      ).toDart();
    });

Image LoadImageFromTexture(Texture2D texture) => ffi.using((arena) {
  return raw.LoadImageFromTexture(arena.texture(texture).ref).toDart();
});

Image LoadImageFromScreen() => raw.LoadImageFromScreen().toDart();

bool IsImageValid(Image image) => raw.IsImageValid(image.ptr.ref);

void UnloadImage(Image image) => image.dispose();

bool ExportImage(Image image, String fileName) => ffi.using((arena) {
  return raw.ExportImage(
    image.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

Uint8List ExportImageToMemory(Image image, String fileType) =>
    ffi.using((arena) {
      final fileSize = arena<Int>();
      final result = raw.ExportImageToMemory(
        image.ptr.ref,
        fileType.toNativeUtf8(allocator: arena).cast(),
        fileSize,
      );
      final bytes = Uint8List.fromList(
        result.cast<Uint8>().asTypedList(fileSize.value),
      );
      raw.MemFree(result.cast());
      return bytes;
    });

bool ExportImageAsCode(Image image, String fileName) => ffi.using((arena) {
  return raw.ExportImageAsCode(
    image.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

Image GenImageColor(int width, int height, Color color) =>
    raw.GenImageColor(width, height, _color(color)).toDart();

Image GenImageGradientLinear(
  int width,
  int height,
  int direction,
  Color start,
  Color end,
) => raw.GenImageGradientLinear(
  width,
  height,
  direction,
  _color(start),
  _color(end),
).toDart();

Image GenImageGradientRadial(
  int width,
  int height,
  double density,
  Color inner,
  Color outer,
) => raw.GenImageGradientRadial(
  width,
  height,
  density,
  _color(inner),
  _color(outer),
).toDart();

Image GenImageGradientSquare(
  int width,
  int height,
  double density,
  Color inner,
  Color outer,
) => raw.GenImageGradientSquare(
  width,
  height,
  density,
  _color(inner),
  _color(outer),
).toDart();

Image GenImageChecked(
  int width,
  int height,
  int checksX,
  int checksY,
  Color col1,
  Color col2,
) => raw.GenImageChecked(
  width,
  height,
  checksX,
  checksY,
  _color(col1),
  _color(col2),
).toDart();

Image GenImageWhiteNoise(int width, int height, double factor) =>
    raw.GenImageWhiteNoise(width, height, factor).toDart();

Image GenImagePerlinNoise(
  int width,
  int height,
  int offsetX,
  int offsetY,
  double scale,
) => raw.GenImagePerlinNoise(width, height, offsetX, offsetY, scale).toDart();

Image GenImageCellular(int width, int height, int tileSize) =>
    raw.GenImageCellular(width, height, tileSize).toDart();

Image GenImageText(int width, int height, String text) => ffi.using((arena) {
  return raw.GenImageText(
    width,
    height,
    text.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Image ImageCopy(Image image) => raw.ImageCopy(image.ptr.ref).toDart();

Image ImageFromImage(Image image, Rectangle rec) =>
    raw.ImageFromImage(image.ptr.ref, rec.ptr.ref).toDart();

Image ImageFromChannel(Image image, int selectedChannel) =>
    raw.ImageFromChannel(image.ptr.ref, selectedChannel).toDart();

Image ImageText(String text, int fontSize, Color color) => ffi.using((arena) {
  return raw.ImageText(
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
    _color(color),
  ).toDart();
});

Image ImageTextEx(
  Font font,
  String text,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  return raw.ImageTextEx(
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
    spacing,
    _color(tint),
  ).toDart();
});

void ImageFormat(Image image, PixelFormat newFormat) =>
    raw.ImageFormat(image.ptr, newFormat.value);

void ImageToPOT(Image image, Color fill) =>
    raw.ImageToPOT(image.ptr, _color(fill));

void ImageCrop(Image image, Rectangle crop) =>
    raw.ImageCrop(image.ptr, crop.ptr.ref);

void ImageAlphaCrop(Image image, double threshold) =>
    raw.ImageAlphaCrop(image.ptr, threshold);

void ImageAlphaClear(Image image, Color color, double threshold) =>
    raw.ImageAlphaClear(image.ptr, _color(color), threshold);

void ImageAlphaMask(Image image, Image alphaMask) =>
    raw.ImageAlphaMask(image.ptr, alphaMask.ptr.ref);

void ImageAlphaPremultiply(Image image) => raw.ImageAlphaPremultiply(image.ptr);

void ImageBlurGaussian(Image image, int blurSize) =>
    raw.ImageBlurGaussian(image.ptr, blurSize);

void ImageKernelConvolution(Image image, List<double> kernel) => ffi.using((
  arena,
) {
  raw.ImageKernelConvolution(image.ptr, _floats(arena, kernel), kernel.length);
});

void ImageResize(Image image, int newWidth, int newHeight) =>
    raw.ImageResize(image.ptr, newWidth, newHeight);

void ImageResizeNN(Image image, int newWidth, int newHeight) =>
    raw.ImageResizeNN(image.ptr, newWidth, newHeight);

void ImageResizeCanvas(
  Image image,
  int newWidth,
  int newHeight,
  int offsetX,
  int offsetY,
  Color fill,
) => raw.ImageResizeCanvas(
  image.ptr,
  newWidth,
  newHeight,
  offsetX,
  offsetY,
  _color(fill),
);

void ImageMipmaps(Image image) => raw.ImageMipmaps(image.ptr);

void ImageDither(Image image, int rBpp, int gBpp, int bBpp, int aBpp) =>
    raw.ImageDither(image.ptr, rBpp, gBpp, bBpp, aBpp);

void ImageFlipVertical(Image image) => raw.ImageFlipVertical(image.ptr);

void ImageFlipHorizontal(Image image) => raw.ImageFlipHorizontal(image.ptr);

void ImageRotate(Image image, int degrees) =>
    raw.ImageRotate(image.ptr, degrees);

void ImageRotateCW(Image image) => raw.ImageRotateCW(image.ptr);

void ImageRotateCCW(Image image) => raw.ImageRotateCCW(image.ptr);

void ImageColorTint(Image image, Color color) =>
    raw.ImageColorTint(image.ptr, _color(color));

void ImageColorInvert(Image image) => raw.ImageColorInvert(image.ptr);

void ImageColorGrayscale(Image image) => raw.ImageColorGrayscale(image.ptr);

void ImageColorContrast(Image image, double contrast) =>
    raw.ImageColorContrast(image.ptr, contrast);

void ImageColorBrightness(Image image, int brightness) =>
    raw.ImageColorBrightness(image.ptr, brightness);

void ImageColorReplace(Image image, Color color, Color replace) =>
    raw.ImageColorReplace(image.ptr, _color(color), _color(replace));

List<Color> LoadImageColors(Image image) {
  final ptr = raw.LoadImageColors(image.ptr.ref);
  final count = image.width * image.height;
  final result = [for (var i = 0; i < count; i++) _dartColor(ptr[i])];
  raw.UnloadImageColors(ptr);
  return result;
}

List<Color> LoadImagePalette(Image image, int maxPaletteSize) => ffi.using((
  arena,
) {
  final colorCount = arena<Int>();
  final ptr = raw.LoadImagePalette(image.ptr.ref, maxPaletteSize, colorCount);
  final result = [
    for (var i = 0; i < colorCount.value; i++) _dartColor(ptr[i]),
  ];
  raw.UnloadImagePalette(ptr);
  return result;
});

void UnloadImageColors(List<Color> colors) {}

void UnloadImagePalette(List<Color> colors) {}

Rectangle GetImageAlphaBorder(Image image, double threshold) =>
    raw.GetImageAlphaBorder(image.ptr.ref, threshold).toDart();

Color GetImageColor(Image image, int x, int y) =>
    _dartColor(raw.GetImageColor(image.ptr.ref, x, y));

void ImageClearBackground(Image dst, Color color) =>
    raw.ImageClearBackground(dst.ptr, _color(color));

void ImageDrawPixel(Image dst, int posX, int posY, Color color) =>
    raw.ImageDrawPixel(dst.ptr, posX, posY, _color(color));

void ImageDrawPixelV(Image dst, Vector2 position, Color color) =>
    ffi.using((arena) {
      raw.ImageDrawPixelV(dst.ptr, arena.vector2(position).ref, _color(color));
    });

void ImageDrawLine(
  Image dst,
  int startPosX,
  int startPosY,
  int endPosX,
  int endPosY,
  Color color,
) => raw.ImageDrawLine(
  dst.ptr,
  startPosX,
  startPosY,
  endPosX,
  endPosY,
  _color(color),
);

void ImageDrawLineV(Image dst, Vector2 start, Vector2 end, Color color) =>
    ffi.using((arena) {
      raw.ImageDrawLineV(
        dst.ptr,
        arena.vector2(start).ref,
        arena.vector2(end).ref,
        _color(color),
      );
    });

void ImageDrawLineEx(
  Image dst,
  Vector2 start,
  Vector2 end,
  int thick,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawLineEx(
    dst.ptr,
    arena.vector2(start).ref,
    arena.vector2(end).ref,
    thick,
    _color(color),
  );
});

void ImageDrawCircle(
  Image dst,
  int centerX,
  int centerY,
  int radius,
  Color color,
) => raw.ImageDrawCircle(dst.ptr, centerX, centerY, radius, _color(color));

void ImageDrawCircleV(Image dst, Vector2 center, int radius, Color color) =>
    ffi.using((arena) {
      raw.ImageDrawCircleV(
        dst.ptr,
        arena.vector2(center).ref,
        radius,
        _color(color),
      );
    });

void ImageDrawCircleLines(
  Image dst,
  int centerX,
  int centerY,
  int radius,
  Color color,
) => raw.ImageDrawCircleLines(dst.ptr, centerX, centerY, radius, _color(color));

void ImageDrawCircleLinesV(
  Image dst,
  Vector2 center,
  int radius,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawCircleLinesV(
    dst.ptr,
    arena.vector2(center).ref,
    radius,
    _color(color),
  );
});

void ImageDrawRectangle(
  Image dst,
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raw.ImageDrawRectangle(dst.ptr, posX, posY, width, height, _color(color));

void ImageDrawRectangleV(
  Image dst,
  Vector2 position,
  Vector2 size,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawRectangleV(
    dst.ptr,
    arena.vector2(position).ref,
    arena.vector2(size).ref,
    _color(color),
  );
});

void ImageDrawRectangleRec(Image dst, Rectangle rec, Color color) =>
    raw.ImageDrawRectangleRec(dst.ptr, rec.ptr.ref, _color(color));

void ImageDrawRectangleLines(
  Image dst,
  Rectangle rec,
  int thick,
  Color color,
) => raw.ImageDrawRectangleLines(dst.ptr, rec.ptr.ref, thick, _color(color));

void ImageDrawTriangle(
  Image dst,
  Vector2 v1,
  Vector2 v2,
  Vector2 v3,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawTriangle(
    dst.ptr,
    arena.vector2(v1).ref,
    arena.vector2(v2).ref,
    arena.vector2(v3).ref,
    _color(color),
  );
});

void ImageDrawTriangleEx(
  Image dst,
  Vector2 v1,
  Vector2 v2,
  Vector2 v3,
  Color c1,
  Color c2,
  Color c3,
) => ffi.using((arena) {
  raw.ImageDrawTriangleEx(
    dst.ptr,
    arena.vector2(v1).ref,
    arena.vector2(v2).ref,
    arena.vector2(v3).ref,
    _color(c1),
    _color(c2),
    _color(c3),
  );
});

void ImageDrawTriangleLines(
  Image dst,
  Vector2 v1,
  Vector2 v2,
  Vector2 v3,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawTriangleLines(
    dst.ptr,
    arena.vector2(v1).ref,
    arena.vector2(v2).ref,
    arena.vector2(v3).ref,
    _color(color),
  );
});

void ImageDrawTriangleFan(Image dst, List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raw.ImageDrawTriangleFan(
        dst.ptr,
        arena.vector2s(points),
        points.length,
        _color(color),
      );
    });

void ImageDrawTriangleStrip(Image dst, List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raw.ImageDrawTriangleStrip(
        dst.ptr,
        arena.vector2s(points),
        points.length,
        _color(color),
      );
    });

void ImageDraw(
  Image dst,
  Image src,
  Rectangle srcRec,
  Rectangle dstRec,
  Color tint,
) => raw.ImageDraw(
  dst.ptr,
  src.ptr.ref,
  srcRec.ptr.ref,
  dstRec.ptr.ref,
  _color(tint),
);

void ImageDrawText(
  Image dst,
  String text,
  int posX,
  int posY,
  int fontSize,
  Color color,
) => ffi.using((arena) {
  raw.ImageDrawText(
    dst.ptr,
    text.toNativeUtf8(allocator: arena).cast(),
    posX,
    posY,
    fontSize,
    _color(color),
  );
});

void ImageDrawTextEx(
  Image dst,
  Font font,
  String text,
  Vector2 position,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  raw.ImageDrawTextEx(
    dst.ptr,
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    arena.vector2(position).ref,
    fontSize,
    spacing,
    _color(tint),
  );
});

Texture2D LoadTexture(String fileName) => ffi.using((arena) {
  return raw.LoadTexture(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Texture2D LoadTextureFromImage(Image image) =>
    raw.LoadTextureFromImage(image.ptr.ref).toDart();

TextureCubemap LoadTextureCubemap(Image image, CubemapLayout layout) =>
    raw.LoadTextureCubemap(image.ptr.ref, layout.value).toDart();

RenderTexture2D LoadRenderTexture(int width, int height) =>
    raw.LoadRenderTexture(width, height).toDart();

bool IsTextureValid(Texture2D texture) => ffi.using((arena) {
  return raw.IsTextureValid(arena.texture(texture).ref);
});

void UnloadTexture(Texture2D texture) => ffi.using((arena) {
  raw.UnloadTexture(arena.texture(texture).ref);
});

bool IsRenderTextureValid(RenderTexture2D target) => ffi.using((arena) {
  return raw.IsRenderTextureValid(arena.renderTexture(target).ref);
});

void UnloadRenderTexture(RenderTexture2D target) => ffi.using((arena) {
  raw.UnloadRenderTexture(arena.renderTexture(target).ref);
});

void UpdateTexture(Texture2D texture, Uint8List pixels) => ffi.using((arena) {
  raw.UpdateTexture(arena.texture(texture).ref, _uint8s(arena, pixels).cast());
});

void UpdateTextureRec(Texture2D texture, Rectangle rec, Uint8List pixels) =>
    ffi.using((arena) {
      raw.UpdateTextureRec(
        arena.texture(texture).ref,
        rec.ptr.ref,
        _uint8s(arena, pixels).cast(),
      );
    });

Texture2D GenTextureMipmaps(Texture2D texture) => ffi.using((arena) {
  final ptr = arena.texture(texture);
  raw.GenTextureMipmaps(ptr);
  return ptr.ref.toDart();
});

void SetTextureFilter(Texture2D texture, TextureFilter filter) =>
    ffi.using((arena) {
      raw.SetTextureFilter(arena.texture(texture).ref, filter.value);
    });

void SetTextureWrap(Texture2D texture, TextureWrap wrap) => ffi.using((arena) {
  raw.SetTextureWrap(arena.texture(texture).ref, wrap.value);
});

void DrawTexture(Texture2D texture, int posX, int posY, Color tint) =>
    ffi.using((arena) {
      raw.DrawTexture(arena.texture(texture).ref, posX, posY, _color(tint));
    });

void DrawTextureV(Texture2D texture, Vector2 position, Color tint) =>
    ffi.using((arena) {
      raw.DrawTextureV(
        arena.texture(texture).ref,
        arena.vector2(position).ref,
        _color(tint),
      );
    });

void DrawTextureEx(
  Texture2D texture,
  Vector2 position,
  double rotation,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextureEx(
    arena.texture(texture).ref,
    arena.vector2(position).ref,
    rotation,
    scale,
    _color(tint),
  );
});

void DrawTextureRec(
  Texture2D texture,
  Rectangle source,
  Vector2 position,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextureRec(
    arena.texture(texture).ref,
    source.ptr.ref,
    arena.vector2(position).ref,
    _color(tint),
  );
});

void DrawTexturePro(
  Texture2D texture,
  Rectangle source,
  Rectangle dest,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTexturePro(
    arena.texture(texture).ref,
    source.ptr.ref,
    dest.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    _color(tint),
  );
});

void DrawTextureNPatch(
  Texture2D texture,
  NPatchInfo nPatchInfo,
  Rectangle dest,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextureNPatch(
    arena.texture(texture).ref,
    arena.nPatchInfo(nPatchInfo).ref,
    dest.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    _color(tint),
  );
});

bool ColorIsEqual(Color col1, Color col2) =>
    raw.ColorIsEqual(_color(col1), _color(col2));

Color Fade(Color color, double alpha) =>
    _dartColor(raw.Fade(_color(color), alpha));

int ColorToInt(Color color) => raw.ColorToInt(_color(color));

Vector4 ColorNormalize(Color color) =>
    raw.ColorNormalize(_color(color)).toDart();

Color ColorFromNormalized(Vector4 normalized) => ffi.using((arena) {
  return _dartColor(raw.ColorFromNormalized(_vector4(arena, normalized).ref));
});

Vector3 ColorToHSV(Color color) => raw.ColorToHSV(_color(color)).toDart();

Color ColorFromHSV(double hue, double saturation, double value) =>
    _dartColor(raw.ColorFromHSV(hue, saturation, value));

Color ColorTint(Color color, Color tint) =>
    _dartColor(raw.ColorTint(_color(color), _color(tint)));

Color ColorBrightness(Color color, double factor) =>
    _dartColor(raw.ColorBrightness(_color(color), factor));

Color ColorContrast(Color color, double contrast) =>
    _dartColor(raw.ColorContrast(_color(color), contrast));

Color ColorAlpha(Color color, double alpha) =>
    _dartColor(raw.ColorAlpha(_color(color), alpha));

Color ColorAlphaBlend(Color dst, Color src, Color tint) =>
    _dartColor(raw.ColorAlphaBlend(_color(dst), _color(src), _color(tint)));

Color ColorLerp(Color color1, Color color2, double factor) =>
    _dartColor(raw.ColorLerp(_color(color1), _color(color2), factor));

Color GetColor(int hexValue) => _dartColor(raw.GetColor(hexValue));

Color GetPixelColor(Uint8List src, PixelFormat format) => ffi.using((arena) {
  return _dartColor(
    raw.GetPixelColor(_uint8s(arena, src).cast(), format.value),
  );
});

void SetPixelColor(Uint8List dst, Color color, PixelFormat format) =>
    ffi.using((arena) {
      final ptr = _uint8s(arena, dst);
      raw.SetPixelColor(ptr.cast(), _color(color), format.value);
      dst.setAll(0, ptr.asTypedList(dst.length));
    });

int GetPixelDataSize(int width, int height, PixelFormat format) =>
    raw.GetPixelDataSize(width, height, format.value);
