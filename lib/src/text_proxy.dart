// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cdart/cdart.dart';
import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'structs.dart';

String _string(Pointer<Char> ptr) => ptr.cast<ffi.Utf8>().toDartString();

String _allocatedString(Pointer<Char> ptr) {
  final result = _string(ptr);
  raw.MemFree(ptr.cast());
  return result;
}

Font GetFontDefault() => raw.GetFontDefault().toDart();

Font LoadFont(String fileName) => ffi.using((arena) {
  return raw.LoadFont(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Font LoadFontEx(String fileName, int fontSize, List<int> codepoints) =>
    ffi.using((arena) {
      return raw.LoadFontEx(
        fileName.toNativeUtf8(allocator: arena).cast(),
        fontSize,
        arena.codepoints(codepoints),
        codepoints.length,
      ).toDart();
    });

Font LoadFontFromImage(Image image, Color key, int firstChar) =>
    raw.LoadFontFromImage(image.ptr.ref, key.ptr.ref, firstChar).toDart();

Font LoadFontFromMemory(
  String fileType,
  Uint8List fileData,
  int fontSize,
  List<int> codepoints,
) => ffi.using((arena) {
  return raw.LoadFontFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    arena.bytes(fileData),
    fileData.length,
    fontSize,
    arena.codepoints(codepoints),
    codepoints.length,
  ).toDart();
});

List<GlyphInfo> LoadFontData(
  Uint8List fileData,
  int fontSize,
  List<int> codepoints,
  int type,
) => ffi.using((arena) {
  final glyphCount = arena<Int>();
  final ptr = raw.LoadFontData(
    arena.bytes(fileData),
    fileData.length,
    fontSize,
    arena.codepoints(codepoints),
    codepoints.length,
    type,
    glyphCount,
  );
  final result = [for (var i = 0; i < glyphCount.value; i++) ptr[i].toDart()];
  raw.UnloadFontData(ptr, glyphCount.value);
  return result;
});

(Image, List<Rectangle>) GenImageFontAtlas(
  List<GlyphInfo> glyphs,
  int fontSize,
  int padding,
  int packMethod,
) => ffi.using((arena) {
  final glyphRecs = arena<Pointer<raw.Rectangle>>();
  final image = raw.GenImageFontAtlas(
    arena.glyphInfos(glyphs),
    glyphRecs.cast(),
    glyphs.length,
    fontSize,
    padding,
    packMethod,
  );
  final recs = [
    for (var i = 0; i < glyphs.length; i++) glyphRecs.value[i].toDart(),
  ];
  return (image.toDart(), recs);
});

void UnloadFontData(List<GlyphInfo> glyphs) {}

bool IsFontValid(Font font) => raw.IsFontValid(font.ptr.ref);

void UnloadFont(Font font) => font.dispose();

bool ExportFontAsCode(Font font, String fileName) => ffi.using((arena) {
  return raw.ExportFontAsCode(
    font.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

void DrawText(String text, int posX, int posY, int fontSize, Color color) =>
    ffi.using((arena) {
      raw.DrawText(
        text.toNativeUtf8(allocator: arena).cast(),
        posX,
        posY,
        fontSize,
        color.ptr.ref,
      );
    });

void DrawTextEx(
  Font font,
  String text,
  Vector2 position,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextEx(
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    arena.vector2(position).ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
});

void DrawTextPro(
  Font font,
  String text,
  Vector2 position,
  Vector2 origin,
  double rotation,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextPro(
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    arena.vector2(position).ref,
    arena.vector2(origin).ref,
    rotation,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
});

void DrawTextCodepoint(
  Font font,
  int codepoint,
  Vector2 position,
  double fontSize,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextCodepoint(
    font.ptr.ref,
    codepoint,
    arena.vector2(position).ref,
    fontSize,
    tint.ptr.ref,
  );
});

void DrawTextCodepoints(
  Font font,
  List<int> codepoints,
  Vector2 position,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  raw.DrawTextCodepoints(
    font.ptr.ref,
    arena.codepoints(codepoints),
    codepoints.length,
    arena.vector2(position).ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
});

int MeasureText(String text, int fontSize) => ffi.using((arena) {
  return raw.MeasureText(text.toNativeUtf8(allocator: arena).cast(), fontSize);
});

Vector2 MeasureTextEx(
  Font font,
  String text,
  double fontSize,
  double spacing,
) => ffi.using((arena) {
  return raw.MeasureTextEx(
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
    spacing,
  ).toDart();
});

Vector2 MeasureTextCodepoints(
  Font font,
  List<int> codepoints,
  double fontSize,
  double spacing,
) => ffi.using((arena) {
  return raw.MeasureTextCodepoints(
    font.ptr.ref,
    arena.codepoints(codepoints),
    codepoints.length,
    fontSize,
    spacing,
  ).toDart();
});

int GetGlyphIndex(Font font, int codepoint) =>
    raw.GetGlyphIndex(font.ptr.ref, codepoint);

GlyphInfo GetGlyphInfo(Font font, int codepoint) =>
    raw.GetGlyphInfo(font.ptr.ref, codepoint).toDart();

Rectangle GetGlyphAtlasRec(Font font, int codepoint) =>
    raw.GetGlyphAtlasRec(font.ptr.ref, codepoint).toDart();

String LoadUTF8(List<int> codepoints) => ffi.using((arena) {
  final ptr = raw.LoadUTF8(arena.codepoints(codepoints), codepoints.length);
  final result = ptr.cast<ffi.Utf8>().toDartString();
  raw.UnloadUTF8(ptr);
  return result;
});

List<int> LoadCodepoints(String text) => ffi.using((arena) {
  final count = arena<Int>();
  final ptr = raw.LoadCodepoints(
    text.toNativeUtf8(allocator: arena).cast(),
    count,
  );
  final result = List<int>.generate(count.value, (i) => ptr[i]);
  raw.UnloadCodepoints(ptr);
  return result;
});

int GetCodepointCount(String text) => ffi.using((arena) {
  return raw.GetCodepointCount(text.toNativeUtf8(allocator: arena).cast());
});

(int, int) GetCodepoint(String text) => ffi.using((arena) {
  final size = arena<Int>();
  final codepoint = raw.GetCodepoint(
    text.toNativeUtf8(allocator: arena).cast(),
    size,
  );
  return (codepoint, size.value);
});

(int, int) GetCodepointNext(String text) => ffi.using((arena) {
  final size = arena<Int>();
  final codepoint = raw.GetCodepointNext(
    text.toNativeUtf8(allocator: arena).cast(),
    size,
  );
  return (codepoint, size.value);
});

(int, int) GetCodepointPrevious(String text) => ffi.using((arena) {
  final size = arena<Int>();
  final codepoint = raw.GetCodepointPrevious(
    text.toNativeUtf8(allocator: arena).cast(),
    size,
  );
  return (codepoint, size.value);
});

String CodepointToUTF8(int codepoint) => ffi.using((arena) {
  final size = arena<Int>();
  final ptr = raw.CodepointToUTF8(codepoint, size);
  return ptr.cast<ffi.Utf8>().toDartString(length: size.value);
});

void UnloadUTF8(String text) {}

void UnloadCodepoints(List<int> codepoints) {}

List<String> LoadTextLines(String text) => ffi.using((arena) {
  final count = arena<Int>();
  final ptr = raw.LoadTextLines(
    text.toNativeUtf8(allocator: arena).cast(),
    count,
  );
  final result = [
    for (var i = 0; i < count.value; i++)
      ptr[i].cast<ffi.Utf8>().toDartString(),
  ];
  raw.UnloadTextLines(ptr, count.value);
  return result;
});

void UnloadTextLines(List<String> text) {}

String TextCopy(String src) => src;

bool TextIsEqual(String text1, String text2) => ffi.using((arena) {
  return raw.TextIsEqual(
    text1.toNativeUtf8(allocator: arena).cast(),
    text2.toNativeUtf8(allocator: arena).cast(),
  );
});

int TextLength(String text) => ffi.using((arena) {
  return raw.TextLength(text.toNativeUtf8(allocator: arena).cast());
});

String TextFormat(String text, List<Object> args) => sprintf(text, args)!;

String TextSubtext(String text, int position, int length) => ffi.using((arena) {
  return _string(
    raw.TextSubtext(
      text.toNativeUtf8(allocator: arena).cast(),
      position,
      length,
    ),
  );
});

String TextRemoveSpaces(String text) => ffi.using((arena) {
  return _string(
    raw.TextRemoveSpaces(text.toNativeUtf8(allocator: arena).cast()),
  );
});

String GetTextBetween(String text, String begin, String end) =>
    ffi.using((arena) {
      return _string(
        raw.GetTextBetween(
          text.toNativeUtf8(allocator: arena).cast(),
          begin.toNativeUtf8(allocator: arena).cast(),
          end.toNativeUtf8(allocator: arena).cast(),
        ),
      );
    });

String TextReplace(String text, String search, String replacement) =>
    ffi.using((arena) {
      return _string(
        raw.TextReplace(
          text.toNativeUtf8(allocator: arena).cast(),
          search.toNativeUtf8(allocator: arena).cast(),
          replacement.toNativeUtf8(allocator: arena).cast(),
        ),
      );
    });

String TextReplaceAlloc(String text, String search, String replacement) =>
    ffi.using((arena) {
      return _allocatedString(
        raw.TextReplaceAlloc(
          text.toNativeUtf8(allocator: arena).cast(),
          search.toNativeUtf8(allocator: arena).cast(),
          replacement.toNativeUtf8(allocator: arena).cast(),
        ),
      );
    });

String TextReplaceBetween(
  String text,
  String begin,
  String end,
  String replacement,
) => ffi.using((arena) {
  return _string(
    raw.TextReplaceBetween(
      text.toNativeUtf8(allocator: arena).cast(),
      begin.toNativeUtf8(allocator: arena).cast(),
      end.toNativeUtf8(allocator: arena).cast(),
      replacement.toNativeUtf8(allocator: arena).cast(),
    ),
  );
});

String TextReplaceBetweenAlloc(
  String text,
  String begin,
  String end,
  String replacement,
) => ffi.using((arena) {
  return _allocatedString(
    raw.TextReplaceBetweenAlloc(
      text.toNativeUtf8(allocator: arena).cast(),
      begin.toNativeUtf8(allocator: arena).cast(),
      end.toNativeUtf8(allocator: arena).cast(),
      replacement.toNativeUtf8(allocator: arena).cast(),
    ),
  );
});

String TextInsert(String text, String insert, int position) =>
    ffi.using((arena) {
      return _string(
        raw.TextInsert(
          text.toNativeUtf8(allocator: arena).cast(),
          insert.toNativeUtf8(allocator: arena).cast(),
          position,
        ),
      );
    });

String TextInsertAlloc(String text, String insert, int position) =>
    ffi.using((arena) {
      return _allocatedString(
        raw.TextInsertAlloc(
          text.toNativeUtf8(allocator: arena).cast(),
          insert.toNativeUtf8(allocator: arena).cast(),
          position,
        ),
      );
    });

String TextJoin(List<String> textList, String delimiter) =>
    textList.join(delimiter);

List<String> TextSplit(String text, String delimiter) => text.split(delimiter);

String TextAppend(String text, String append) => text + append;

int TextFindIndex(String text, String search) => ffi.using((arena) {
  return raw.TextFindIndex(
    text.toNativeUtf8(allocator: arena).cast(),
    search.toNativeUtf8(allocator: arena).cast(),
  );
});

String TextToUpper(String text) => ffi.using((arena) {
  return _string(raw.TextToUpper(text.toNativeUtf8(allocator: arena).cast()));
});

String TextToLower(String text) => ffi.using((arena) {
  return _string(raw.TextToLower(text.toNativeUtf8(allocator: arena).cast()));
});

String TextToPascal(String text) => ffi.using((arena) {
  return _string(raw.TextToPascal(text.toNativeUtf8(allocator: arena).cast()));
});

String TextToSnake(String text) => ffi.using((arena) {
  return _string(raw.TextToSnake(text.toNativeUtf8(allocator: arena).cast()));
});

String TextToCamel(String text) => ffi.using((arena) {
  return _string(raw.TextToCamel(text.toNativeUtf8(allocator: arena).cast()));
});

int TextToInteger(String text) => ffi.using((arena) {
  return raw.TextToInteger(text.toNativeUtf8(allocator: arena).cast());
});

double TextToFloat(String text) => ffi.using((arena) {
  return raw.TextToFloat(text.toNativeUtf8(allocator: arena).cast());
});
