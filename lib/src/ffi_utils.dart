import 'raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;

extension Vector2Extension on raylib.Vector2 {
  Vector2 toDart() => .new(x, y);
}

extension Vector3Extension on raylib.Vector3 {
  Vector3 toDart() => .new(x, y, z);
}

extension RayExtension on raylib.Ray {
  Ray toDart() => .originDirection(position.toDart(), direction.toDart());
}

extension MatrixExtension on raylib.Matrix {
  Matrix4 toDart() => .new(
    m0,
    m1,
    m2,
    m3,
    m4,
    m5,
    m6,
    m7,
    m8,
    m9,
    m10,
    m11,
    m12,
    m13,
    m14,
    m15,
  );
}

extension ArenaExt on ffi.Arena {
  Pointer<raylib.Vector2> vector2(Vector2 value) {
    final ptr = this<raylib.Vector2>();
    ptr.ref
      ..x = value.x
      ..y = value.y;
    return ptr;
  }

  Pointer<raylib.Vector2> vector2s(List<Vector2> value) {
    final size = value.length;
    final ptrs = this<raylib.Vector2>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y;
    }
    return ptrs;
  }

  Pointer<raylib.Vector3> vector3(Vector3 value) {
    final ptr = this<raylib.Vector3>();
    ptr.ref
      ..x = value.x
      ..y = value.y
      ..z = value.z;
    return ptr;
  }

  Pointer<raylib.Vector3> vector3s(List<Vector3> value) {
    final size = value.length;
    final ptrs = this<raylib.Vector3>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y
        ..z = value[i].z;
    }
    return ptrs;
  }

  Pointer<raylib.Ray> ray(Ray value) {
    final ptr = this<raylib.Ray>();
    ptr.ref
      ..position.x = value.origin.x
      ..position.y = value.origin.y
      ..position.z = value.origin.z
      ..direction.x = value.direction.x
      ..direction.y = value.direction.y
      ..direction.z = value.direction.z;
    return ptr;
  }
}
