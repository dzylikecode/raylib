// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';

import 'raylib.g.dart' as raylib;

final Finalizer<Pointer<raylib.Rectangle>> _finalizer =
    Finalizer<Pointer<raylib.Rectangle>>(ffi.malloc.free);

class Rectangle {
  final Pointer<raylib.Rectangle> ptr;
  bool _disposed = false;

  Rectangle._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Rectangle.zero() => Rectangle();

  factory Rectangle({
    double x = 0,
    double y = 0,
    double width = 0,
    double height = 0,
  }) => Rectangle._(ffi.malloc<raylib.Rectangle>())
    ..x = x
    ..y = y
    ..width = width
    ..height = height;

  factory Rectangle.fromLTWH(
    double left,
    double top,
    double width,
    double height,
  ) => Rectangle(x: left, y: top, width: width, height: height);

  double get x => ptr.ref.x;
  set x(double value) => ptr.ref.x = value;

  double get y => ptr.ref.y;
  set y(double value) => ptr.ref.y = value;

  double get width => ptr.ref.width;
  set width(double value) => ptr.ref.width = value;

  double get height => ptr.ref.height;
  set height(double value) => ptr.ref.height = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this); // 取消自动释放
    ffi.malloc.free(ptr); // 立刻释放
    _disposed = true;
  }

  @override
  String toString() => 'x: $x, y: $y, width: $width, height: $height';
}

extension RectangleExt on raylib.Rectangle {
  Rectangle toDart() => .new(x: x, y: y, width: width, height: height);
}
