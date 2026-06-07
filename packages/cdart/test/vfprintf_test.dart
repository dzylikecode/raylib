import 'package:test/test.dart';
import 'package:cdart/src/vfprintf.dart';
import 'package:cdart/src/stdio_impl.dart';
import 'package:cdart/stdarg.dart';

// Convenience: call sprintf and assert result equals expected.
void check(String expected, String fmt, List<Object> args) {
  final got = sprintf(fmt, args);
  expect(got, equals(expected),
      reason: 'sprintf("$fmt", $args) => "$got" but expected "$expected"');
}

void main() {
  group('literal text', () {
    test('plain string', () => check('hello', 'hello', []));
    test('empty format',  () => check('',      '',      []));
    test('%%',            () => check('%',     '%%',    []));
    test('%% in text',    () => check('100%',  '100%%', []));
  });

  group('%d / %i – signed decimal', () {
    test('zero',          () => check('0',     '%d',  [0]));
    test('positive',      () => check('42',    '%d',  [42]));
    test('negative',      () => check('-7',    '%d',  [-7]));
    test('width right',   () => check('   42', '%5d', [42]));
    test('width left',    () => check('42   ', '%-5d',[42]));
    test('zero-pad',      () => check('00042', '%05d',[42]));
    test('plus sign',     () => check('+42',   '%+d', [42]));
    test('space sign',    () => check(' 42',   '% d', [42]));
    test('precision 0 of 0', () => check('', '%.0d', [0]));
    test('precision > digits', () => check('00042', '%.5d', [42]));
    test('width+prec',    () => check('  00042', '%7.5d', [42]));
  });

  group('%u – unsigned decimal', () {
    test('zero',     () => check('0',     '%u',  [0]));
    test('positive', () => check('255',   '%u',  [255]));
    test('width',    () => check('  255', '%5u', [255]));
    test('precision 0 of 0', () => check('', '%.0u', [0]));
  });

  group('%x / %X – hexadecimal', () {
    test('zero',         () => check('0',      '%x',  [0]));
    test('lowercase',    () => check('ff',     '%x',  [255]));
    test('uppercase',    () => check('FF',     '%X',  [255]));
    test('alt-form 0x',  () => check('0xff',   '%#x', [255]));
    test('alt-form 0X',  () => check('0XFF',   '%#X', [255]));
    test('alt-form zero',() => check('0',      '%#x', [0])); // no prefix for 0
    test('width',        () => check('   ff',  '%5x', [255]));
    test('zero-pad',     () => check('000ff',  '%05x',[255]));
    test('precision',    () => check('000ff',  '%.5x',[255]));
    test('precision 0 of 0', () => check('',   '%.0x',[0]));
  });

  group('%o – octal', () {
    test('zero',      () => check('0',    '%o',  [0]));
    test('value',     () => check('17',   '%o',  [15]));
    test('alt-form',  () => check('017',  '%#o', [15]));
    test('width',     () => check('   17','%5o', [15]));
    test('zero-pad',  () => check('00017','%05o',[15]));
    test('precision 0 of 0', () => check('', '%.0o', [0]));
  });

  group('%s – string', () {
    test('basic',         () => check('hello',   '%s',    ['hello']));
    test('width right',   () => check('   hi',   '%5s',   ['hi']));
    test('width left',    () => check('hi   ',   '%-5s',  ['hi']));
    test('precision',     () => check('hel',     '%.3s',  ['hello']));
    test('precision+width',() => check('  hel',  '%5.3s', ['hello']));
    test('null ptr',      () => check('(null)',  '%s',    [0]));
  });

  group('%c – character', () {
    test('letter',  () => check('A',    '%c',   [65]));
    test('width',   () => check('    A','%5c',  [65]));
    test('left',    () => check('A    ','%-5c', [65]));
  });

  group('%f – fixed float', () {
    test('zero',          () => check('0.000000',     '%f',    [0.0]));
    test('pi default',    () => check('3.141593',     '%f',    [3.141592653589793]));
    test('neg',           () => check('-1.500000',    '%f',    [-1.5]));
    test('precision 0',   () => check('3',            '%.0f',  [3.14]));
    test('precision 2',   () => check('3.14',         '%.2f',  [3.14159]));
    test('width',         () => check('  3.14',       '%6.2f', [3.14]));
    test('zero-pad',      () => check('003.14',       '%06.2f',[3.14]));
    test('plus sign',     () => check('+3.14',        '%+.2f', [3.14]));
    test('space sign',    () => check(' 3.14',        '% .2f', [3.14]));
    test('left-adjust',   () => check('3.14  ',       '%-6.2f',[3.14]));
  });

  group('%e – scientific', () {
    test('basic',     () => check('3.141593e+00',  '%e',    [3.141592653589793]));
    test('uppercase', () => check('3.141593E+00',  '%E',    [3.141592653589793]));
    test('precision', () => check('3.14e+00',      '%.2e',  [3.14]));
    test('neg exp',   () => check('1.20e-03',      '%.2e',  [0.0012]));
    test('width',     () => check('   3.14e+00',   '%11.2e',[3.14]));
  });

  group('%g – general float', () {
    test('use-f small',   () => check('3.14159',   '%g',    [3.14159]));
    test('use-e large',   () => check('1.23457e+06','%g',   [1234567.0]));
    test('trailing zeros removed', () => check('3',  '%g',  [3.0]));
    test('precision',     () => check('3.142',      '%.4g',  [3.14159]));
    test('uppercase',     () => check('3.14159',   '%G',    [3.14159]));
    test('small neg exp', () => check('0.001',     '%g',    [0.001]));
    test('very small',    () => check('1e-05',     '%g',    [0.00001]));
  });

  group('%a – hex float', () {
    test('zero',           () => check('0x0p+0',               '%a',    [0.0]));
    test('one (auto)',     () => check('0x1p+0',               '%a',    [1.0]));
    test('one (prec 13)',  () => check('0x1.0000000000000p+0', '%.13a', [1.0]));
    test('1.5 (auto)',     () => check('0x1.8p+0',             '%a',    [1.5]));
    test('uppercase zero', () => check('0X0P+0',               '%A',    [0.0]));
    test('uppercase one',  () => check('0X1P+0',               '%A',    [1.0]));
  });

  group('special float values', () {
    test('inf',      () => check('inf',  '%f', [double.infinity]));
    test('-inf',     () => check('-inf', '%f', [double.negativeInfinity]));
    test('nan',      () => check('nan',  '%f', [double.nan]));
    test('INF upper',() => check('INF',  '%F', [double.infinity]));
    test('NAN upper',() => check('NAN',  '%F', [double.nan]));
  });

  group('%p – pointer', () {
    test('zero (null)',   () {
      final got = sprintf('%p', [0]);
      expect(got, equals('0000000000000000'));
    });
    test('non-zero',      () {
      final got = sprintf('%p', [0xFF]);
      expect(got, equals('0x00000000000000ff'));
    });
  });

  group('flags combinations', () {
    test('left + zero (left wins)',   () => check('42   ', '%-05d', [42]));
    test('plus + negative',           () => check('-42',   '%+d',   [-42]));
    test('space + negative',          () => check('-42',   '% d',   [-42]));
    test('width > content',           () => check('    hello', '%9s', ['hello']));
  });

  group('multiple arguments', () {
    test('two ints',   () => check('1 2',     '%d %d',  [1, 2]));
    test('int+string', () => check('42 hi',   '%d %s',  [42, 'hi']));
    test('mixed',      () => check('x=3.14',  'x=%.2f', [3.14159]));
  });

  group('return value', () {
    test('counts output chars', () {
      final f  = FILE();
      final ap = va_list([42], 0);
      final n  = vfprintf(f, '%d', ap);
      expect(n, equals(2));
      expect(f.content, equals('42'));
    });
  });
}
