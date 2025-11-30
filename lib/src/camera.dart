// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';

import 'raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'ffi_utils.dart';

final Finalizer<Pointer<raylib.Camera2D>> _finalizer =
    Finalizer<Pointer<raylib.Camera2D>>((ptr) {
      ffi.malloc.free(ptr);
    });

class Camera2D {
  final Pointer<raylib.Camera2D> ptr;
  bool _disposed = false;

  Camera2D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera2D() {
    final pointer = ffi.malloc<raylib.Camera2D>();
    return Camera2D._(pointer);
  }

  Vector2 get offset => ptr.ref.offset.toDart();
  set offset(Vector2 value) {
    ptr.ref.offset.x = value.x;
    ptr.ref.offset.y = value.y;
  }

  Vector2 get target => ptr.ref.target.toDart();
  set target(Vector2 value) {
    ptr.ref.target.x = value.x;
    ptr.ref.target.y = value.y;
  }

  double get rotation => ptr.ref.rotation;
  set rotation(double value) => ptr.ref.rotation = value;

  double get zoom => ptr.ref.zoom;
  set zoom(double value) => ptr.ref.zoom = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this); // 取消自动释放
    ffi.malloc.free(ptr); // 立刻释放
    _disposed = true;
  }
}

void BeginMode2D(Camera2D camera) => raylib.BeginMode2D(camera.ptr.ref);
