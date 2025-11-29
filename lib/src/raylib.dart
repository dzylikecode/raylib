// ignore_for_file: non_constant_identifier_names

import 'raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'package:vector_math/vector_math.dart';

import 'color.dart';
import 'rectangle.dart';

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

void DrawCircleV(Vector2 center, double radius, Color color) {
  final centerPtr = center.ptr;
  raylib.DrawCircleV(centerPtr.ref, radius, color.ptr.ref);
  ffi.malloc.free(centerPtr);
}

void DrawRectangle(int posX, int posY, int width, int height, Color color) =>
    raylib.DrawRectangle(posX, posY, width, height, color.ptr.ref);
void DrawCircle(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircle(centerX, centerY, radius, color.ptr.ref);
void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color) {
  final v1Ptr = v1.ptr;
  final v2Ptr = v2.ptr;
  final v3Ptr = v3.ptr;
  raylib.DrawTriangle(v1Ptr.ref, v2Ptr.ref, v3Ptr.ref, color.ptr.ref);
  ffi.malloc.free(v1Ptr);
  ffi.malloc.free(v2Ptr);
  ffi.malloc.free(v3Ptr);
}

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

bool IsKeyPressed(raylib.KeyboardKey key) => raylib.IsKeyPressed(key.value);
bool IsKeyDown(raylib.KeyboardKey key) => raylib.IsKeyDown(key.value);
bool IsMouseButtonPressed(raylib.MouseButton button) =>
    raylib.IsMouseButtonPressed(button.value);

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

Vector2 GetMousePosition() {
  final ret = raylib.GetMousePosition();
  return Vector2(ret.x, ret.y);
}

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

bool CheckCollisionPointRec(Vector2 point, Rectangle rec) {
  final pointPtr = point.ptr;
  final result = raylib.CheckCollisionPointRec(pointPtr.ref, rec.ptr.ref);
  ffi.malloc.free(pointPtr);
  return result;
}

String TextToLower(String text) => text.toLowerCase();
int TextFindIndex(String text, String find) => text.indexOf(find);

extension on Vector2 {
  Pointer<raylib.Vector2> get ptr {
    final pointer = ffi.malloc<raylib.Vector2>();
    pointer.ref
      ..x = x
      ..y = y;
    return pointer;
  }
}
