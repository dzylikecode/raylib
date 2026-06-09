# raylib

[Chinese](README.md) | [English](README_en.md)

[raylib](https://github.com/raysan5/raylib) FFI bindings for Dart. You can copy C code into Dart and usually get it running with only small changes.

> [!NOTE]
>
> The raylib backend uses [xmake](https://xmake.io/). When you run Dart code, hooks automatically download xmake.

## Quick Start

```dart
import 'package:raylib_dart/raylib_dart.dart';

int main()
{
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - basic window");

    SetTargetFPS(60);
    while (!WindowShouldClose())
    {
        BeginDrawing();

            ClearBackground(RAYWHITE);

            DrawText("Congrats! You created your first window!", 190, 200, 20, LIGHTGRAY);

        EndDrawing();
    }

    CloseWindow();
    return 0;
}
```

## Migration

- MemAlloc/MemRealloc/MemFree are no-ops.
- `char *` is treated as a UTF-8 byte stream.
- TextFormat/TraceLog support up to 9 arguments. This is only for compatibility with C code; Dart has better native options, such as string interpolation.
- TextCopy has a different function interface because Dart passes object references by value.
- C APIs shaped like `T* array, int count` are exposed as Dart `List<T>`, removing the `count` parameter. When compatibility conflicts with simplicity, this package chooses simplicity.
- Raw C `int` parameters used for enums/macros are exposed as Dart enums for better semantics and dot-shorthand support. The original C constant names are also preserved.
- LoadRandomSequence returns a pure Dart object. UnloadRandomSequence is a compatibility no-op.
- Vector2/Vector3/Matrix/Ray are represented by [vector_math](https://pub.dev/packages/vector_math).

## Migrating from C

### Main Function

```c
int main(void)
```

```dart
int main()
```

### Integer Division

Dart uses `~/` for integer division instead of C's `/`.

### Float Type

This is defined in cdart.

```c
float a = 1.0f;
```

```dart
float a = 1.0.f;
```

### Type Conversion

```c
(int)(leftStickX*20)
```

```dart
(leftStickX*20).toInt()
```

## Wrapping Principles

### Keep the C API as Much as Possible

- Keep function names unchanged.
- Preserve the original enums and constants.

### Encourage Dart's Concise Features

For enums, dot-shorthand is recommended to simplify code. The original constants are kept, marked as deprecated, and paired with the recommended style.

```dart
Color color = RED; // Deprecated
Color color = .red; // Recommended

KeyboardKey key = KEY_A; // Deprecated
KeyboardKey key = .a; // Recommended
```

## TODO

- [ ] Port raylib examples.
- [ ] Support web.

## Issues

- [ ] [Function forwarding](https://github.com/Dart-Code/Dart-Code/issues/6081)


