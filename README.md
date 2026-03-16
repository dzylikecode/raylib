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

根据 [api](https://www.raylib.com/cheatsheet/cheatsheet.html) 导出 C API 到 docs/ 目录下，分别对应 rcore.dart、rshapes.dart、rtextures.dart、rtext.dart、rmodels.dart、raudio.dart。

以 rcore.dart 为例，先把所有 API 以注释形式列出，然后逐个判断封装策略：

```dart
// 直接导出（无需封装）
export 'src/raylib.g.dart' show CloseWindow;

// 需要封装（注释原始导出，在后面写 Dart 版本）
// export 'src/raylib.g.dart' show InitWindow;

void InitWindow(int width, int height, String title) {
  // ...
}
```

每个函数的封装策略见下方各小节。

### 不代理


- `MemAlloc / MemRealloc / MemFree` — 不暴露给用户

### char 类型

C 的 `const char *` 参数换成 Dart `String`，在函数体内用 Arena 临时分配 native 内存：

```dart
void InitWindow(int width, int height, String title) => ffi.using((arena) {
  raylib.InitWindow(width, height, title.toNativeUtf8(allocator: arena).cast());
});
```

### 格式化输出

```c
TextFormat("FPS: %i (target: %i)", GetFPS(), currentFps);
```

将变量用数组传入

```dart
TextFormat("FPS: %i (target: %i)", [GetFPS(), currentFps]);
```

### TextCopy

Dart 的函数参数是**值传递（pass-by-value）**。当传入对象时，传递的是**对象引用的值**，而不是像 C/C++ 那样直接传递可操作的内存指针。因此，在函数内部重新给参数赋值，只会改变函数内部的引用副本，不会影响外部变量。这也是 Dart 中通常不会设计类似 `TextCopy(dst, src)` 这种通过修改目标内存完成拷贝的接口的原因。

**示例**

```dart
void textCopy(String dst, String src) {
  dst = src;   // 只改变函数内部的 dst 引用
}

void main() {
  String a = "hello";
  String b = "world";

  textCopy(a, b);

  print(a); // 仍然输出 "hello"
}
```

在这个例子中，`textCopy` 内部对 `dst` 的赋值只改变了函数内部的引用副本，并不会修改外部变量 `a` 的值。


### List（数组 + count）

C 的 `T* array, int count` 换成 Dart `List<T>`，消除 count 参数：

```dart
void DrawTriangleStrip(List<Vector2> points, Color color) => ffi.using((arena) {
  raylib.DrawTriangleStrip(arena.vector2s(points), points.length, color.ptr.ref);
});
```

### enum 或宏

C 的裸 `int` 参数（枚举/宏）换成 Dart enum，具备更好的语义和 dot-shorthands。同时保留原 C 常量名并标注 `@Deprecated`，让从 C 迁移过来的代码无需立即修改也能编译，逐步过渡到 Dart 风格：

```dart
enum KeyboardKey {
  a(.KEY_A),
  // ...
}

// 保留原 C 常量名，兼容旧写法，但引导用户迁移到 enum
@Deprecated('Use .a instead')
const KeyboardKey KEY_A = .a;
```

函数签名同步替换：

```dart
// C 风格
bool IsKeyDown(int key) => ...

// Dart 风格
bool IsKeyDown(KeyboardKey key) => raylib.IsKeyDown(key.value);
```

### Uint8List（原始字节）

`void*` / `unsigned char*` 像素或文件数据参数换成 `Uint8List`，函数内部用 Arena 复制到 native 内存：

```dart
void UpdateTexture(Texture texture, Uint8List pixels) => ffi.using((arena) {
  final ptr = arena<Uint8>(pixels.length);
  ptr.asTypedList(pixels.length).setAll(0, pixels);
  raylib.UpdateTexture(arena.texture(texture).ref, ptr.cast());
});
```

### Record（out 参数）

C 的 out 参数（`int* bytesRead`、`bool* collided`）换成 Dart record：

```dart
// C: int GetCodepoint(const char *text, int *codepointSize)
(int codepoint, int bytesRead) GetCodepoint(String text) => ffi.using((arena) {
  final sizePtr = arena<Int>();
  final cp = raylib.GetCodepoint(text.toNativeUtf8(allocator: arena).cast(), sizePtr);
  return (cp, sizePtr.value);
});

// C: bool CheckCollisionLines(..., Vector2 *collisionPoint)
(bool collided, Vector2? point) CheckCollisionLines(...) => ffi.using((arena) {
  final out = arena<raylib.Vector2>();
  final hit = raylib.CheckCollisionLines(..., out);
  return (hit, hit ? out.ref.toDart() : null);
});
```

### 纯数据对象（copy）

函数只读取数据、不保留引用，用 Arena 做临时 native 内存，调用完自动释放：

- `Vector2 / Vector3 / Ray` — 传参时拷贝到 Arena，返回时拷贝回 Dart
- `Texture / RenderTexture2D` — 不透明 GPU 句柄，只存 `id` 等整数字段，值类型传参
- `LoadRandomSequence` — 返回纯数据，拷贝成 `List<int>` 后立即 `UnloadRandomSequence`；对外提供空壳 `UnloadRandomSequence` 保持 API 兼容

### 副作用数据（pointer + Finalizer）

C 结构体需要在多次调用之间保持稳定地址（如 `Camera2D` 被 `BeginMode2D` 读取），用 Dart 类持有原生指针，并注册 `Finalizer` 自动释放：

```dart
class Camera2D {
  final Pointer<raylib.Camera2D> ptr;
  static final _finalizer = Finalizer<Pointer<raylib.Camera2D>>(ffi.malloc.free);
  Camera2D._(this.ptr) { _finalizer.attach(this, ptr, detach: this); }
  // ...
  void dispose() { _finalizer.detach(this); ffi.malloc.free(ptr); }
}
```

对外 Unload API 转发到 dispose：

```
UnloadXxx(用户) → dispose() → C UnloadXxx / ffi.malloc.free
```

需要 Finalizer 的类型：`Camera2D`、`Camera3D`、`Shader`、`VrStereoConfig`、`AutomationEventList`。

GPU 资源（`Texture`、`RenderTexture2D`）不注册 Finalizer：OpenGL context 销毁后无法安全调用 GPU 释放函数，必须由用户显式 Unload。

### 自动 Unload（Load → Dart 类型）

Load 函数返回需要手动 Unload 的 C 资源，但 Dart 侧只需要数据时，在函数内部完成 Load → 转换 → Unload 三步，对外直接返回 Dart 类型：

```dart
// C: FilePathList LoadDirectoryFiles(const char *dirPath)
List<String> LoadDirectoryFiles(String path) => ffi.using((arena) {
  final list = raylib.LoadDirectoryFiles(...);
  final result = [for (var i = 0; i < list.count; i++) list.paths[i].cast<Utf8>().toDartString()];
  raylib.UnloadDirectoryFiles(list);
  return result;
});
```

### Dart 回调

C 的函数指针回调（`SetLoadFileDataCallback` 等）换成 Dart 函数，内部用 `NativeCallable` 桥接：

```dart
// 使用默认回调
SetLoadFileDataCallback(null);
// 注入 Dart 实现
SetLoadFileDataCallback((filename) => File(filename).readAsBytesSync());
```

### 尚未代理

以下模块因对应 C struct 尚未封装成 Dart 类，暂时注释掉，留作后续实现：

- `Image` — `LoadImage*`、`GenImage*`、`Image*` 操作（rtextures.dart）
- `Font` — `LoadFont*`、`DrawTextEx`、`MeasureTextEx` 等（rtext.dart）
- `Wave / Sound / Music / AudioStream` — 全部音频播放 API（raudio.dart）
- `Model / Mesh / Material / ModelAnimation / BoundingBox / RayCollision` — 3D 模型 API（rmodels.dart）

### Dart 生态替代

C 的某些数据类型，在 Dart 生态中已有成熟的对应库，直接用它们替代，而不是自己造轮子：

- `Vector2 / Vector3 / Matrix / Ray` — 用 [vector_math](https://pub.dev/packages/vector_math)，同名类型，直接对应
- `Image`（像素数据）— 用 [image](https://pub.dev/packages/image) 的 `img.Image`，具备完整的编解码和像素操作能力

封装层负责在 Dart 类型和 C struct 之间做转换桥接（通过 Arena 临时复制），对调用者完全透明：

```dart
// 调用者传入 img.Image，封装层负责转成 raylib.Image 传给 C
Texture LoadTextureFromImage(img.Image image) => ffi.using((arena) {
  return raylib.LoadTextureFromImage(arena.image(image).ref).toDart();
});
```


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
