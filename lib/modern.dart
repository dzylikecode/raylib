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
