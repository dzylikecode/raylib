# cdart

[中文](README.md) | [English](README_en.md)

在给 raylib 绑定到 Dart 的过程中，希望兼容 C。实验地过程当中，几乎可以复制 C 代码到 Dart 中，然后做一些小的修改即可。此刻，意识到 Dart 和 C 是何其相似，简直就是自带 GC 的 C。

参考 [musl](https://musl.libc.org/) | [source](https://git.musl-libc.org/cgit/musl.git) | [mirror](https://github.com/bminor/musl)

```bash
git clone https://git.musl-libc.org/git/musl
```

## quick start

```dart
import 'package:cdart/stdio.dart';

int main() {
  printf("Hello, cdart!");
  return 0;
}
```

## 从 C 迁移到 Dart

### 后缀

对于 C 语言中的后缀，比如 `f`、`L`，需要加上 `.`

```dart
// C: float f = 3.14f;
float f = 3.14.f;
```

复数: `.c` 表示转化为复数，`.i` 表示乘以虚数单位 i

```dart
// C: complex double c = 1.0 + 3.0i;
complex c = 1.0.c + 3.0.i;
```

### 指针

指针相当于是数组

```dart
// C: char *str = "Hello, World!";
chars str = "Hello, World!";
```

### 移除

- sizeof： 不需要
