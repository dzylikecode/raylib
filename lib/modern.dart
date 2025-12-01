import 'raylib.dart';

extension Camera2DExt on Camera2D {
  R using<R>(R Function(Camera2D) computation) {
    BeginMode2D(this);
    try {
      return computation(this);
    } finally {
      EndMode2D();
    }
  }
}

extension Camera3DExt on Camera3D {
  R using<R>(R Function(Camera3D) computation) {
    BeginMode3D(this);
    try {
      return computation(this);
    } finally {
      EndMode3D();
    }
  }

  void update(CameraMode mode) => UpdateCamera(this, mode);
  void updatePro(Vector3 movement, Vector3 rotation, double zoom) =>
      UpdateCameraPro(this, movement, rotation, zoom);
}

extension KeyExt on KeyboardKey {
  bool get isPressed => IsKeyPressed(this);
  bool get isPressedRepeat => IsKeyPressedRepeat(this);
  bool get isDown => IsKeyDown(this);
  bool get isReleased => IsKeyReleased(this);
  bool get isUp => IsKeyUp(this);
}

extension MouseButtonExt on MouseButton {
  bool get isPressed => IsMouseButtonPressed(this);
  bool get isDown => IsMouseButtonDown(this);
  bool get isReleased => IsMouseButtonReleased(this);
  bool get isUp => IsMouseButtonUp(this);
}
