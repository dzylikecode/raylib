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

## 架构

按照 [api](https://www.raylib.com/cheatsheet/cheatsheet.html) 告诉 AI 依次导出相应的文件，然后我不过是对一些函数进行代理，使得 API 更加 Dart 风格。



```dart
void SetWindowIcons(List<Image> images, [int? count])
```
> 兼容 C 的 API，同时提供更 Dart 风格的 API， 可以不传递 count 参数


RenderTexture2D 这个是存在 GPU 里面的，所以是一个 id，因此就是 dart —> C 的 id 描述，并不需要拷贝数据

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
final seq = RandomSequence(count, min, max);
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
