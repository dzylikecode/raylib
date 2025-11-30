// ignore_for_file: non_constant_identifier_names

import 'raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'package:vector_math/vector_math.dart';

import 'color.dart';
import 'rectangle.dart';
import 'ffi_utils.dart';
import 'camera.dart';

final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raylib.CloseWindow();
  ffi.malloc.free(_titleStack.removeLast());
}

void ClearBackground(Color color) => raylib.ClearBackground(color.ptr.ref);

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
) => useVector2(position, (positionPtr) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  raylib.DrawTextEx(
    font,
    textPtr,
    positionPtr.ref,
    fontSize,
    spacing,
    tint.ptr.ref,
  );
  ffi.malloc.free(textPtr);
});

void DrawCircleV(Vector2 center, double radius, Color color) =>
    useVector2(center, (centerPtr) {
      raylib.DrawCircleV(centerPtr.ref, radius, color.ptr.ref);
    });

void DrawRectangle(int posX, int posY, int width, int height, Color color) =>
    raylib.DrawRectangle(posX, posY, width, height, color.ptr.ref);
void DrawCircle(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircle(centerX, centerY, radius, color.ptr.ref);
void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    useVector2s([v1, v2, v3], (ptrs) {
      raylib.DrawTriangle(ptrs[0].ref, ptrs[1].ref, ptrs[2].ref, color.ptr.ref);
    });

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
void DrawRectangleRec(Rectangle rec, Color color) =>
    raylib.DrawRectangleRec(rec.ptr.ref, color.ptr.ref);
void DrawRectangleLines(
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raylib.DrawRectangleLines(posX, posY, width, height, color.ptr.ref);
void DrawRing(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => useVector2(center, (centerPtr) {
  raylib.DrawRing(
    centerPtr.ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawLineEx(Vector2 startPos, Vector2 endPos, double thick, Color color) =>
    useVector2s([startPos, endPos], (ptrs) {
      raylib.DrawLineEx(ptrs[0].ref, ptrs[1].ref, thick, color.ptr.ref);
    });
void DrawLine(
  int startPosX,
  int startPosY,
  int endPosX,
  int endPosY,
  Color color,
) => raylib.DrawLine(startPosX, startPosY, endPosX, endPosY, color.ptr.ref);

bool IsKeyPressed(raylib.KeyboardKey key) => raylib.IsKeyPressed(key.value);
bool IsKeyDown(raylib.KeyboardKey key) => raylib.IsKeyDown(key.value);
bool IsMouseButtonPressed(raylib.MouseButton button) =>
    raylib.IsMouseButtonPressed(button.value);
bool IsMouseButtonReleased(raylib.MouseButton button) =>
    raylib.IsMouseButtonReleased(button.value);
bool IsMouseButtonDown(raylib.MouseButton button) =>
    raylib.IsMouseButtonDown(button.value);

String GetGamepadName(int gamepad) {
  final namePtr = raylib.GetGamepadName(gamepad);
  final name = namePtr.cast<ffi.Utf8>().toDartString();
  return name;
}

double GetGamepadAxisMovement(int gamepad, raylib.GamepadAxis axis) =>
    raylib.GetGamepadAxisMovement(gamepad, axis.value);
bool IsGamepadButtonDown(int gamepad, raylib.GamepadButton button) =>
    raylib.IsGamepadButtonDown(gamepad, button.value);

raylib.GamepadButton GetGamepadButtonPressed() =>
    .fromValue(raylib.GetGamepadButtonPressed());

Vector2 GetMousePosition() => raylib.GetMousePosition().toDart();
Vector2 GetMouseDelta() => raylib.GetMouseDelta().toDart();
Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera) => useVector2(
  position,
  (positionPtr) {
    final worldPos = raylib.GetScreenToWorld2D(positionPtr.ref, camera.ptr.ref);
    return Vector2(worldPos.x, worldPos.y);
  },
);

Vector2 GetTouchPosition(int index) {
  final ret = raylib.GetTouchPosition(index);
  return Vector2(ret.x, ret.y);
}

raylib.Gesture GetGestureDetected() => .fromValue(raylib.GetGestureDetected());

void SetConfigFlags(raylib.ConfigFlags flags) =>
    raylib.SetConfigFlags(flags.value);

raylib.Texture2D LoadTexture(String fileName) {
  final fileNamePtr = fileName.toNativeUtf8().cast<Char>();
  final texture = raylib.LoadTexture(fileNamePtr);
  ffi.malloc.free(fileNamePtr);
  return texture;
}

void DrawTexture(raylib.Texture2D texture, int posX, int posY, Color tint) =>
    raylib.DrawTexture(texture, posX, posY, tint.ptr.ref);

bool CheckCollisionPointRec(Vector2 point, Rectangle rec) => useVector2(
  point,
  (pointPtr) => raylib.CheckCollisionPointRec(pointPtr.ref, rec.ptr.ref),
);

String TextToLower(String text) => text.toLowerCase();
int TextFindIndex(String text, String find) => text.indexOf(find);
