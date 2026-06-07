import 'package:c_proto_parser/c_proto_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseCFunctionPrototype', () {
    test('parses InitWindow', () {
      final function = parseCFunctionPrototype(
        'void InitWindow(int width, int height, const char *title);',
      );

      expect(function.name, 'InitWindow');
      expect(function.returnType.base, 'void');
      expect(function.returnType.isVoid, isTrue);
      expect(function.params, hasLength(3));

      expect(function.params[0].name, 'width');
      expect(function.params[0].type.base, 'int');

      expect(function.params[1].name, 'height');
      expect(function.params[1].type.base, 'int');

      expect(function.params[2].name, 'title');
      expect(function.params[2].type.base, 'char');
      expect(function.params[2].type.isConst, isTrue);
      expect(function.params[2].type.pointerDepth, 1);
      expect(function.params[2].type.isConstCharPointer, isTrue);
    });

    test('parses a function that returns const char pointer', () {
      final function = parseCFunctionPrototype(
        'const char *GetClipboardText(void);',
      );

      expect(function.name, 'GetClipboardText');
      expect(function.returnType.base, 'char');
      expect(function.returnType.isConst, isTrue);
      expect(function.returnType.pointerDepth, 1);
      expect(function.params, isEmpty);
    });

    test('parses typedef-like type names', () {
      final function = parseCFunctionPrototype(
        'Texture2D LoadTexture(const char *fileName);',
      );

      expect(function.name, 'LoadTexture');
      expect(function.returnType.base, 'Texture2D');
      expect(function.params.single.name, 'fileName');
      expect(function.params.single.type.isConstCharPointer, isTrue);
    });

    test('parses arrays and pointer parameters', () {
      final function = parseCFunctionPrototype(
        'void SetShaderValue(Shader shader, int locIndex, const float *value, int values[4]);',
      );

      expect(function.params[2].name, 'value');
      expect(function.params[2].type.base, 'float');
      expect(function.params[2].type.isConst, isTrue);
      expect(function.params[2].type.pointerDepth, 1);

      expect(function.params[3].name, 'values');
      expect(function.params[3].type.base, 'int');
      expect(function.params[3].type.arraySuffix, '[4]');
      expect(function.params[3].type.isArray, isTrue);
    });

    test('accepts missing semicolon', () {
      final function = parseCFunctionPrototype(
        'Color Fade(Color color, float alpha)',
      );

      expect(function.name, 'Fade');
      expect(function.returnType.base, 'Color');
      expect(function.params.map((param) => param.name), ['color', 'alpha']);
    });

    test('throws for function pointer parameters', () {
      expect(
        () => parseCFunctionPrototype('void Foo(void (*callback)(int));'),
        throwsA(isA<CPrototypeParseException>()),
      );
    });
  });
}
