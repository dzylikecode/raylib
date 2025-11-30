# raylib

[raylib](https://github.com/raysan5/raylib) ffi bindings for Dart. The API is essentially consistent with C.

## Quick Start

```dart
import 'package:raylib_dart/raylib_dart.dart';

int main() {
  const int screenWidth = 800;
  const int screenHeight = 450;

  InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");

  SetTargetFPS(60); 

  while (!WindowShouldClose()) {

    BeginDrawing();

    ClearBackground(.RAYWHITE);

    DrawText(
      "Congrats! You created your first window!",
      190,
      200,
      20,
      .LIGHTGRAY,
    );

    EndDrawing();
  }

  CloseWindow(); 
  return 0;
}
```

The first time you run the following command, it will compile raylib and generate dynamic libraries, which will take some time.

```bash
dart run example/core/core_basic_window.dart
```

## Migration from C

### Main Function Transformation

```c
int main(void)
```

```dart
int main()
```

### Enumerations

Use Dart's dot-shorthand syntax:

```c
IsKeyDown(KEY_RIGHT);
```

```dart
IsKeyDown(.KEY_RIGHT);
```