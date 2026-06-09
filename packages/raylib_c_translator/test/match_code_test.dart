import 'package:raylib_c_translator/raylib_c_translator.dart';
import 'package:test/test.dart';

void main() {
  test('keeps casts unless a cast rule is provided', () {
    final translator = RaylibTranslator({});

    expect(
      translator('Vector2 delta = { 0, (float)screenHeight/3.0f };'),
      'Vector2 delta = { 0, (float)screenHeight/3.0f };',
    );
  });

  test('converts C floating-point casts when enabled', () {
    final translator = RaylibTranslator({
      MatchCode.cFloatingCast,
      MatchCode.floatSuffix,
    });

    expect(
      translator('Vector2 delta = { 0, (float)screenHeight/3.0f };'),
      'Vector2 delta = { 0, screenHeight.toDouble()/3.0 };',
    );

    expect(
      translator('float value = (float)(screenHeight + 10);'),
      'float value = (screenHeight + 10).toDouble();',
    );
  });

  test('converts common C numeric casts with loose rule', () {
    final translator = RaylibTranslator({MatchCode.cNumericCastLoose});

    expect(
      translator('int value = (unsigned char)data[i] + (int)offset;'),
      'int value = data[i].toInt() + offset.toInt();',
    );
  });

  test('converts struct initializers when enabled', () {
    final translator = RaylibTranslator({StructInitializer.vector2});

    expect(
      translator('Vector2 deltaCircle = { 0, screenHeight.toDouble()/3.0 };'),
      'Vector2 deltaCircle = Vector2(0, screenHeight.toDouble()/3.0);',
    );

    expect(
      translator('DrawLineV((Vector2){0, y}, (Vector2){ width, y }, RED);'),
      'DrawLineV(Vector2(0, y), Vector2(width, y), RED);',
    );
  });

  test('wraps variadic function arguments in a list when enabled', () {
    final translator = RaylibTranslator({VariadicFunction.textFormat});

    expect(
      translator('TextFormat("FPS: %i (target: %i)", GetFPS(), currentFps)'),
      'TextFormat("FPS: %i (target: %i)", [GetFPS(), currentFps])',
    );

    expect(
      translator('TextFormat("%i", Clamp(GetFPS(), 0, 60), currentFps)'),
      'TextFormat("%i", [Clamp(GetFPS(), 0, 60), currentFps])',
    );
  });
}
