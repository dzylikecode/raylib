# raylib

[中文](README_zh.md) | [English](README_en.md)

[raylib](https://github.com/raysan5/raylib) 对 dart 的 ffi 绑定. API 基本与 C 的一致。将 C 代码复制粘贴到 dart 中，稍微做一些改动即可运行。

## quick start

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

第一次执行以下命令会编译 raylib 的并生成动态库，会需要消耗比较久的时间

```bash
dart run example/example.dart
```

## 渔法

> "授人以渔". 不仅是人，还包括 AI.

根据 [api](https://www.raylib.com/cheatsheet/cheatsheet.html) 导出 C API 到 docs/ 目录下， 分别为 rcore

定义响应的文件 rcore.dart ... 以 rcore 为例子

先 export 所有的 api. eg

```dart
export 'src/raylib.g.dart' show InitWindow;
export 'src/raylib.g.dart' show CloseWindow;
// ...
export 'src/raylib.g.dart' show UpdateCameraPro;
```

然后依次找一些不太 Dart 风格的 API，进行改造。

首先注释掉原来的 API，然后在后面实现一个更 Dart 风格的 API

```dart
// export 'src/raylib.g.dart' show InitWindow;
export 'src/raylib.g.dart' show CloseWindow;
// ...
export 'src/raylib.g.dart' show UpdateCameraPro;

void InitWindow(int width, int height, String title) {
  // ...
}
```

### char 类型

用 dart 的 String

### list

用 List 来代替 C 的数组，同时这样可以避免传递 count 参数

```dart
void SetWindowIcons(List<Image> images, [int? count])
```
> 兼容 C 的 API，同时提供更 Dart 风格的 API， 可以不传递 count 参数


### enum 或者 宏

用 enum 来代替 C 的宏或者 enum，这样有更好的语义化，可以简短的写法（dot shorthands）

```dart
enum KeyboardKey {
  a(.KEY_A),
}

@Deprecated('Use .a instead')
const KeyboardKey KEY_A = .a;
```

1. 定义新的 enum，值为原来 C API 的值
2. 定义一个 Deprecated 的常量，值为新的 enum 的值，兼容原来的 C API，同时推荐使用新的 enum

### 纯数据对象

比如 Vector2/Vector3 这些。函数只是读一下数据，并不修改数据，因此直接采用 dart 与 c 互相复制数据的方式来实现

RenderTexture2D 这个是存在 GPU 里面的，它是一个透明指针，所以也是 dart 与 c 互相复制数据的方式来实现

LoadRandomSequence 它返回的也是纯的数据，因此也是 dart 与 c 互相复制数据的方式来实现。并且提供一个什么也不做的 UnloadRandomSequence 来兼容 C API

### 副作用数据

比如 Camera2D 它会被 BeginMode2D 所依赖，因此它采用 wrapper 的方式来实现，里面持有一个指向 C 结构体的指针，自动释放的时候，调用 Unload 之类的函数。然后在给用户的 Unload API 调用的是 dispose 函数

Unload(用户) -> dispose -> Unload(底层 C API)

提供自动释放的功能，用户可以不调用 Unload 就能正确释放资源


## 从 C 迁移

### main 函数改造

```c
int main(void)
```

```dart
int main()
```

### 整除

dart 用 `~/` 代替 C 的 `/` 进行整除

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
final seq = LoadRandomSequence(count, min, max);
UnloadRandomSequence(seq); // 什么也不做
```

### 格式化输出

```c
TextFormat("FPS: %i (target: %i)", GetFPS(), currentFps);
```

将变量用数组传入

```dart
TextFormat("FPS: %i (target: %i)", [GetFPS(), currentFps]);
```

### 字符串

使用 String 类型而不是 char*

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
