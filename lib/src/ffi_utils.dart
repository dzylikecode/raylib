import 'raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;

extension Vector2Extension on raylib.Vector2 {
  Vector2 toDart() => Vector2(x, y);
}

T useVector2<T>(Vector2 vector, T Function(Pointer<raylib.Vector2> ptr) fn) =>
    ffi.using((arena) {
      final ptr = arena<raylib.Vector2>();
      ptr.ref
        ..x = vector.x
        ..y = vector.y;
      return fn(ptr);
    });

T useVector2s<T>(
  List<Vector2> vectors,
  T Function(List<Pointer<raylib.Vector2>>) fn,
) => ffi.using((arena) {
  final ptrs = vectors.map((vector) {
    final ptr = arena<raylib.Vector2>();
    ptr.ref
      ..x = vector.x
      ..y = vector.y;
    return ptr;
  }).toList();
  return fn(ptrs);
});
