// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:cdart/cdart.dart';
import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'structs.dart';

Pointer<Int> _codepoints(ffi.Arena arena, List<int> codepoints) {
  if (codepoints.isEmpty) return nullptr;
  final ptr = arena<Int>(codepoints.length);
  ptr.cast<Int32>().asTypedList(codepoints.length).setAll(0, codepoints);
  return ptr;
}

Pointer<UnsignedChar> _bytes(ffi.Arena arena, Uint8List data) {
  final ptr = arena<UnsignedChar>(data.length);
  ptr.cast<Uint8>().asTypedList(data.length).setAll(0, data);
  return ptr;
}

Font LoadFontEx(String fileName, int fontSize, List<int> codepoints) =>
    ffi.using((arena) {
      return raw.LoadFontEx(
        fileName.toNativeUtf8(allocator: arena).cast(),
        fontSize,
        _codepoints(arena, codepoints),
        codepoints.length,
      ).toDart();
    });

Font LoadFontFromMemory(
  String fileType,
  Uint8List fileData,
  int fontSize,
  List<int> codepoints,
) => ffi.using((arena) {
  return raw.LoadFontFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    _bytes(arena, fileData),
    fileData.length,
    fontSize,
    _codepoints(arena, codepoints),
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
    _bytes(arena, fileData),
    fileData.length,
    fontSize,
    _codepoints(arena, codepoints),
    codepoints.length,
    type,
    glyphCount,
  );
  final result = [for (var i = 0; i < glyphCount.value; i++) ptr[i].toDart()];
  raw.UnloadFontData(ptr, glyphCount.value);
  return result;
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
    _codepoints(arena, codepoints),
    codepoints.length,
    arena.vector2(position).ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
});

Vector2 MeasureTextCodepoints(
  Font font,
  List<int> codepoints,
  double fontSize,
  double spacing,
) => ffi.using((arena) {
  return raw.MeasureTextCodepoints(
    font.ptr.ref,
    _codepoints(arena, codepoints),
    codepoints.length,
    fontSize,
    spacing,
  ).toDart();
});

String LoadUTF8(List<int> codepoints) => ffi.using((arena) {
  final ptr = raw.LoadUTF8(_codepoints(arena, codepoints), codepoints.length);
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

String TextCopy(String src) => src;

String TextFormat(String text, List<Object> args) => sprintf(text, args)!;

String TextJoin(List<String> textList, String delimiter) =>
    textList.join(delimiter);

List<String> TextSplit(String text, String delimiter) => text.split(delimiter);

String TextAppend(String text, String append) => text + append;
