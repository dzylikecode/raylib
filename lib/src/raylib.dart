// ignore_for_file: non_constant_identifier_names

import 'raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';

import 'color.dart';

final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raylib.CloseWindow();
  ffi.malloc.free(_titleStack.removeLast());
}

void ClearBackground(Color color) {
  raylib.ClearBackground(color.ptr.ref);
}

void DrawText(String text, int posX, int posY, int fontSize, Color color) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  raylib.DrawText(textPtr, posX, posY, fontSize, color.ptr.ref);
  ffi.malloc.free(textPtr);
}
