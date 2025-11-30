// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';

import 'raylib.g.dart' as raylib;

final Finalizer<Pointer<raylib.Color>> _finalizer =
    Finalizer<Pointer<raylib.Color>>((ptr) {
      ffi.malloc.free(ptr);
    });

class Color {
  final Pointer<raylib.Color> ptr;
  bool _disposed = false;

  Color._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Color({int r = 0, int g = 0, int b = 0, int a = 255}) {
    final ptr = ffi.malloc<raylib.Color>();
    ptr.ref
      ..r = r
      ..g = g
      ..b = b
      ..a = a;
    return Color._(ptr);
  }
  factory Color.fromRGBA(int r, int g, int b, int a) =>
      Color(r: r, g: g, b: b, a: a);

  int get r => ptr.ref.r;
  set r(int value) => ptr.ref.r = value;

  int get g => ptr.ref.g;
  set g(int value) => ptr.ref.g = value;

  int get b => ptr.ref.b;
  set b(int value) => ptr.ref.b = value;

  int get a => ptr.ref.a;
  set a(int value) => ptr.ref.a = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this); // 取消自动释放
    ffi.malloc.free(ptr); // 立刻释放
    _disposed = true;
  }

  static final LIGHTGRAY = Color(r: 200, g: 200, b: 200, a: 255);
  static final GRAY = Color(r: 130, g: 130, b: 130, a: 255);
  static final DARKGRAY = Color(r: 80, g: 80, b: 80, a: 255);
  static final YELLOW = Color(r: 253, g: 249, b: 0, a: 255);
  static final GOLD = Color(r: 255, g: 203, b: 0, a: 255);
  static final ORANGE = Color(r: 255, g: 161, b: 0, a: 255);
  static final PINK = Color(r: 255, g: 109, b: 194, a: 255);
  static final RED = Color(r: 230, g: 41, b: 55, a: 255);
  static final MAROON = Color(r: 190, g: 33, b: 55, a: 255);
  static final GREEN = Color(r: 0, g: 228, b: 48, a: 255);
  static final LIME = Color(r: 0, g: 158, b: 47, a: 255);
  static final DARKGREEN = Color(r: 0, g: 117, b: 44, a: 255);
  static final SKYBLUE = Color(r: 102, g: 191, b: 255, a: 255);
  static final BLUE = Color(r: 0, g: 121, b: 241, a: 255);
  static final DARKBLUE = Color(r: 0, g: 82, b: 172, a: 255);
  static final PURPLE = Color(r: 200, g: 122, b: 255, a: 255);
  static final VIOLET = Color(r: 135, g: 60, b: 190, a: 255);
  static final DARKPURPLE = Color(r: 112, g: 31, b: 126, a: 255);
  static final BEIGE = Color(r: 211, g: 176, b: 131, a: 255);
  static final BROWN = Color(r: 127, g: 106, b: 79, a: 255);
  static final DARKBROWN = Color(r: 76, g: 63, b: 47, a: 255);
  static final WHITE = Color(r: 255, g: 255, b: 255, a: 255);
  static final BLACK = Color(r: 0, g: 0, b: 0, a: 255);
  static final BLANK = Color(r: 0, g: 0, b: 0, a: 0);
  static final MAGENTA = Color(r: 255, g: 0, b: 255, a: 255);
  static final RAYWHITE = Color(r: 245, g: 245, b: 245, a: 255);

  @override
  String toString() => 'r: $r, g: $g, b: $b, a: $a';
}

Color Fade(Color color, double alpha) {
  final c = raylib.Fade(color.ptr.ref, alpha);
  return Color.fromRGBA(c.r, c.g, c.b, c.a);
}
