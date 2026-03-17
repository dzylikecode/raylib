// ignore_for_file: non_constant_identifier_names, constant_identifier_names, camel_case_types

import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';

export 'package:cdart/math.dart';

// export 'src/raylib.g.dart' show Clamp;
// export 'src/raylib.g.dart' show Lerp;
// export 'src/raylib.g.dart' show Normalize;
// export 'src/raylib.g.dart' show Remap;
// export 'src/raylib.g.dart' show Wrap;
// export 'src/raylib.g.dart' show FloatEquals;
// export 'src/raylib.g.dart' show Vector2Zero;
// export 'src/raylib.g.dart' show Vector2One;
// export 'src/raylib.g.dart' show Vector2Add;
// export 'src/raylib.g.dart' show Vector2AddValue;
// export 'src/raylib.g.dart' show Vector2Subtract;
// export 'src/raylib.g.dart' show Vector2SubtractValue;
// export 'src/raylib.g.dart' show Vector2Length;
// export 'src/raylib.g.dart' show Vector2LengthSqr;
// export 'src/raylib.g.dart' show Vector2DotProduct;
// export 'src/raylib.g.dart' show Vector2Distance;
// export 'src/raylib.g.dart' show Vector2DistanceSqr;
// export 'src/raylib.g.dart' show Vector2Angle;
// export 'src/raylib.g.dart' show Vector2Scale;
// export 'src/raylib.g.dart' show Vector2Multiply;
// export 'src/raylib.g.dart' show Vector2Negate;
// export 'src/raylib.g.dart' show Vector2Divide;
// export 'src/raylib.g.dart' show Vector2Normalize;
// export 'src/raylib.g.dart' show Vector2Transform;
// export 'src/raylib.g.dart' show Vector2Lerp;
// export 'src/raylib.g.dart' show Vector2Reflect;
// export 'src/raylib.g.dart' show Vector2Rotate;
// export 'src/raylib.g.dart' show Vector2MoveTowards;
// export 'src/raylib.g.dart' show Vector2Invert;
// export 'src/raylib.g.dart' show Vector2Clamp;
// export 'src/raylib.g.dart' show Vector2ClampValue;
// export 'src/raylib.g.dart' show Vector2Equals;
// export 'src/raylib.g.dart' show Vector3Zero;
// export 'src/raylib.g.dart' show Vector3One;
// export 'src/raylib.g.dart' show Vector3Add;
// export 'src/raylib.g.dart' show Vector3AddValue;
// export 'src/raylib.g.dart' show Vector3Subtract;
// export 'src/raylib.g.dart' show Vector3SubtractValue;
// export 'src/raylib.g.dart' show Vector3Scale;
// export 'src/raylib.g.dart' show Vector3Multiply;
// export 'src/raylib.g.dart' show Vector3CrossProduct;
// export 'src/raylib.g.dart' show Vector3Perpendicular;
// export 'src/raylib.g.dart' show Vector3Length;
// export 'src/raylib.g.dart' show Vector3LengthSqr;
// export 'src/raylib.g.dart' show Vector3DotProduct;
// export 'src/raylib.g.dart' show Vector3Distance;
// export 'src/raylib.g.dart' show Vector3DistanceSqr;
// export 'src/raylib.g.dart' show Vector3Angle;
// export 'src/raylib.g.dart' show Vector3Negate;
// export 'src/raylib.g.dart' show Vector3Divide;
// export 'src/raylib.g.dart' show Vector3Normalize;
// export 'src/raylib.g.dart' show Vector3OrthoNormalize;
// export 'src/raylib.g.dart' show Vector3Transform;
// export 'src/raylib.g.dart' show Vector3RotateByQuaternion;
// export 'src/raylib.g.dart' show Vector3RotateByAxisAngle;
// export 'src/raylib.g.dart' show Vector3Lerp;
// export 'src/raylib.g.dart' show Vector3Reflect;
// export 'src/raylib.g.dart' show Vector3Min;
// export 'src/raylib.g.dart' show Vector3Max;
// export 'src/raylib.g.dart' show Vector3Barycenter;
// export 'src/raylib.g.dart' show Vector3Unproject;
// export 'src/raylib.g.dart' show Vector3ToFloatV;
// export 'src/raylib.g.dart' show Vector3Invert;
// export 'src/raylib.g.dart' show Vector3Clamp;
// export 'src/raylib.g.dart' show Vector3ClampValue;
// export 'src/raylib.g.dart' show Vector3Equals;
// export 'src/raylib.g.dart' show Vector3Refract;
// export 'src/raylib.g.dart' show MatrixDeterminant;
// export 'src/raylib.g.dart' show MatrixTrace;
// export 'src/raylib.g.dart' show MatrixTranspose;
// export 'src/raylib.g.dart' show MatrixInvert;
// export 'src/raylib.g.dart' show MatrixIdentity;
// export 'src/raylib.g.dart' show MatrixAdd;
// export 'src/raylib.g.dart' show MatrixSubtract;
// export 'src/raylib.g.dart' show MatrixMultiply;
// export 'src/raylib.g.dart' show MatrixTranslate;
// export 'src/raylib.g.dart' show MatrixRotate;
// export 'src/raylib.g.dart' show MatrixRotateX;
// export 'src/raylib.g.dart' show MatrixRotateY;
// export 'src/raylib.g.dart' show MatrixRotateZ;
// export 'src/raylib.g.dart' show MatrixRotateXYZ;
// export 'src/raylib.g.dart' show MatrixRotateZYX;
// export 'src/raylib.g.dart' show MatrixScale;
// export 'src/raylib.g.dart' show MatrixFrustum;
// export 'src/raylib.g.dart' show MatrixPerspective;
// export 'src/raylib.g.dart' show MatrixOrtho;
// export 'src/raylib.g.dart' show MatrixLookAt;
// export 'src/raylib.g.dart' show MatrixToFloatV;
// export 'src/raylib.g.dart' show QuaternionAdd;
// export 'src/raylib.g.dart' show QuaternionAddValue;
// export 'src/raylib.g.dart' show QuaternionSubtract;
// export 'src/raylib.g.dart' show QuaternionSubtractValue;
// export 'src/raylib.g.dart' show QuaternionIdentity;
// export 'src/raylib.g.dart' show QuaternionLength;
// export 'src/raylib.g.dart' show QuaternionNormalize;
// export 'src/raylib.g.dart' show QuaternionInvert;
// export 'src/raylib.g.dart' show QuaternionMultiply;
// export 'src/raylib.g.dart' show QuaternionScale;
// export 'src/raylib.g.dart' show QuaternionDivide;
// export 'src/raylib.g.dart' show QuaternionLerp;
// export 'src/raylib.g.dart' show QuaternionNlerp;
// export 'src/raylib.g.dart' show QuaternionSlerp;
// export 'src/raylib.g.dart' show QuaternionFromVector3ToVector3;
// export 'src/raylib.g.dart' show QuaternionFromMatrix;
// export 'src/raylib.g.dart' show QuaternionToMatrix;
// export 'src/raylib.g.dart' show QuaternionFromAxisAngle;
// export 'src/raylib.g.dart' show QuaternionToAxisAngle;
// export 'src/raylib.g.dart' show QuaternionFromEuler;
// export 'src/raylib.g.dart' show QuaternionToEuler;
// export 'src/raylib.g.dart' show QuaternionTransform;
// export 'src/raylib.g.dart' show QuaternionEquals;

@Deprecated('Use value.clamp(min, max) instead')
double Clamp(double value, double min, double max) => value.clamp(min, max);

double Lerp(double start, double end, double amount) =>
    start + (end - start) * amount;

double Normalize(double value, double start, double end) =>
    (value - start) / (end - start);

double Remap(
  double value,
  double inputStart,
  double inputEnd,
  double outputStart,
  double outputEnd,
) =>
    (value - inputStart) / (inputEnd - inputStart) * (outputEnd - outputStart) +
    outputStart;

double Wrap(double value, double min, double max) =>
    value - (max - min) * ((value - min) / (max - min)).floorToDouble();

@Deprecated('Use (x - y).abs() < epsilon instead')
bool FloatEquals(double x, double y, [double epsilon = 1e-6]) =>
    (x - y).abs() <= epsilon * math.max(1.0, math.max(x.abs(), y.abs()));

// ── Vector2 ────────────────────────────────────────────────────────────

@Deprecated('Use .zero() instead')
Vector2 Vector2Zero() => .zero();

@Deprecated('Use .all(1.0) instead')
Vector2 Vector2One() => .all(1.0);

@Deprecated('Use v1 + v2 instead')
Vector2 Vector2Add(Vector2 v1, Vector2 v2) => v1 + v2;

@Deprecated('Use v + Vector2.all(add) instead')
Vector2 Vector2AddValue(Vector2 v, double add) => v + Vector2.all(add);

@Deprecated('Use v1 - v2 instead')
Vector2 Vector2Subtract(Vector2 v1, Vector2 v2) => v1 - v2;

@Deprecated('Use v - Vector2.all(sub) instead')
Vector2 Vector2SubtractValue(Vector2 v, double sub) => v - Vector2.all(sub);

@Deprecated('Use v.length instead')
double Vector2Length(Vector2 v) => v.length;

@Deprecated('Use v.length2 instead')
double Vector2LengthSqr(Vector2 v) => v.length2;

@Deprecated('Use v1.dot(v2) instead')
double Vector2DotProduct(Vector2 v1, Vector2 v2) => v1.dot(v2);

@Deprecated('Use (v1 - v2).length instead')
double Vector2Distance(Vector2 v1, Vector2 v2) => (v1 - v2).length;

@Deprecated('Use (v1 - v2).length2 instead')
double Vector2DistanceSqr(Vector2 v1, Vector2 v2) => (v1 - v2).length2;

/// Signed angle from v1 to v2 in radians.
double Vector2Angle(Vector2 v1, Vector2 v2) =>
    math.atan2(v1.x * v2.y - v1.y * v2.x, v1.x * v2.x + v1.y * v2.y);

@Deprecated('Use v.scaled(scale) instead')
Vector2 Vector2Scale(Vector2 v, double scale) => v.scaled(scale);

/// Component-wise multiply.
Vector2 Vector2Multiply(Vector2 v1, Vector2 v2) =>
    Vector2(v1.x * v2.x, v1.y * v2.y);

@Deprecated('Use -v instead')
Vector2 Vector2Negate(Vector2 v) => -v;

/// Component-wise divide.
Vector2 Vector2Divide(Vector2 v1, Vector2 v2) =>
    Vector2(v1.x / v2.x, v1.y / v2.y);

@Deprecated('Use v.normalized() instead')
Vector2 Vector2Normalize(Vector2 v) => v.normalized();

/// Transform v as a 2D point (x, y, 0, 1) by mat.
Vector2 Vector2Transform(Vector2 v, Matrix4 mat) => Vector2(
  mat[0] * v.x + mat[4] * v.y + mat[12],
  mat[1] * v.x + mat[5] * v.y + mat[13],
);

Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, double amount) =>
    v1 + (v2 - v1).scaled(amount);

Vector2 Vector2Reflect(Vector2 v, Vector2 normal) =>
    v - normal.scaled(2.0 * v.dot(normal));

Vector2 Vector2Rotate(Vector2 v, double angle) {
  final c = math.cos(angle), s = math.sin(angle);
  return Vector2(v.x * c - v.y * s, v.x * s + v.y * c);
}

Vector2 Vector2MoveTowards(Vector2 v, Vector2 target, double maxDistance) {
  final diff = target - v;
  final dist = diff.length;
  if (dist <= maxDistance || dist == 0) return target.clone();
  return v + diff.scaled(maxDistance / dist);
}

Vector2 Vector2Invert(Vector2 v) => Vector2(1.0 / v.x, 1.0 / v.y);

Vector2 Vector2Clamp(Vector2 v, Vector2 min, Vector2 max) =>
    Vector2(v.x.clamp(min.x, max.x), v.y.clamp(min.y, max.y));

Vector2 Vector2ClampValue(Vector2 v, double min, double max) {
  final len = v.length;
  if (len == 0) return v.clone();
  return v.scaled(len.clamp(min, max) / len);
}

@Deprecated('Use (p - q).length2 < epsilon instead')
bool Vector2Equals(Vector2 p, Vector2 q, [double epsilon = 1e-10]) =>
    (p - q).length2 < epsilon;

// ── Vector3 ────────────────────────────────────────────────────────────

@Deprecated('Use .zero() instead')
Vector3 Vector3Zero() => .zero();

@Deprecated('Use .all(1.0) instead')
Vector3 Vector3One() => .all(1.0);

@Deprecated('Use v1 + v2 instead')
Vector3 Vector3Add(Vector3 v1, Vector3 v2) => v1 + v2;

@Deprecated('Use v + Vector3.all(add) instead')
Vector3 Vector3AddValue(Vector3 v, double add) => v + Vector3.all(add);

@Deprecated('Use v1 - v2 instead')
Vector3 Vector3Subtract(Vector3 v1, Vector3 v2) => v1 - v2;

@Deprecated('Use v - Vector3.all(sub) instead')
Vector3 Vector3SubtractValue(Vector3 v, double sub) => v - Vector3.all(sub);

@Deprecated('Use v.scaled(scalar) instead')
Vector3 Vector3Scale(Vector3 v, double scalar) => v.scaled(scalar);

/// Component-wise multiply.
Vector3 Vector3Multiply(Vector3 v1, Vector3 v2) =>
    Vector3(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);

@Deprecated('Use v1.cross(v2) instead')
Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2) => v1.cross(v2);

/// Returns a vector perpendicular to v.
Vector3 Vector3Perpendicular(Vector3 v) {
  final c = v.x.abs() < 0.9 ? Vector3(1, 0, 0) : Vector3(0, 1, 0);
  return v.cross(c).normalized();
}

@Deprecated('Use v.length instead')
double Vector3Length(Vector3 v) => v.length;

@Deprecated('Use v.length2 instead')
double Vector3LengthSqr(Vector3 v) => v.length2;

@Deprecated('Use v1.dot(v2) instead')
double Vector3DotProduct(Vector3 v1, Vector3 v2) => v1.dot(v2);

@Deprecated('Use (v1 - v2).length instead')
double Vector3Distance(Vector3 v1, Vector3 v2) => (v1 - v2).length;

@Deprecated('Use (v1 - v2).length2 instead')
double Vector3DistanceSqr(Vector3 v1, Vector3 v2) => (v1 - v2).length2;

double Vector3Angle(Vector3 v1, Vector3 v2) =>
    math.atan2(v1.cross(v2).length, v1.dot(v2));

@Deprecated('Use -v instead')
Vector3 Vector3Negate(Vector3 v) => -v;

/// Component-wise divide.
Vector3 Vector3Divide(Vector3 v1, Vector3 v2) =>
    Vector3(v1.x / v2.x, v1.y / v2.y, v1.z / v2.z);

@Deprecated('Use v.normalized() instead')
Vector3 Vector3Normalize(Vector3 v) => v.normalized();

/// Gram-Schmidt orthonormalization. Returns the normalized pair (v1, v2).
/// In C this modified v1/v2 in-place via pointers.
(Vector3, Vector3) Vector3OrthoNormalize(Vector3 v1, Vector3 v2) {
  final n1 = v1.normalized();
  final n2 = (v2 - n1.scaled(n1.dot(v2))).normalized();
  return (n1, n2);
}

/// Transform v as a 3D point (x, y, z, 1) by mat.
Vector3 Vector3Transform(Vector3 v, Matrix4 mat) => Vector3(
  mat[0] * v.x + mat[4] * v.y + mat[8] * v.z + mat[12],
  mat[1] * v.x + mat[5] * v.y + mat[9] * v.z + mat[13],
  mat[2] * v.x + mat[6] * v.y + mat[10] * v.z + mat[14],
);

/// Rotate v by quaternion q using the sandwich product v' = q·v·q⁻¹.
Vector3 Vector3RotateByQuaternion(Vector3 v, Quaternion q) {
  final qv = Vector3(q.x, q.y, q.z);
  return v.scaled(q.w * q.w - qv.dot(qv)) +
      qv.scaled(2.0 * qv.dot(v)) +
      qv.cross(v).scaled(2.0 * q.w);
}

/// Rotate v around axis by angle (radians) — Rodrigues' formula.
Vector3 Vector3RotateByAxisAngle(Vector3 v, Vector3 axis, double angle) {
  final a = axis.normalized();
  final c = math.cos(angle), s = math.sin(angle);
  return v.scaled(c) + a.cross(v).scaled(s) + a.scaled(a.dot(v) * (1 - c));
}

Vector3 Vector3Lerp(Vector3 v1, Vector3 v2, double amount) =>
    v1 + (v2 - v1).scaled(amount);

Vector3 Vector3Reflect(Vector3 v, Vector3 normal) =>
    v - normal.scaled(2.0 * v.dot(normal));

Vector3 Vector3Min(Vector3 v1, Vector3 v2) =>
    Vector3(math.min(v1.x, v2.x), math.min(v1.y, v2.y), math.min(v1.z, v2.z));

Vector3 Vector3Max(Vector3 v1, Vector3 v2) =>
    Vector3(math.max(v1.x, v2.x), math.max(v1.y, v2.y), math.max(v1.z, v2.z));

/// Barycentric coordinates (u, v, w) of p relative to triangle (a, b, c).
Vector3 Vector3Barycenter(Vector3 p, Vector3 a, Vector3 b, Vector3 c) {
  final v0 = b - a, v1 = c - a, v2 = p - a;
  final d00 = v0.dot(v0), d01 = v0.dot(v1), d11 = v1.dot(v1);
  final d20 = v2.dot(v0), d21 = v2.dot(v1);
  final denom = d00 * d11 - d01 * d01;
  final bv = (d11 * d20 - d01 * d21) / denom;
  final bw = (d00 * d21 - d01 * d20) / denom;
  return Vector3(1 - bv - bw, bv, bw);
}

/// Unproject a screen-space point back into object space.
Vector3 Vector3Unproject(Vector3 source, Matrix4 projection, Matrix4 view) {
  final inv = (projection * view)..invert();
  final q = inv.transform(Vector4(source.x, source.y, source.z, 1.0));
  if (q.w != 0) return Vector3(q.x / q.w, q.y / q.w, q.z / q.w);
  return Vector3(q.x, q.y, q.z);
}

Vector3 Vector3Invert(Vector3 v) => Vector3(1.0 / v.x, 1.0 / v.y, 1.0 / v.z);

Vector3 Vector3Clamp(Vector3 v, Vector3 min, Vector3 max) => Vector3(
  v.x.clamp(min.x, max.x),
  v.y.clamp(min.y, max.y),
  v.z.clamp(min.z, max.z),
);

Vector3 Vector3ClampValue(Vector3 v, double min, double max) {
  final len = v.length;
  if (len == 0) return v.clone();
  return v.scaled(len.clamp(min, max) / len);
}

@Deprecated('Use (p - q).length2 < epsilon instead')
bool Vector3Equals(Vector3 p, Vector3 q) => (p - q).length2 < 1e-10;

/// Refraction direction for incident ray v, surface normal n, index ratio r.
Vector3 Vector3Refract(Vector3 v, Vector3 n, double r) {
  final dot = v.dot(n);
  final d = 1.0 - r * r * (1.0 - dot * dot);
  if (d < 0) return .zero();
  return v.scaled(r) - n.scaled(r * dot + math.sqrt(d));
}

// ── Matrix ─────────────────────────────────────────────────────────────

@Deprecated('Use mat.determinant() instead')
double MatrixDeterminant(Matrix4 mat) => mat.determinant();

double MatrixTrace(Matrix4 mat) => mat[0] + mat[5] + mat[10] + mat[15];

@Deprecated('Use mat.transposed() instead')
Matrix4 MatrixTranspose(Matrix4 mat) => mat.transposed();

@Deprecated('Use mat.clone()..invert() instead')
Matrix4 MatrixInvert(Matrix4 mat) => mat.clone()..invert();

@Deprecated('Use Matrix4.identity() instead')
Matrix4 MatrixIdentity() => .identity();

Matrix4 MatrixAdd(Matrix4 left, Matrix4 right) {
  final r = Matrix4.zero();
  for (var i = 0; i < 16; i++) {
    r[i] = left[i] + right[i];
  }
  return r;
}

Matrix4 MatrixSubtract(Matrix4 left, Matrix4 right) {
  final r = Matrix4.zero();
  for (var i = 0; i < 16; i++) {
    r[i] = left[i] - right[i];
  }
  return r;
}

@Deprecated('Use left * right instead')
Matrix4 MatrixMultiply(Matrix4 left, Matrix4 right) => left * right;

@Deprecated('Use Matrix4.translation(Vector3(x,y,z)) instead')
Matrix4 MatrixTranslate(double x, double y, double z) =>
    Matrix4.translation(Vector3(x, y, z));

/// Rotation matrix from axis and angle (radians) — Rodrigues' formula.
Matrix4 MatrixRotate(Vector3 axis, double angle) {
  final a = axis.normalized();
  final c = math.cos(angle), s = math.sin(angle), t = 1 - c;
  // Matrix4 constructor is column-major: [col0 top-to-bottom, col1, col2, col3]
  return Matrix4(
    t * a.x * a.x + c,
    t * a.x * a.y + s * a.z,
    t * a.x * a.z - s * a.y,
    0,
    t * a.x * a.y - s * a.z,
    t * a.y * a.y + c,
    t * a.y * a.z + s * a.x,
    0,
    t * a.x * a.z + s * a.y,
    t * a.y * a.z - s * a.x,
    t * a.z * a.z + c,
    0,
    0,
    0,
    0,
    1,
  );
}

@Deprecated('Use Matrix4.rotationX(angle) instead')
Matrix4 MatrixRotateX(double angle) => .rotationX(angle);

@Deprecated('Use Matrix4.rotationY(angle) instead')
Matrix4 MatrixRotateY(double angle) => .rotationY(angle);

@Deprecated('Use Matrix4.rotationZ(angle) instead')
Matrix4 MatrixRotateZ(double angle) => .rotationZ(angle);

Matrix4 MatrixRotateXYZ(Vector3 angle) =>
    Matrix4.rotationX(angle.x) *
    Matrix4.rotationY(angle.y) *
    Matrix4.rotationZ(angle.z);

Matrix4 MatrixRotateZYX(Vector3 angle) =>
    Matrix4.rotationZ(angle.z) *
    Matrix4.rotationY(angle.y) *
    Matrix4.rotationX(angle.x);

@Deprecated('Use Matrix4.diagonal3Values(x, y, z) instead')
Matrix4 MatrixScale(double x, double y, double z) => .diagonal3Values(x, y, z);

Matrix4 MatrixFrustum(
  double left,
  double right,
  double bottom,
  double top,
  double near,
  double far,
) {
  final mat = Matrix4.zero();
  mat[0] = 2 * near / (right - left);
  mat[5] = 2 * near / (top - bottom);
  mat[8] = (right + left) / (right - left);
  mat[9] = (top + bottom) / (top - bottom);
  mat[10] = -(far + near) / (far - near);
  mat[11] = -1;
  mat[14] = -2 * far * near / (far - near);
  return mat;
}

Matrix4 MatrixPerspective(double fovy, double aspect, double near, double far) {
  final top = near * math.tan(fovy / 2);
  return MatrixFrustum(-top * aspect, top * aspect, -top, top, near, far);
}

Matrix4 MatrixOrtho(
  double left,
  double right,
  double bottom,
  double top,
  double near,
  double far,
) {
  final mat = Matrix4.zero();
  mat[0] = 2 / (right - left);
  mat[5] = 2 / (top - bottom);
  mat[10] = -2 / (far - near);
  mat[12] = -(right + left) / (right - left);
  mat[13] = -(top + bottom) / (top - bottom);
  mat[14] = -(far + near) / (far - near);
  mat[15] = 1;
  return mat;
}

Matrix4 MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up) {
  final f = (target - eye).normalized();
  final r = f.cross(up).normalized();
  final u = r.cross(f);
  return Matrix4(
    r.x,
    u.x,
    -f.x,
    0,
    r.y,
    u.y,
    -f.y,
    0,
    r.z,
    u.z,
    -f.z,
    0,
    -r.dot(eye),
    -u.dot(eye),
    f.dot(eye),
    1,
  );
}

// ── Quaternion ─────────────────────────────────────────────────────────

@Deprecated('Use Quaternion.identity() instead')
Quaternion QuaternionIdentity() => .identity();

@Deprecated('Use q.length instead')
double QuaternionLength(Quaternion q) => q.length;

@Deprecated('Use q.normalized() instead')
Quaternion QuaternionNormalize(Quaternion q) => q.normalized();

/// True inverse: conjugate / length² (for non-unit quaternions).
Quaternion QuaternionInvert(Quaternion q) {
  final lenSq = q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w;
  if (lenSq == 0) return q;
  return Quaternion(-q.x / lenSq, -q.y / lenSq, -q.z / lenSq, q.w / lenSq);
}

@Deprecated('Use q1 * q2 instead')
Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2) => q1 * q2;

/// Component-wise scale (not Hamilton product).
Quaternion QuaternionScale(Quaternion q, double mul) =>
    Quaternion(q.x * mul, q.y * mul, q.z * mul, q.w * mul);

/// Component-wise addition.
Quaternion QuaternionAdd(Quaternion q1, Quaternion q2) =>
    Quaternion(q1.x + q2.x, q1.y + q2.y, q1.z + q2.z, q1.w + q2.w);

Quaternion QuaternionAddValue(Quaternion q, double add) =>
    Quaternion(q.x + add, q.y + add, q.z + add, q.w + add);

/// Component-wise subtraction.
Quaternion QuaternionSubtract(Quaternion q1, Quaternion q2) =>
    Quaternion(q1.x - q2.x, q1.y - q2.y, q1.z - q2.z, q1.w - q2.w);

Quaternion QuaternionSubtractValue(Quaternion q, double sub) =>
    Quaternion(q.x - sub, q.y - sub, q.z - sub, q.w - sub);

/// Component-wise divide (raylib convention).
Quaternion QuaternionDivide(Quaternion q1, Quaternion q2) =>
    Quaternion(q1.x / q2.x, q1.y / q2.y, q1.z / q2.z, q1.w / q2.w);

/// Linear interpolation (not normalized).
Quaternion QuaternionLerp(Quaternion q1, Quaternion q2, double amount) =>
    Quaternion(
      q1.x + (q2.x - q1.x) * amount,
      q1.y + (q2.y - q1.y) * amount,
      q1.z + (q2.z - q1.z) * amount,
      q1.w + (q2.w - q1.w) * amount,
    );

/// Normalized linear interpolation.
Quaternion QuaternionNlerp(Quaternion q1, Quaternion q2, double amount) =>
    QuaternionLerp(q1, q2, amount)..normalize();

Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, double amount) {
  var cosHalf = q1.x * q2.x + q1.y * q2.y + q1.z * q2.z + q1.w * q2.w;
  var q2x = q2.x, q2y = q2.y, q2z = q2.z, q2w = q2.w;
  if (cosHalf < 0) {
    q2x = -q2x;
    q2y = -q2y;
    q2z = -q2z;
    q2w = -q2w;
    cosHalf = -cosHalf;
  }
  if (cosHalf >= 1.0) return q1.clone();
  final half = math.acos(cosHalf);
  final sinHalf = math.sqrt(1.0 - cosHalf * cosHalf);
  if (sinHalf.abs() < 0.001) {
    return Quaternion(
      q1.x * 0.5 + q2x * 0.5,
      q1.y * 0.5 + q2y * 0.5,
      q1.z * 0.5 + q2z * 0.5,
      q1.w * 0.5 + q2w * 0.5,
    );
  }
  final ra = math.sin((1 - amount) * half) / sinHalf;
  final rb = math.sin(amount * half) / sinHalf;
  return Quaternion(
    q1.x * ra + q2x * rb,
    q1.y * ra + q2y * rb,
    q1.z * ra + q2z * rb,
    q1.w * ra + q2w * rb,
  );
}

/// Rotation quaternion from one vector direction to another.
Quaternion QuaternionFromVector3ToVector3(Vector3 from, Vector3 to) {
  final f = from.normalized(), t = to.normalized();
  final dot = f.dot(t);
  if ((dot + 1.0).abs() < 1e-6) {
    final perp = Vector3Perpendicular(f);
    return Quaternion(perp.x, perp.y, perp.z, 0.0)..normalize();
  }
  final cross = f.cross(t);
  return Quaternion(cross.x, cross.y, cross.z, 1.0 + dot)..normalize();
}

/// Quaternion from rotation matrix (upper-left 3×3 of mat).
Quaternion QuaternionFromMatrix(Matrix4 mat) {
  final trace = mat[0] + mat[5] + mat[10];
  if (trace > 0) {
    final s = 0.5 / math.sqrt(trace + 1.0);
    return Quaternion(
      (mat[6] - mat[9]) * s,
      (mat[8] - mat[2]) * s,
      (mat[1] - mat[4]) * s,
      0.25 / s,
    );
  } else if (mat[0] > mat[5] && mat[0] > mat[10]) {
    final s = 2.0 * math.sqrt(1.0 + mat[0] - mat[5] - mat[10]);
    return Quaternion(
      0.25 * s,
      (mat[4] + mat[1]) / s,
      (mat[8] + mat[2]) / s,
      (mat[6] - mat[9]) / s,
    );
  } else if (mat[5] > mat[10]) {
    final s = 2.0 * math.sqrt(1.0 + mat[5] - mat[0] - mat[10]);
    return Quaternion(
      (mat[4] + mat[1]) / s,
      0.25 * s,
      (mat[9] + mat[6]) / s,
      (mat[8] - mat[2]) / s,
    );
  } else {
    final s = 2.0 * math.sqrt(1.0 + mat[10] - mat[0] - mat[5]);
    return Quaternion(
      (mat[8] + mat[2]) / s,
      (mat[9] + mat[6]) / s,
      0.25 * s,
      (mat[1] - mat[4]) / s,
    );
  }
}

/// Rotation matrix from quaternion (column-major Matrix4).
Matrix4 QuaternionToMatrix(Quaternion q) => Matrix4(
  1 - 2 * (q.y * q.y + q.z * q.z),
  2 * (q.x * q.y + q.w * q.z),
  2 * (q.x * q.z - q.w * q.y),
  0,
  2 * (q.x * q.y - q.w * q.z),
  1 - 2 * (q.x * q.x + q.z * q.z),
  2 * (q.y * q.z + q.w * q.x),
  0,
  2 * (q.x * q.z + q.w * q.y),
  2 * (q.y * q.z - q.w * q.x),
  1 - 2 * (q.x * q.x + q.y * q.y),
  0,
  0,
  0,
  0,
  1,
);

@Deprecated('Use Quaternion.axisAngle(axis, angle) instead')
Quaternion QuaternionFromAxisAngle(Vector3 axis, double angle) =>
    .axisAngle(axis, angle);

/// Returns (axis, angle) — replaces the C out-pointer API.
(Vector3, double) QuaternionToAxisAngle(Quaternion q) {
  final qq = q.w > 1 ? q.normalized() : q;
  final angle = 2 * math.acos(qq.w);
  final s = math.sqrt(1 - qq.w * qq.w);
  if (s < 1e-4) return (Vector3(qq.x, qq.y, qq.z), angle);
  return (Vector3(qq.x / s, qq.y / s, qq.z / s), angle);
}

/// From Euler angles pitch (X), yaw (Y), roll (Z) in radians — ZYX order.
Quaternion QuaternionFromEuler(double pitch, double yaw, double roll) {
  final x0 = math.cos(pitch * 0.5), x1 = math.sin(pitch * 0.5);
  final y0 = math.cos(yaw * 0.5), y1 = math.sin(yaw * 0.5);
  final z0 = math.cos(roll * 0.5), z1 = math.sin(roll * 0.5);
  return Quaternion(
    x1 * y0 * z0 - x0 * y1 * z1,
    x0 * y1 * z0 + x1 * y0 * z1,
    x0 * y0 * z1 - x1 * y1 * z0,
    x0 * y0 * z0 + x1 * y1 * z1,
  );
}

/// Returns Euler angles (roll, pitch, yaw) as Vector3 (radians).
Vector3 QuaternionToEuler(Quaternion q) {
  final x0 = 2 * (q.w * q.x + q.y * q.z);
  final x1 = 1 - 2 * (q.x * q.x + q.y * q.y);
  final sinP = (2 * (q.w * q.y - q.z * q.x)).clamp(-1.0, 1.0);
  final z0 = 2 * (q.w * q.z + q.x * q.y);
  final z1 = 1 - 2 * (q.y * q.y + q.z * q.z);
  return Vector3(math.atan2(x0, x1), math.asin(sinP), math.atan2(z0, z1));
}

Quaternion QuaternionTransform(Quaternion q, Matrix4 mat) => Quaternion(
  mat[0] * q.x + mat[4] * q.y + mat[8] * q.z + mat[12] * q.w,
  mat[1] * q.x + mat[5] * q.y + mat[9] * q.z + mat[13] * q.w,
  mat[2] * q.x + mat[6] * q.y + mat[10] * q.z + mat[14] * q.w,
  mat[3] * q.x + mat[7] * q.y + mat[11] * q.z + mat[15] * q.w,
);

bool QuaternionEquals(Quaternion p, Quaternion q, [double epsilon = 1e-6]) =>
    (p.x - q.x).abs() +
        (p.y - q.y).abs() +
        (p.z - q.z).abs() +
        (p.w - q.w).abs() <
    epsilon;
