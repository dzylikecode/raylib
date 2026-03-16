// ignore_for_file: non_constant_identifier_names
//
// Wrapping strategy for rtext:
//   - Functions taking only primitive C types (int, no pointers) → direct export
//   - Functions taking Pointer<Char> → Dart wrapper (String conversion via Arena)
//   - Functions returning codepoint + size-out param → record (int, int)
//   - Font-dependent functions → commented out (Font not yet wrapped)
//   - C string utilities with Dart equivalents → commented out
//   - C memory-managed string/codepoint helpers → commented out

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'colors.dart';

// ── Font ───────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show GetFontDefault;      // Font not yet wrapped
// export 'src/raylib.g.dart' show LoadFont;            // Font not yet wrapped
// export 'src/raylib.g.dart' show LoadFontEx;          // Font not yet wrapped
// export 'src/raylib.g.dart' show LoadFontFromImage;   // Font not yet wrapped
// export 'src/raylib.g.dart' show LoadFontFromMemory;  // Font not yet wrapped
// export 'src/raylib.g.dart' show IsFontValid;         // Font not yet wrapped
// export 'src/raylib.g.dart' show LoadFontData;        // Font not yet wrapped
// export 'src/raylib.g.dart' show GenImageFontAtlas;   // Font not yet wrapped
// export 'src/raylib.g.dart' show UnloadFontData;      // Font not yet wrapped
// export 'src/raylib.g.dart' show UnloadFont;          // Font not yet wrapped
// export 'src/raylib.g.dart' show ExportFontAsCode;    // Font not yet wrapped

// ── Text drawing ────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show DrawFPS;
export 'src/raylib.g.dart' show SetTextLineSpacing;
// export 'src/raylib.g.dart' show DrawText;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTextEx;          // Font not yet wrapped
// export 'src/raylib.g.dart' show DrawTextPro;         // Font not yet wrapped
// export 'src/raylib.g.dart' show DrawTextCodepoint;   // Font not yet wrapped
// export 'src/raylib.g.dart' show DrawTextCodepoints;  // Font not yet wrapped

// ── Text measurement ────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show MeasureText;         // → Dart wrapper below
// export 'src/raylib.g.dart' show MeasureTextEx;       // Font not yet wrapped
// export 'src/raylib.g.dart' show GetGlyphIndex;       // Font not yet wrapped
// export 'src/raylib.g.dart' show GetGlyphInfo;        // Font not yet wrapped
// export 'src/raylib.g.dart' show GetGlyphAtlasRec;    // Font not yet wrapped

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
// export 'src/raylib.g.dart' show TextIsEqual;         // C string utilities — use Dart string methods instead (==)
// export 'src/raylib.g.dart' show TextLength;          // C string utilities — use Dart string methods instead (.length)
export 'src/text.dart' show TextFormat;
// export 'src/raylib.g.dart' show TextSubtext;         // C string utilities — use Dart string methods instead (.substring())
// export 'src/raylib.g.dart' show TextReplace;         // C string utilities — use Dart string methods instead (.replaceAll())
// export 'src/raylib.g.dart' show TextInsert;          // C string utilities — use Dart string methods instead (string interpolation)
// export 'src/raylib.g.dart' show TextJoin;            // C string utilities — use Dart string methods instead (.join())
// export 'src/raylib.g.dart' show TextSplit;           // C string utilities — use Dart string methods instead (.split())
// export 'src/raylib.g.dart' show TextAppend;          // C string utilities — use Dart string methods instead (+=)
// export 'src/raylib.g.dart' show TextFindIndex;       // C string utilities — use Dart string methods instead (.indexOf())
// export 'src/raylib.g.dart' show TextToUpper;         // C string utilities — use Dart string methods instead (.toUpperCase())
// export 'src/raylib.g.dart' show TextToLower;         // C string utilities — use Dart string methods instead (.toLowerCase())
// export 'src/raylib.g.dart' show TextToPascal;        // no Dart equivalent
// export 'src/raylib.g.dart' show TextToSnake;         // no Dart equivalent
// export 'src/raylib.g.dart' show TextToCamel;         // no Dart equivalent
// export 'src/raylib.g.dart' show TextToInteger;       // → Dart wrapper below
// export 'src/raylib.g.dart' show TextToFloat;         // → Dart wrapper below

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

// ── Text measurement ────────────────────────────────────────────────────

int MeasureText(String text, int fontSize) => ffi.using((arena) {
  return raylib.MeasureText(
    text.toNativeUtf8(allocator: arena).cast(),
    fontSize,
  );
});

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
