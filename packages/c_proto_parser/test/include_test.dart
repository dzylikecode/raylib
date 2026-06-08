import 'package:c_proto_parser/c_proto_parser.dart';
import 'package:test/test.dart';

void main() {
  group('parseCInclude', () {
    test('parses a local include', () {
      final include = parseCInclude('#include "raylib.h"');

      expect(include.path, 'raylib.h');
    });

    test('accepts whitespace around directive tokens', () {
      final include = parseCInclude('  #  include   "core/basic_window.h"  ');

      expect(include.path, 'core/basic_window.h');
    });

    test('ignores trailing line comment', () {
      final include = parseCInclude('#include "raymath.h" // math helpers');

      expect(include.path, 'raymath.h');
    });

    test('throws for system includes', () {
      expect(
        () => parseCInclude('#include <stdio.h>'),
        throwsA(isA<CIncludeParseException>()),
      );
    });
  });

  group('parseCIncludes', () {
    test('parses all local includes from source', () {
      final includes = parseCIncludes('''
#include "raylib.h"

int main(void);
# include "raymath.h"
''');

      expect(includes.map((include) => include.path), [
        'raylib.h',
        'raymath.h',
      ]);
    });
  });
}
