# raylib

[raylib](https://github.com/raysan5/raylib) 对 dart 的 ffi 绑定. API 基本与 C 的一致。

## quick start

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

第一次执行以下命令会编译 raylib 的并生成动态库，会需要消耗比较久的时间

```bash
dart run example/core/core_basic_window.dart
```


## 从 C 迁移

### main 函数改造

```c
int main(void)
```

```dart
int main()
```

### 枚举

用 dart 的 dot-shorthands

```c
IsKeyDown(KEY_RIGHT);
```

```dart
IsKeyDown(.KEY_RIGHT);
```

