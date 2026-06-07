# c_proto_parser

Parse simple C function prototypes into structured Dart metadata.

This package is intended for small Dart FFI tooling, wrapper generators, and
codegen experiments where you want to turn a C declaration like this:

```c
void InitWindow(int width, int height, const char *title);
```

into metadata like:

```dart
CFunction(
  name: 'InitWindow',
  returnType: CType(base: 'void'),
  params: [
    CParam(name: 'width', type: CType(base: 'int')),
    CParam(name: 'height', type: CType(base: 'int')),
    CParam(
      name: 'title',
      type: CType(base: 'char', isConst: true, pointerDepth: 1),
    ),
  ],
)
```

It is deliberately small. It does not try to be a complete C parser. If you
need full C preprocessing, macro expansion, typedef resolution, or complete C
AST support, use Clang/libclang or a tool built on top of it.

## Features

- Parse one C function prototype from a string.
- Read the function name, return type, parameter names, and parameter types.
- Preserve basic type qualifiers such as `const`.
- Track pointer depth, such as `char *` and `float **`.
- Track simple array suffixes, such as `int values[4]`.
- Treat `void` parameter lists as empty parameter lists.
- Report unsupported function pointer parameters with a clear exception.

## Usage

```dart
import 'package:c_proto_parser/c_proto_parser.dart';

void main() {
  final function = parseCFunctionPrototype(
    'void InitWindow(int width, int height, const char *title);',
  );

  print(function.name); // InitWindow
  print(function.returnType.base); // void

  final title = function.params[2];
  print(title.name); // title
  print(title.type.base); // char
  print(title.type.isConst); // true
  print(title.type.pointerDepth); // 1
  print(title.type.isConstCharPointer); // true
}
```

### Parse a returned pointer

```dart
final function = parseCFunctionPrototype(
  'const char *GetClipboardText(void);',
);

print(function.name); // GetClipboardText
print(function.returnType.base); // char
print(function.returnType.isConst); // true
print(function.returnType.pointerDepth); // 1
print(function.params.isEmpty); // true
```

### Parse custom typedef-like names

```dart
final function = parseCFunctionPrototype(
  'Texture2D LoadTexture(const char *fileName);',
);

print(function.returnType.base); // Texture2D
print(function.params.single.name); // fileName
print(function.params.single.type.isConstCharPointer); // true
```

### Parse arrays

```dart
final function = parseCFunctionPrototype(
  'void UploadValues(int values[4]);',
);

final values = function.params.single;
print(values.type.base); // int
print(values.type.arraySuffix); // [4]
print(values.type.isArray); // true
```

## Supported syntax

This parser is designed for straightforward C API declarations, especially
headers shaped like many game, graphics, and FFI-friendly C libraries.

Examples that are supported:

```c
void InitWindow(int width, int height, const char *title);
Color Fade(Color color, float alpha);
Texture2D LoadTexture(const char *fileName);
const char *GetClipboardText(void);
void SetShaderValue(Shader shader, int locIndex, const float *value, int type);
void UploadValues(int values[4]);
```

## Limitations

The parser does not currently support:

- Function pointer parameters, such as `void (*callback)(int)`.
- C preprocessing or macro expansion.
- Typedef resolution.
- Struct, union, or enum definitions.
- Multiple declarations in one string.
- Full C declaration grammar.

Unsupported function pointer parameters throw `CPrototypeParseException`.

## TODO

- use petitparser???
