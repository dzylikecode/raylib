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
dart run example/core_basic_window.dart
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
IsKeyDown(KEY_RIGHT); // Deprecated
IsKeyDown(.right); // Recommended
```

### math

Vector2/Vector3/Matrix/Ray 等用 [vector_math](https://pub.dev/packages/vector_math)

### image

采用 [image](https://pub.dev/packages/image)

### LoadRandomSequence/UnloadRandomSequence

合并为 RandomSequence

```c
int* seq = LoadRandomSequence(count, min, max);
UnloadRandomSequence(seq);
```

```dart
final seq = RandomSequence(count, min, max);
```

### 全局回调

- SetLoadFileDataCallback
- SetSaveFileDataCallback
- SetLoadFileTextCallback
- SetSaveFileTextCallback

以 SetLoadFileDataCallback 为例子

```dart
// 使用 raylib 的默认回调
SetLoadFileDataCallback(); // SetLoadFileDataCallback(null);
// dart 进行 hook
SetLoadFileDataCallback((filename) => File(filename).readSync());
```

### 移除

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

- SetTraceLogCallback: 也许可以合并到 logging 中


## 封装原则

### 尽可能保持 C API
  
- 保持函数名不变
- 保留原来的枚举和常量

### 鼓励使用 Dart 的简洁特性

例如枚举，推荐使用 dot-shorthands 来简化代码。保留原来的常量，标注上 Deprecated, 同时给出推荐使用的写法。

```dart
Color color = RED; // Deprecated
Color color = .red; // Recommended

KeyboardKey key = KEY_A; // Deprecated
KeyboardKey key = .a; // Recommended
```
