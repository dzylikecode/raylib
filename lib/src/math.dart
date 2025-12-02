// ignore_for_file: non_constant_identifier_names, constant_identifier_names, camel_case_types

import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';

/// Utils math

@Deprecated('Use value.clamp(min, max) instead')
double Clamp(double value, double min, double max) => value.clamp(min, max);

double Lerp(double start, double end, double amount) =>
    start + (end - start) * amount;

/// Vector2 math

@Deprecated('Use .zero() instead')
Vector2 Vector2Zero() => .zero();

@Deprecated('Use .all(1.0) instead')
Vector2 Vector2One() => .all(1.0);

@Deprecated('Use v1 + v2 instead')
Vector2 Vector2Add(Vector2 v1, Vector2 v2) => v1 + v2;

@Deprecated('Use v1 - v2 instead')
Vector2 Vector2Subtract(Vector2 v1, Vector2 v2) => v1 - v2;

@Deprecated('Use Matrix4 instead')
typedef Matrix = Matrix4;

//

extension VmRayExt on Ray {
  @Deprecated('Use .origin instead')
  Vector3 get position => origin;
}
