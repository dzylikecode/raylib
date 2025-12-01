// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';

import 'raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'ffi_utils.dart';

final Finalizer<Pointer<raylib.Camera2D>> _finalizer2D =
    Finalizer<Pointer<raylib.Camera2D>>((ptr) {
      ffi.malloc.free(ptr);
    });

class Camera2D {
  final Pointer<raylib.Camera2D> ptr;
  bool _disposed = false;

  Camera2D._(this.ptr) {
    _finalizer2D.attach(this, ptr, detach: this);
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
    _finalizer2D.detach(this); // 取消自动释放
    ffi.malloc.free(ptr); // 立刻释放
    _disposed = true;
  }
}

void BeginMode2D(Camera2D camera) => raylib.BeginMode2D(camera.ptr.ref);

final Finalizer<Pointer<raylib.Camera3D>> _finalizer3D =
    Finalizer<Pointer<raylib.Camera3D>>((ptr) {
      ffi.malloc.free(ptr);
    });

class Camera3D {
  final Pointer<raylib.Camera3D> ptr;
  bool _disposed = false;

  Camera3D._(this.ptr) {
    _finalizer3D.attach(this, ptr, detach: this);
  }

  factory Camera3D() {
    final pointer = ffi.malloc<raylib.Camera3D>();
    return Camera3D._(pointer);
  }

  Vector3 get position => ptr.ref.position.toDart();
  set position(Vector3 value) {
    ptr.ref.position.x = value.x;
    ptr.ref.position.y = value.y;
    ptr.ref.position.z = value.z;
  }

  Vector3 get target => ptr.ref.target.toDart();
  set target(Vector3 value) {
    ptr.ref.target.x = value.x;
    ptr.ref.target.y = value.y;
    ptr.ref.target.z = value.z;
  }

  Vector3 get up => ptr.ref.up.toDart();
  set up(Vector3 value) {
    ptr.ref.up.x = value.x;
    ptr.ref.up.y = value.y;
    ptr.ref.up.z = value.z;
  }

  double get fovy => ptr.ref.fovy;
  set fovy(double value) => ptr.ref.fovy = value;

  int get projection => ptr.ref.projection;
  set projection(int value) => ptr.ref.projection = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer3D.detach(this); // 取消自动释放
    ffi.malloc.free(ptr); // 立刻释放
    _disposed = true;
  }
}

void BeginMode3D(Camera3D camera) => raylib.BeginMode3D(camera.ptr.ref);
