import 'package:ffi/ffi.dart';
import 'package:raylib/src/raylib.g.dart';

void main() {
  InitWindow(400, 500, "hello".toNativeUtf8().cast());
  while (!WindowShouldClose()) {
    BeginDrawing();
    // ClearBackground(
    //   Color()
    //     ..a = 255
    //     ..r = 135
    //     ..g = 206
    //     ..b = 235,
    // );
    // DrawText("Hello, world!", 190, 200, 20, LIGHTGRAY);
    EndDrawing();
  }
  CloseWindow();
}
