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

    ClearBackground(RAYWHITE);

    DrawText(
      "Congrats! You created your first window!",
      190,
      200,
      20,
      LIGHTGRAY,
    );

    EndDrawing();
  }

  CloseWindow(); 
  return 0;
}
```

The first time you run the following command, it will compile raylib and generate dynamic libraries, which will take some time.

```bash
dart run example/example.dart
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
IsKeyDown(KEY_RIGHT); // Deprecated
IsKeyDown(.right); // Recommended
```

### Math

For Vector2, Vector3, Matrix, Ray, etc., use [vector_math](https://pub.dev/packages/vector_math).

### Image

Use the [image](https://pub.dev/packages/image) package.

### LoadRandomSequence/UnloadRandomSequence

Merged into a single `RandomSequence`:

```c
int* seq = LoadRandomSequence(count, min, max);
UnloadRandomSequence(seq);
```

```dart
final seq = RandomSequence(count, min, max);
```

### Global Callbacks

- SetLoadFileDataCallback
- SetSaveFileDataCallback
- SetLoadFileTextCallback
- SetSaveFileTextCallback

Example using SetLoadFileDataCallback:

```dart
// Use raylib's default callback
SetLoadFileDataCallback(); // or SetLoadFileDataCallback(null);
// Hook with Dart
SetLoadFileDataCallback((filename) => File(filename).readSync());
```

### Removed Functions

- TraceLog
- MemAlloc
- MemRealloc
- MemFree
- LoadFileData
- UnloadFileData
- SaveFileData
- ExportDataAsCode
- LoadFileText
- UnloadFileText
- SaveFileText
- SetGamepadMappings

### TODO

- SetTraceLogCallback: Could be merged into logging


## Wrapping Principles

### Keep C API as Much as Possible

- Keep function names unchanged
- Preserve original enumerations and constants

### Encourage Using Dart's Concise Features

For example, enumerations are recommended to use dot-shorthand syntax to simplify code. Keep the original constants but mark them as Deprecated, and provide the recommended usage.

```dart
Color color = RED; // Deprecated
Color color = .red; // Recommended

KeyboardKey key = KEY_A; // Deprecated
KeyboardKey key = .a; // Recommended
```
