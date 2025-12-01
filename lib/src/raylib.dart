// ignore_for_file: non_constant_identifier_names

import 'raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'package:vector_math/vector_math.dart';

import 'color.dart';
import 'rectangle.dart';
import 'ffi_utils.dart';
import 'camera.dart';

/// Window-related functions
final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raylib.CloseWindow();
  ffi.malloc.free(_titleStack.removeLast());
}

bool IsWindowState(raylib.ConfigFlags flags) =>
    raylib.IsWindowState(flags.value);
void SetWindowState(raylib.ConfigFlags flags) =>
    raylib.SetWindowState(flags.value);
void ClearWindowState(raylib.ConfigFlags flags) =>
    raylib.SetWindowState(flags.value);

void SetWindowTitle(String title) {
  if (_titleStack.isNotEmpty) {
    ffi.malloc.free(_titleStack.removeLast());
  }
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.SetWindowTitle(_titleStack.last);
}

String GetMonitorName(int monitor) =>
    raylib.GetMonitorName(monitor).cast<ffi.Utf8>().toDartString();
void SetClipboardText(String text) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  try {
    raylib.SetClipboardText(textPtr);
  } finally {
    ffi.malloc.free(textPtr);
  }
}

String GetClipboardText() =>
    raylib.GetClipboardText().cast<ffi.Utf8>().toDartString();

/// Drawing-related functions
void ClearBackground(Color color) => raylib.ClearBackground(color.ptr.ref);

/// Shader management functions
raylib.Shader LoadShader(String vsFileName, String fsFileName) {
  final vsFileNamePtr = vsFileName.toNativeUtf8().cast<Char>();
  final fsFileNamePtr = fsFileName.toNativeUtf8().cast<Char>();
  try {
    return raylib.LoadShader(vsFileNamePtr, fsFileNamePtr);
  } finally {
    ffi.malloc.free(vsFileNamePtr);
    ffi.malloc.free(fsFileNamePtr);
  }
}

raylib.Shader LoadShaderFromMemory(String vsCode, String fsCode) {
  final vsPtr = vsCode.toNativeUtf8().cast<Char>();
  final fsPtr = fsCode.toNativeUtf8().cast<Char>();
  try {
    return raylib.LoadShaderFromMemory(vsPtr, fsPtr);
  } finally {
    ffi.malloc.free(vsPtr);
    ffi.malloc.free(fsPtr);
  }
}

/// Screen-space-related functions
Ray GetScreenToWorldRay(Vector2 position, Camera3D camera) => ffi.using(
  (arena) => raylib.GetScreenToWorldRay(
    arena.vector2(position).ref,
    camera.ptr.ref,
  ).toDart(),
);

Ray GetScreenToWorldRayEx(
  Vector2 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using(
  (arena) => raylib.GetScreenToWorldRayEx(
    arena.vector2(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart(),
);

Vector2 GetWorldToScreen(Vector3 position, Camera3D camera) => ffi.using(
  (arena) => raylib.GetWorldToScreen(
    arena.vector3(position).ref,
    camera.ptr.ref,
  ).toDart(),
);

Vector2 GetWorldToScreenEx(
  Vector3 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using(
  (arena) => raylib.GetWorldToScreenEx(
    arena.vector3(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart(),
);

Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera) => ffi.using(
  (arena) => raylib.GetWorldToScreen2D(
    arena.vector2(position).ref,
    camera.ptr.ref,
  ).toDart(),
);

Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera) => ffi.using(
  (arena) => raylib.GetScreenToWorld2D(
    arena.vector2(position).ref,
    camera.ptr.ref,
  ).toDart(),
);

Matrix4 GetCameraMatrix(Camera3D camera) =>
    raylib.GetCameraMatrix(camera.ptr.ref).toDart();

Matrix4 GetCameraMatrix2D(Camera2D camera) =>
    raylib.GetCameraMatrix2D(camera.ptr.ref).toDart();

/// Random values generation functions
List<int> RandomSequence(int count, int min, int max) {
  final seq = raylib.LoadRandomSequence(count, min, max);
  final res = List.generate(count, (i) => seq[i]);
  raylib.UnloadRandomSequence(seq);
  return res;
}

/// Misc. functions
void TakeScreenshot(String fileName) {
  final fileNamePtr = fileName.toNativeUtf8().cast<Char>();
  try {
    raylib.TakeScreenshot(fileNamePtr);
  } finally {
    ffi.malloc.free(fileNamePtr);
  }
}

void SetConfigFlags(raylib.ConfigFlags flags) =>
    raylib.SetConfigFlags(flags.value);

void OpenURL(String url) {
  final urlPtr = url.toNativeUtf8().cast<Char>();
  try {
    raylib.OpenURL(urlPtr);
  } finally {
    ffi.malloc.free(urlPtr);
  }
}

/// utils
void SetTraceLogLevel(raylib.rlTraceLogLevel logLevel) =>
    raylib.SetTraceLogLevel(logLevel.value);

/// Input-related functions: keyboard
bool IsKeyPressed(raylib.KeyboardKey key) => raylib.IsKeyPressed(key.value);
bool IsKeyPressedRepeat(raylib.KeyboardKey key) =>
    raylib.IsKeyPressedRepeat(key.value);
bool IsKeyDown(raylib.KeyboardKey key) => raylib.IsKeyDown(key.value);
bool IsKeyReleased(raylib.KeyboardKey key) => raylib.IsKeyReleased(key.value);
bool IsKeyUp(raylib.KeyboardKey key) => raylib.IsKeyUp(key.value);
raylib.KeyboardKey GetKeyPressed() => .fromValue(raylib.GetKeyPressed());
raylib.KeyboardKey GetCharPressed() => .fromValue(raylib.GetCharPressed());
void SetExitKey(raylib.KeyboardKey key) => raylib.SetExitKey(key.value);

/// Input-related functions: gamepads
String GetGamepadName(int gamepad) {
  final namePtr = raylib.GetGamepadName(gamepad);
  final name = namePtr.cast<ffi.Utf8>().toDartString();
  return name;
}

bool IsGamepadButtonPressed(int gamepad, raylib.GamepadButton button) =>
    raylib.IsGamepadButtonPressed(gamepad, button.value);
bool IsGamepadButtonDown(int gamepad, raylib.GamepadButton button) =>
    raylib.IsGamepadButtonDown(gamepad, button.value);
bool IsGamepadButtonReleased(int gamepad, raylib.GamepadButton button) =>
    raylib.IsGamepadButtonReleased(gamepad, button.value);
bool IsGamepadButtonUp(int gamepad, raylib.GamepadButton button) =>
    raylib.IsGamepadButtonUp(gamepad, button.value);
raylib.GamepadButton GetGamepadButtonPressed() =>
    .fromValue(raylib.GetGamepadButtonPressed());
double GetGamepadAxisMovement(int gamepad, raylib.GamepadAxis axis) =>
    raylib.GetGamepadAxisMovement(gamepad, axis.value);

/// Input-related functions: mouse
bool IsMouseButtonPressed(raylib.MouseButton button) =>
    raylib.IsMouseButtonPressed(button.value);
bool IsMouseButtonDown(raylib.MouseButton button) =>
    raylib.IsMouseButtonDown(button.value);
bool IsMouseButtonReleased(raylib.MouseButton button) =>
    raylib.IsMouseButtonReleased(button.value);
bool IsMouseButtonUp(raylib.MouseButton button) =>
    raylib.IsMouseButtonUp(button.value);

Vector2 GetMousePosition() => raylib.GetMousePosition().toDart();
Vector2 GetMouseDelta() => raylib.GetMouseDelta().toDart();
Vector2 GetMouseWheelMoveV() => raylib.GetMouseWheelMoveV().toDart();
void SetMouseCursor(raylib.MouseCursor cursor) =>
    raylib.SetMouseCursor(cursor.value);

/// Input-related functions: touch
Vector2 GetTouchPosition(int index) {
  final ret = raylib.GetTouchPosition(index);
  return Vector2(ret.x, ret.y);
}

/// Gestures and Touch Handling Functions
bool IsGestureDetected(raylib.Gesture gesture) =>
    raylib.IsGestureDetected(gesture.value);
raylib.Gesture GetGestureDetected() => .fromValue(raylib.GetGestureDetected());
Vector2 GetGestureDragVector() => raylib.GetGestureDragVector().toDart();
Vector2 GetGesturePinchVector() => raylib.GetGesturePinchVector().toDart();

/// Camera System Functions
void UpdateCamera(Camera3D camera, raylib.CameraMode mode) =>
    raylib.UpdateCamera(camera.ptr, mode.value);
void UpdateCameraPro(
  Camera3D camera,
  Vector3 movement,
  Vector3 rotation,
  double zoom,
) => ffi.using(
  (arena) => raylib.UpdateCameraPro(
    camera.ptr,
    arena.vector3(movement).ref,
    arena.vector3(rotation).ref,
    zoom,
  ),
);

/// Basic shapes drawing functions
void DrawPixel(int posX, int posY, Color color) =>
    raylib.DrawPixel(posX, posY, color.ptr.ref);
void DrawPixelV(Vector2 position, Color color) => ffi.using(
  (arena) => raylib.DrawPixelV(arena.vector2(position).ref, color.ptr.ref),
);
void DrawLine(
  int startPosX,
  int startPosY,
  int endPosX,
  int endPosY,
  Color color,
) => raylib.DrawLine(startPosX, startPosY, endPosX, endPosY, color.ptr.ref);
void DrawLineV(Vector2 startPos, Vector2 endPos, Color color) => ffi.using(
  (arena) => raylib.DrawLineV(
    arena.vector2(startPos).ref,
    arena.vector2(endPos).ref,
    color.ptr.ref,
  ),
);
void DrawLineEx(Vector2 startPos, Vector2 endPos, double thick, Color color) =>
    ffi.using(
      (arena) => raylib.DrawLineEx(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        thick,
        color.ptr.ref,
      ),
    );
void DrawLineStrip(List<Vector2> points, Color color) => ffi.using(
  (arena) => raylib.DrawLineStrip(
    arena.vector2s(points),
    points.length,
    color.ptr.ref,
  ),
);
void DrawLineBezier(
  Vector2 startPos,
  Vector2 endPos,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawLineBezier(
    arena.vector2(startPos).ref,
    arena.vector2(endPos).ref,
    thick,
    color.ptr.ref,
  ),
);
void DrawCircle(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircle(centerX, centerY, radius, color.ptr.ref);
void DrawCircleSector(
  Vector2 center,
  double radius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawCircleSector(
    arena.vector2(center).ref,
    radius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  ),
);
void DrawCircleSectorLines(
  Vector2 center,
  double radius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawCircleSectorLines(
    arena.vector2(center).ref,
    radius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  ),
);
void DrawCircleGradient(
  int centerX,
  int centerY,
  double radius,
  Color inner,
  Color outer,
) => raylib.DrawCircleGradient(
  centerX,
  centerY,
  radius,
  inner.ptr.ref,
  outer.ptr.ref,
);
void DrawCircleV(Vector2 center, double radius, Color color) => ffi.using(
  (arena) =>
      raylib.DrawCircleV(arena.vector2(center).ref, radius, color.ptr.ref),
);
void DrawCircleLines(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircleLines(centerX, centerY, radius, color.ptr.ref);
void DrawCircleLinesV(Vector2 center, double radius, Color color) => ffi.using(
  (arena) =>
      raylib.DrawCircleLinesV(arena.vector2(center).ref, radius, color.ptr.ref),
);
void DrawEllipse(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raylib.DrawEllipse(centerX, centerY, radiusH, radiusV, color.ptr.ref);
void DrawEllipseLines(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raylib.DrawEllipseLines(centerX, centerY, radiusH, radiusV, color.ptr.ref);
void DrawRing(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawRing(
    arena.vector2(center).ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  ),
);
void DrawRingLines(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawRingLines(
    arena.vector2(center).ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  ),
);
void DrawRectangle(int posX, int posY, int width, int height, Color color) =>
    raylib.DrawRectangle(posX, posY, width, height, color.ptr.ref);
void DrawRectangleV(Vector2 position, Vector2 size, Color color) => ffi.using(
  (arena) => raylib.DrawRectangleV(
    arena.vector2(position).ref,
    arena.vector2(size).ref,
    color.ptr.ref,
  ),
);
void DrawRectangleRec(Rectangle rec, Color color) =>
    raylib.DrawRectangleRec(rec.ptr.ref, color.ptr.ref);
void DrawRectanglePro(
  Rectangle rec,
  Vector2 origin,
  double rotation,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawRectanglePro(
    rec.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    color.ptr.ref,
  ),
);
void DrawRectangleGradientV(
  int posX,
  int posY,
  int width,
  int height,
  Color top,
  Color bottom,
) => raylib.DrawRectangleGradientV(
  posX,
  posY,
  width,
  height,
  top.ptr.ref,
  bottom.ptr.ref,
);
void DrawRectangleGradientH(
  int posX,
  int posY,
  int width,
  int height,
  Color left,
  Color right,
) => raylib.DrawRectangleGradientH(
  posX,
  posY,
  width,
  height,
  left.ptr.ref,
  right.ptr.ref,
);
void DrawRectangleGradientEx(
  Rectangle rec,
  Color topLeft,
  Color bottomLeft,
  Color topRight,
  Color bottomRight,
) => raylib.DrawRectangleGradientEx(
  rec.ptr.ref,
  topLeft.ptr.ref,
  bottomLeft.ptr.ref,
  topRight.ptr.ref,
  bottomRight.ptr.ref,
);
void DrawRectangleLines(
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raylib.DrawRectangleLines(posX, posY, width, height, color.ptr.ref);
void DrawRectangleLinesEx(Rectangle rec, double lineThick, Color color) =>
    raylib.DrawRectangleLinesEx(rec.ptr.ref, lineThick, color.ptr.ref);
void DrawRectangleRounded(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raylib.DrawRectangleRounded(
  rec.ptr.ref,
  roundness,
  segments,
  color.ptr.ref,
);
void DrawRectangleRoundedLines(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raylib.DrawRectangleRoundedLines(
  rec.ptr.ref,
  roundness,
  segments,
  color.ptr.ref,
);
void DrawRectangleRoundedLinesEx(
  Rectangle rec,
  double roundness,
  int segments,
  double lineThick,
  Color color,
) => raylib.DrawRectangleRoundedLinesEx(
  rec.ptr.ref,
  roundness,
  segments,
  lineThick,
  color.ptr.ref,
);
void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color) => ffi.using(
  (arena) => raylib.DrawTriangle(
    arena.vector2(v1).ref,
    arena.vector2(v2).ref,
    arena.vector2(v3).ref,
    color.ptr.ref,
  ),
);
void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    ffi.using(
      (arena) => raylib.DrawTriangleLines(
        arena.vector2(v1).ref,
        arena.vector2(v2).ref,
        arena.vector2(v3).ref,
        color.ptr.ref,
      ),
    );
void DrawTriangleFan(List<Vector2> points, Color color) => ffi.using(
  (arena) => raylib.DrawTriangleFan(
    arena.vector2s(points),
    points.length,
    color.ptr.ref,
  ),
);
void DrawTriangleStrip(List<Vector2> points, Color color) => ffi.using(
  (arena) => raylib.DrawTriangleStrip(
    arena.vector2s(points),
    points.length,
    color.ptr.ref,
  ),
);
void DrawPoly(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawPoly(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    color.ptr.ref,
  ),
);
void DrawPolyLines(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawPolyLines(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    color.ptr.ref,
  ),
);
void DrawPolyLinesEx(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  double lineThick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawPolyLinesEx(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    lineThick,
    color.ptr.ref,
  ),
);

/// Splines drawing functions
void DrawSplineLinear(List<Vector2> points, double thick, Color color) =>
    ffi.using(
      (arena) => raylib.DrawSplineLinear(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      ),
    );
void DrawSplineBasis(List<Vector2> points, double thick, Color color) =>
    ffi.using(
      (arena) => raylib.DrawSplineBasis(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      ),
    );
void DrawSplineCatmullRom(List<Vector2> points, double thick, Color color) =>
    ffi.using(
      (arena) => raylib.DrawSplineCatmullRom(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      ),
    );

void DrawSplineBezierQuadratic(
  List<Vector2> points,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineBezierQuadratic(
    arena.vector2s(points),
    points.length,
    thick,
    color.ptr.ref,
  ),
);

void DrawSplineBezierCubic(List<Vector2> points, double thick, Color color) =>
    ffi.using(
      (arena) => raylib.DrawSplineBezierCubic(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      ),
    );

void DrawSplineSegmentLinear(
  Vector2 p1,
  Vector2 p2,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineSegmentLinear(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    thick,
    color.ptr.ref,
  ),
);

void DrawSplineSegmentBasis(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineSegmentBasis(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  ),
);

void DrawSplineSegmentCatmullRom(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineSegmentCatmullRom(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  ),
);

void DrawSplineSegmentBezierQuadratic(
  Vector2 p1,
  Vector2 c2,
  Vector2 p3,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineSegmentBezierQuadratic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(p3).ref,
    thick,
    color.ptr.ref,
  ),
);

void DrawSplineSegmentBezierCubic(
  Vector2 p1,
  Vector2 c2,
  Vector2 c3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using(
  (arena) => raylib.DrawSplineSegmentBezierCubic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(c3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  ),
);

/// Spline segment point evaluation functions
Vector2 GetSplinePointLinear(Vector2 startPos, Vector2 endPos, double t) =>
    ffi.using(
      (arena) => raylib.GetSplinePointLinear(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        t,
      ).toDart(),
    );

Vector2 GetSplinePointBasis(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using(
  (arena) => raylib.GetSplinePointBasis(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart(),
);

Vector2 GetSplinePointCatmullRom(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using(
  (arena) => raylib.GetSplinePointCatmullRom(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart(),
);

Vector2 GetSplinePointBezierQuad(
  Vector2 p1,
  Vector2 c2,
  Vector2 p3,
  double t,
) => ffi.using(
  (arena) => raylib.GetSplinePointBezierQuad(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(p3).ref,
    t,
  ).toDart(),
);

Vector2 GetSplinePointBezierCubic(
  Vector2 p1,
  Vector2 c2,
  Vector2 c3,
  Vector2 p4,
  double t,
) => ffi.using(
  (arena) => raylib.GetSplinePointBezierCubic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(c3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart(),
);

/// Basic shapes collision detection functions
bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2) =>
    raylib.CheckCollisionRecs(rec1.ptr.ref, rec2.ptr.ref);

bool CheckCollisionCircles(
  Vector2 center1,
  double radius1,
  Vector2 center2,
  double radius2,
) => ffi.using(
  (arena) => raylib.CheckCollisionCircles(
    arena.vector2(center1).ref,
    radius1,
    arena.vector2(center2).ref,
    radius2,
  ),
);

bool CheckCollisionCircleRec(Vector2 center, double radius, Rectangle rec) =>
    ffi.using(
      (arena) => raylib.CheckCollisionCircleRec(
        arena.vector2(center).ref,
        radius,
        rec.ptr.ref,
      ),
    );

bool CheckCollisionPointRec(Vector2 point, Rectangle rec) => ffi.using(
  (arena) =>
      raylib.CheckCollisionPointRec(arena.vector2(point).ref, rec.ptr.ref),
);

bool CheckCollisionCircleLine(
  Vector2 center,
  double radius,
  Vector2 p1,
  Vector2 p2,
) => ffi.using(
  (arena) => raylib.CheckCollisionCircleLine(
    arena.vector2(center).ref,
    radius,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
  ),
);

bool CheckCollisionPointCircle(Vector2 point, Vector2 center, double radius) =>
    ffi.using(
      (arena) => raylib.CheckCollisionPointCircle(
        arena.vector2(point).ref,
        arena.vector2(center).ref,
        radius,
      ),
    );

bool CheckCollisionPointTriangle(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
) => ffi.using(
  (arena) => raylib.CheckCollisionPointTriangle(
    arena.vector2(point).ref,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
  ),
);

bool CheckCollisionPointLine(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  int threshold,
) => ffi.using(
  (arena) => raylib.CheckCollisionPointLine(
    arena.vector2(point).ref,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    threshold,
  ),
);

bool CheckCollisionPointPoly(Vector2 point, List<Vector2> points) => ffi.using(
  (arena) => raylib.CheckCollisionPointPoly(
    arena.vector2(point).ref,
    arena.vector2s(points),
    points.length,
  ),
);

bool CheckCollisionLines(
  Vector2 startPos1,
  Vector2 endPos1,
  Vector2 startPos2,
  Vector2 endPos2,
  List<Vector2> collisionPoint,
) => ffi.using(
  (arena) => raylib.CheckCollisionLines(
    arena.vector2(startPos1).ref,
    arena.vector2(endPos1).ref,
    arena.vector2(startPos2).ref,
    arena.vector2(endPos2).ref,
    arena.vector2s(collisionPoint),
  ),
);

Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2) =>
    raylib.GetCollisionRec(rec1.ptr.ref, rec2.ptr.ref).toDart();

/// Texture loading functions
raylib.Texture2D LoadTexture(String fileName) {
  final fileNamePtr = fileName.toNativeUtf8().cast<Char>();
  final texture = raylib.LoadTexture(fileNamePtr);
  ffi.malloc.free(fileNamePtr);
  return texture;
}

/// Texture drawing functions
void DrawTexture(raylib.Texture2D texture, int posX, int posY, Color tint) =>
    raylib.DrawTexture(texture, posX, posY, tint.ptr.ref);

/// Text strings management functions
String TextToLower(String text) => text.toLowerCase();
int TextFindIndex(String text, String find) => text.indexOf(find);

/// Text drawing functions
void DrawText(String text, int posX, int posY, int fontSize, Color color) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  raylib.DrawText(textPtr, posX, posY, fontSize, color.ptr.ref);
  ffi.malloc.free(textPtr);
}

void DrawTextEx(
  raylib.Font font,
  String text,
  Vector2 position,
  double fontSize,
  double spacing,
  Color tint,
) => ffi.using((arena) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  raylib.DrawTextEx(
    font,
    textPtr,
    arena.vector2(position).ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
  ffi.malloc.free(textPtr);
});
