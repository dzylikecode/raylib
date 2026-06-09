# cdart

[Chinese](README.md) | [English](README_en.md)

While binding raylib to Dart, I wanted to keep the code compatible with C. During the experiment, C code could almost be copied directly into Dart and then run after a few small edits. That was the moment I realized how similar Dart and C are: Dart feels almost like C with built-in garbage collection.

Reference: [musl](https://musl.libc.org/) | [source](https://git.musl-libc.org/cgit/musl.git) | [mirror](https://github.com/bminor/musl)

```bash
git clone https://git.musl-libc.org/git/musl
```

## Quick Start

```dart
import 'package:cdart/stdio.dart';

int main() {
  printf("Hello, cdart!");
  return 0;
}
```

## Migrating from C to Dart

### Suffixes

For C suffixes such as `f` and `L`, add a `.` before the suffix.

```dart
// C: float f = 3.14f;
float f = 3.14.f;
```

For complex numbers, `.c` converts a value to a complex number, and `.i` multiplies it by the imaginary unit `i`.

```dart
// C: complex double c = 1.0 + 3.0i;
complex c = 1.0.c + 3.0.i;
```

### Pointers

Pointers behave like arrays.

```dart
// C: char *str = "Hello, World!";
chars str = "Hello, World!";
```

### Removed

- sizeof: not needed.
