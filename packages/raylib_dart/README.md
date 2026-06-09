# raylib

[中文](README_zh.md) | [English](README_en.md)

[raylib](https://github.com/raysan5/raylib) 对 dart 的 ffi 绑定. 将 C 代码复制粘贴到 dart 中，稍微一改即可运行。

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

## 迁移

- MemAlloc/MemRealloc/MemFree — 什么都不会做的
- `char *`被当作 utf-8 字节流
- TextFormat/TraceLog 最多支持 9 个参数传递。只是为了兼容 C 的代码，dart 本身有有更好的选择，比如字符串模板
- TextCopy 改变了函数接口，因为 dart 是值传递，传递的是对象引用的值
- C 的接口 `T* array, int count` 换成 Dart `List<T>`，消除了 count 参数。在兼容和简洁的冲突中，选择了简洁
- C 的裸 `int` 参数（枚举/宏）换成 Dart enum，具备更好的语义和 dot-shorthands。同时保留原 C 常量名
- LoadRandomSequence 返回的纯dart对象，UnloadRandomSequence无操作，仅仅是兼容代码
- Vector2/Vector3/Matrix/Ray 被 [vector_math](https://pub.dev/packages/vector_math) 所代理

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


### float 类型

这个定义在 cdart 里面

```c
float a = 1.0f;
```

```dart
float a = 1.0.f;
```

### 类型转化

```c
(int)(leftStickX*20)
```

```dart
(leftStickX*20).toInt()
```

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

## TODO

- [ ] 迁移 raylib 的 example
- [ ] 支持 web

## issue

- [ ] [函数转发](https://github.com/Dart-Code/Dart-Code/issues/6081)
