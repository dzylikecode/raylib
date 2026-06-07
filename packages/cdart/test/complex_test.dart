import 'package:cdart/complex.dart';
import 'package:test/test.dart';

void main() {
  group("toString", () {
    test("negative", () {
      final c1 = 1.0.c - 3.i;
      expect(c1.toString(), "1.0 - 3.0i");
    });
    test("positive", () {
      final c2 = 2.0.c + 4.i;
      expect(c2.toString(), "2.0 + 4.0i");
    });
    test("real only", () {
      final c3 = 5.0.c;
      expect(c3.toString(), "5.0");
    });
    test("imaginary only", () {
      final c4 = 7.i;
      expect(c4.toString(), "7.0i");
    });
  });
}
