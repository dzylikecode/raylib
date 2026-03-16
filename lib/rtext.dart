// ignore_for_file: non_constant_identifier_names
//
// Wrapping strategy for rtext:
//   - Functions taking only primitive C types (int, no pointers) → direct export
//   - Functions taking Pointer<Char> → Dart wrapper (String conversion via Arena)
//   - Functions returning codepoint + size-out param → record (int, int)
//   - C string utilities with Dart equivalents → commented out
//   - C memory-managed string/codepoint helpers → commented out

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';

// ── Font ───────────────────────────────────────────────────────────────
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
export 'src/raylib.g.dart' show SetTextLineSpacing;
export 'src/text.dart' show TextFormat;
// export 'src/raylib.g.dart' show DrawText;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextEx;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextPro;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextCodepoint;   // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextCodepoints;  // → Dart wrapper below

// ── Text measurement ────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show MeasureText;         // → Dart wrapper below
// export 'src/raylib.g.dart' show MeasureTextEx;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphIndex;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphInfo;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GetGlyphAtlasRec;    // → Dart wrapper below

// ── Codepoints ──────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadUTF8;            // C memory management — use Dart strings
// export 'src/raylib.g.dart' show UnloadUTF8;          // C memory management — use Dart strings
// export 'src/raylib.g.dart' show LoadCodepoints;      // C memory management — use Dart strings
// export 'src/raylib.g.dart' show UnloadCodepoints;    // C memory management — use Dart strings
// export 'src/raylib.g.dart' show GetCodepointCount;   // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepoint;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepointNext;    // → Dart wrapper below
// export 'src/raylib.g.dart' show GetCodepointPrevious; // → Dart wrapper below
// export 'src/raylib.g.dart' show CodepointToUTF8;     // C memory management — use Dart strings

// ── Text utilities ───────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show TextCopy;            // C string utilities — use Dart string methods instead
// export 'src/raylib.g.dart' show TextIsEqual;         // C string utilities — use == instead
// export 'src/raylib.g.dart' show TextLength;          // C string utilities — use .length instead
// export 'src/raylib.g.dart' show TextSubtext;         // C string utilities — use .substring()
// export 'src/raylib.g.dart' show TextReplace;         // C string utilities — use .replaceAll()
// export 'src/raylib.g.dart' show TextInsert;          // C string utilities — use string interpolation
// export 'src/raylib.g.dart' show TextJoin;            // C string utilities — use .join()
// export 'src/raylib.g.dart' show TextSplit;           // C string utilities — use .split()
// export 'src/raylib.g.dart' show TextAppend;          // C string utilities — use +=
// export 'src/raylib.g.dart' show TextFindIndex;       // C string utilities — use .indexOf()
// export 'src/raylib.g.dart' show TextToUpper;         // C string utilities — use .toUpperCase()
// export 'src/raylib.g.dart' show TextToLower;         // C string utilities — use .toLowerCase()
// export 'src/raylib.g.dart' show TextToPascal;        // no Dart equivalent
// export 'src/raylib.g.dart' show TextToSnake;         // no Dart equivalent
// export 'src/raylib.g.dart' show TextToCamel;         // no Dart equivalent
// export 'src/raylib.g.dart' show TextToInteger;       // → Dart wrapper below
// export 'src/raylib.g.dart' show TextToFloat;         // → Dart wrapper below

// ── Font loading ────────────────────────────────────────────────────────

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

// ── Text measurement ────────────────────────────────────────────────────

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

// ── Codepoints ──────────────────────────────────────────────────────────

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

// ── Text utilities ───────────────────────────────────────────────────────

int TextToInteger(String text) => ffi.using((arena) {
  return raylib.TextToInteger(text.toNativeUtf8(allocator: arena).cast());
});

double TextToFloat(String text) => ffi.using((arena) {
  return raylib.TextToFloat(text.toNativeUtf8(allocator: arena).cast());
});
