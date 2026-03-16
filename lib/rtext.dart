// ignore_for_file: non_constant_identifier_names
//
// TextCopy 无法实现，因为传递 dst 拿到的是"引用的副本"，不是底层内存地址让你随便写

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'package:cdart/stdio.dart';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';

// ── Font loading/unloading ───────────────────────────────────────────────
// export 'src/raylib.g.dart' show GetFontDefault;      // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadFont;            // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadFontEx;          // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadFontFromImage;   // needs Image wrapper
// export 'src/raylib.g.dart' show LoadFontFromMemory;  // → Dart wrapper below
// export 'src/raylib.g.dart' show IsFontValid;         // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadFontData;        // raw GlyphInfo* — skip
// export 'src/raylib.g.dart' show GenImageFontAtlas;   // returns Image — skip
// export 'src/raylib.g.dart' show UnloadFontData;      // raw GlyphInfo* — skip
// export 'src/raylib.g.dart' show UnloadFont;          // → Dart wrapper below
// export 'src/raylib.g.dart' show ExportFontAsCode;    // → Dart wrapper below

// ── Text drawing ────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show DrawFPS;
// export 'src/raylib.g.dart' show DrawText;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextEx;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextPro;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextCodepoint;   // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextCodepoints;  // → Dart wrapper below

// ── Text font info ──────────────────────────────────────────────────────
export 'src/raylib.g.dart' show SetTextLineSpacing;
// export 'src/raylib.g.dart' show MeasureText;         // → Dart wrapper below
// export 'src/raylib.g.dart' show MeasureTextEx;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphIndex;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphInfo;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphAtlasRec;    // → Dart wrapper below

// ── Text codepoints management ──────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadUTF8;            // C memory management — use Dart strings
// export 'src/raylib.g.dart' show UnloadUTF8;          // C memory management — use Dart strings
// export 'src/raylib.g.dart' show LoadCodepoints;      // C memory management — use Dart strings
// export 'src/raylib.g.dart' show UnloadCodepoints;    // C memory management — use Dart strings
// export 'src/raylib.g.dart' show GetCodepointCount;   // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepoint;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepointNext;    // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepointPrevious; // → Dart wrapper below
// export 'src/raylib.g.dart' show CodepointToUTF8;     // C memory management — use Dart strings

// ── Text strings management ─────────────────────────────────────────────
// export 'src/raylib.g.dart' show TextCopy;            // writes to char* dst — skip (use string assignment)
// export 'src/raylib.g.dart' show TextIsEqual;         // → Dart wrapper below (deprecated, use ==)
// export 'src/raylib.g.dart' show TextLength;          // → Dart wrapper below (deprecated, use .length)
// export 'src/raylib.g.dart' show TextFormat;          // → Dart wrapper below (deprecated, use string interpolation)
// export 'src/raylib.g.dart' show TextSubtext;         // → Dart wrapper below (deprecated, use .substring())
// export 'src/raylib.g.dart' show TextReplace;         // → Dart wrapper below (deprecated, use .replaceAll())
// export 'src/raylib.g.dart' show TextInsert;          // → Dart wrapper below (deprecated, use + / interpolation)
// export 'src/raylib.g.dart' show TextJoin;            // → Dart wrapper below (deprecated, use .join())
// export 'src/raylib.g.dart' show TextSplit;           // → Dart wrapper below (deprecated, use .split())
// export 'src/raylib.g.dart' show TextAppend;          // → Dart wrapper below (deprecated, use +=)
// export 'src/raylib.g.dart' show TextFindIndex;       // → Dart wrapper below (deprecated, use .indexOf())
// export 'src/raylib.g.dart' show TextToUpper;         // → Dart wrapper below (deprecated, use .toUpperCase())
// export 'src/raylib.g.dart' show TextToLower;         // → Dart wrapper below (deprecated, use .toLowerCase())
// export 'src/raylib.g.dart' show TextToPascal;        // → Dart wrapper below
// export 'src/raylib.g.dart' show TextToSnake;         // → Dart wrapper below
// export 'src/raylib.g.dart' show TextToCamel;         // → Dart wrapper below
// export 'src/raylib.g.dart' show TextToInteger;       // → Dart wrapper below (deprecated, use int.parse())
// export 'src/raylib.g.dart' show TextToFloat;         // → Dart wrapper below (deprecated, use double.parse())

// ── Font loading/unloading ───────────────────────────────────────────────

Font GetFontDefault() => raylib.GetFontDefault().toDart();

Font LoadFont(String fileName) => ffi.using((arena) {
  return raylib.LoadFont(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

/// Loads a font with custom [fontSize] and optional [codepoints].
/// If [codepoints] is null, the default ASCII charset is loaded.
Font LoadFontEx(String fileName, int fontSize, [List<int>? codepoints]) =>
    ffi.using((arena) {
      final Pointer<Int> cpPtr;
      final int cpCount;
      if (codepoints == null) {
        cpPtr = nullptr;
        cpCount = 0;
      } else {
        cpPtr = arena<Int>(codepoints.length);
        for (var i = 0; i < codepoints.length; i++) {
          cpPtr[i] = codepoints[i];
        }
        cpCount = codepoints.length;
      }
      return raylib.LoadFontEx(
        fileName.toNativeUtf8(allocator: arena).cast(),
        fontSize,
        cpPtr,
        cpCount,
      ).toDart();
    });

/// Loads a font from [fileData] bytes with the given [fileType] extension
/// (e.g. `".ttf"`). Pass [codepoints] to restrict the glyph set.
Font LoadFontFromMemory(
  String fileType,
  Uint8List fileData,
  int fontSize, [
  List<int>? codepoints,
]) => ffi.using((arena) {
  final dataPtr = arena<Uint8>(fileData.length);
  dataPtr.asTypedList(fileData.length).setAll(0, fileData);
  final Pointer<Int> cpPtr;
  final int cpCount;
  if (codepoints == null) {
    cpPtr = nullptr;
    cpCount = 0;
  } else {
    cpPtr = arena<Int>(codepoints.length);
    for (var i = 0; i < codepoints.length; i++) {
      cpPtr[i] = codepoints[i];
    }
    cpCount = codepoints.length;
  }
  return raylib.LoadFontFromMemory(
    fileType.toNativeUtf8(allocator: arena).cast(),
    dataPtr.cast(),
    fileData.length,
    fontSize,
    cpPtr,
    cpCount,
  ).toDart();
});

bool IsFontValid(Font font) => raylib.IsFontValid(font.ptr.ref);

void UnloadFont(Font font) => font.dispose();

bool ExportFontAsCode(Font font, String fileName) => ffi.using((arena) {
  return raylib.ExportFontAsCode(
    font.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

// ── Text drawing ────────────────────────────────────────────────────────

void DrawText(String text, int posX, int posY, int fontSize, Color color) =>
    ffi.using((arena) {
      raylib.DrawText(
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
  raylib.DrawTextEx(
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
  raylib.DrawTextPro(
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
  raylib.DrawTextCodepoint(
    font.ptr.ref,
    codepoint,
    arena.vector2(position).ref,
    fontSize,
    tint.ptr.ref,
  );
});

/// [codepoints] replaces the C `int *codepoints, int codepointCount` pair.
void DrawTextCodepoints(
  Font font,
  List<int> codepoints,
  Vector2 position,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  final cpPtr = arena<Int>(codepoints.length);
  for (var i = 0; i < codepoints.length; i++) {
    cpPtr[i] = codepoints[i];
  }
  raylib.DrawTextCodepoints(
    font.ptr.ref,
    cpPtr,
    codepoints.length,
    arena.vector2(position).ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
});

// ── Text font info ──────────────────────────────────────────────────────

int MeasureText(String text, int fontSize) => ffi.using((arena) {
  return raylib.MeasureText(
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
  );
});

Vector2 MeasureTextEx(
  Font font,
  String text,
  double fontSize,
  double spacing,
) => ffi.using((arena) {
  return raylib.MeasureTextEx(
    font.ptr.ref,
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
    spacing,
  ).toDart();
});

int GetGlyphIndex(Font font, int codepoint) =>
    raylib.GetGlyphIndex(font.ptr.ref, codepoint);

GlyphInfo GetGlyphInfo(Font font, int codepoint) {
  final g = raylib.GetGlyphInfo(font.ptr.ref, codepoint);
  return GlyphInfo(
    value: g.value,
    offsetX: g.offsetX,
    offsetY: g.offsetY,
    advanceX: g.advanceX,
  );
}

Rectangle GetGlyphAtlasRec(Font font, int codepoint) =>
    raylib.GetGlyphAtlasRec(font.ptr.ref, codepoint).toDart();

// ── Text codepoints management ──────────────────────────────────────────

int GetCodepointCount(String text) => ffi.using((arena) {
  return raylib.GetCodepointCount(text.toNativeUtf8(allocator: arena).cast());
});

/// Returns the codepoint at the start of [text] together with the number of
/// UTF-8 bytes consumed.
(int codepoint, int bytesRead) GetCodepoint(String text) => ffi.using((arena) {
  final sizePtr = arena<Int>();
  final cp = raylib.GetCodepoint(
    text.toNativeUtf8(allocator: arena).cast(),
    sizePtr,
  );
  return (cp, sizePtr.value);
});

/// Returns the next codepoint in [text] together with the number of UTF-8
/// bytes consumed.
(int codepoint, int bytesRead) GetCodepointNext(String text) =>
    ffi.using((arena) {
      final sizePtr = arena<Int>();
      final cp = raylib.GetCodepointNext(
        text.toNativeUtf8(allocator: arena).cast(),
        sizePtr,
      );
      return (cp, sizePtr.value);
    });

/// Returns the previous codepoint before the end of [text] together with the
/// number of UTF-8 bytes consumed (moving backwards).
(int codepoint, int bytesRead) GetCodepointPrevious(String text) =>
    ffi.using((arena) {
      final sizePtr = arena<Int>();
      final cp = raylib.GetCodepointPrevious(
        text.toNativeUtf8(allocator: arena).cast(),
        sizePtr,
      );
      return (cp, sizePtr.value);
    });

// ── Text strings management ─────────────────────────────────────────────

@Deprecated('Use == instead')
bool TextIsEqual(String text1, String text2) => text1 == text2;

@Deprecated('Use .length instead')
int TextLength(String text) => text.length;

@Deprecated('Use string interpolation instead')
String? TextFormat(String format, List<Object> args) => sprintf(format, args);

@Deprecated('Use .substring() instead')
String TextSubtext(String text, int position, int length) =>
    text.substring(position, position + length);

@Deprecated('Use .replaceAll() instead')
String TextReplace(String text, String replace, String by) =>
    text.replaceAll(replace, by);

@Deprecated('Use string concatenation or interpolation instead')
String TextInsert(String text, String insert, int position) =>
    text.substring(0, position) + insert + text.substring(position);

@Deprecated('Use List.join() instead')
String TextJoin(List<String> textList, String delimiter) =>
    textList.join(delimiter);

@Deprecated('Use .split() instead')
List<String> TextSplit(String text, String delimiter) => text.split(delimiter);

@Deprecated('Use += instead')
String TextAppend(String text, String append) => text + append;

@Deprecated('Use .indexOf() instead')
int TextFindIndex(String text, String find) => text.indexOf(find);

@Deprecated('Use .toUpperCase() instead')
String TextToUpper(String text) => text.toUpperCase();

@Deprecated('Use .toLowerCase() instead')
String TextToLower(String text) => text.toLowerCase();

/// Converts [text] from snake_case to PascalCase.
/// Each word separated by `_` is capitalized; underscores are removed.
String TextToPascal(String text) {
  if (text.isEmpty) return text;
  final buf = StringBuffer(text[0].toUpperCase());
  for (var i = 1; i < text.length; i++) {
    if (text[i] == '_') {
      i++;
      if (i < text.length) {
        buf.write(text[i].toUpperCase());
      }
    } else {
      buf.write(text[i]);
    }
  }
  return buf.toString();
}

/// Converts [text] from PascalCase/camelCase to snake_case.
/// An underscore is inserted before each uppercase letter (except the first),
/// and the letter is lowercased.
String TextToSnake(String text) {
  if (text.isEmpty) return text;
  final buf = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final c = text[i];
    if (c.codeUnitAt(0) >= 0x41 && c.codeUnitAt(0) <= 0x5A) {
      if (i > 0) buf.write('_');
      buf.write(c.toLowerCase());
    } else {
      buf.write(c);
    }
  }
  return buf.toString();
}

/// Converts [text] from snake_case to camelCase.
/// Same as [TextToPascal] but the first character is lowercased.
String TextToCamel(String text) {
  if (text.isEmpty) return text;
  final buf = StringBuffer(text[0].toLowerCase());
  for (var i = 1; i < text.length; i++) {
    if (text[i] == '_') {
      i++;
      if (i < text.length) {
        buf.write(text[i].toUpperCase());
      }
    } else {
      buf.write(text[i]);
    }
  }
  return buf.toString();
}

@Deprecated('Use int.parse() instead')
int TextToInteger(String text) => int.parse(text);

@Deprecated('Use double.parse() instead')
double TextToFloat(String text) => double.parse(text);
