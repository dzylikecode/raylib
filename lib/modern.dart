import 'raylib.dart';

extension Camera2DExt on Camera2D {
  R using<R>(R Function(Camera2D) computation) {
    BeginMode2D(this);
    final ret = computation(this);
    EndMode2D();
    return ret;
  }
}

extension Camera3DExt on Camera3D {
  R using<R>(R Function(Camera3D) computation) {
    BeginMode3D(this);
    final ret = computation(this);
    EndMode3D();
    return ret;
  }
}
