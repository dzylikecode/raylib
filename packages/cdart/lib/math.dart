import 'dart:math' as math;
import 'dart:typed_data';

// ============================================================
// Constants
// ============================================================

const NAN = double.nan;
const INFINITY = double.infinity;

const HUGE_VALF = double.infinity;
const HUGE_VAL = double.infinity;
const HUGE_VALL = double.infinity;

const MATH_ERRNO = 1;
const MATH_ERREXCEPT = 2;
const math_errhandling = 2;

const FP_ILOGBNAN = -2147483648;
const FP_ILOGB0 = -2147483648;

const FP_NAN = 0;
const FP_INFINITE = 1;
const FP_ZERO = 2;
const FP_SUBNORMAL = 3;
const FP_NORMAL = 4;

const MAXFLOAT = 3.40282346638528859812e+38;
const HUGE = 3.40282346638528859812e+38;

const M_E = math.e;
const M_LOG2E = math.log2e;
const M_LOG10E = math.log10e;
const M_LN2 = math.ln2;
const M_LN10 = math.ln10;
const M_PI = math.pi;
const M_PI_2 = 1.57079632679489661923;
const M_PI_4 = 0.78539816339744830962;
const M_1_PI = 0.31830988618379067154;
const M_2_PI = 0.63661977236758134308;
const M_2_SQRTPI = 1.12837916709551257390;
const M_SQRT2 = math.sqrt2;
const M_SQRT1_2 = math.sqrt1_2;

int signgam = 1;

// ============================================================
// Internal helpers
// ============================================================

const double _DBL_MIN = 2.2250738585072014e-308;

final _f64list = Float64List(1);
final _i64list = _f64list.buffer.asInt64List();

int _doubleBits(double x) {
  _f64list[0] = x;
  return _i64list[0];
}

double _bitsToDouble(int bits) {
  _i64list[0] = bits;
  return _f64list[0];
}

// ============================================================
// Classification
// ============================================================

int fpclassify(double x) {
  if (x.isNaN) return FP_NAN;
  if (x.isInfinite) return FP_INFINITE;
  if (x == 0.0) return FP_ZERO;
  if (x.abs() < _DBL_MIN) return FP_SUBNORMAL;
  return FP_NORMAL;
}

int __fpclassify(double x) => fpclassify(x);
int __fpclassifyf(double x) => fpclassify(x);
int __fpclassifyl(double x) => fpclassify(x);

bool isinf(double x) => x.isInfinite;
bool isnan(double x) => x.isNaN;
bool isfinite(double x) => x.isFinite;
bool isnormal(double x) => fpclassify(x) == FP_NORMAL;

bool signbit(double x) => (_doubleBits(x) >> 63) & 1 != 0;

int __signbit(double x) => signbit(x) ? 1 : 0;
int __signbitf(double x) => __signbit(x);
int __signbitl(double x) => __signbit(x);

bool isunordered(double x, double y) => x.isNaN || y.isNaN;

// ============================================================
// Comparison macros
// ============================================================

bool isless<T extends num>(T x, T y) =>
    !isunordered(x.toDouble(), y.toDouble()) && x < y;
bool islessequal<T extends num>(T x, T y) =>
    !isunordered(x.toDouble(), y.toDouble()) && x <= y;
bool islessgreater<T extends num>(T x, T y) =>
    !isunordered(x.toDouble(), y.toDouble()) && x != y;
bool isgreater<T extends num>(T x, T y) =>
    !isunordered(x.toDouble(), y.toDouble()) && x > y;
bool isgreaterequal<T extends num>(T x, T y) =>
    !isunordered(x.toDouble(), y.toDouble()) && x >= y;

// ============================================================
// Trigonometric functions
// ============================================================

double acos(double x) => math.acos(x);
double acosf(double x) => math.acos(x);
double acosl(double x) => math.acos(x);

double asin(double x) => math.asin(x);
double asinf(double x) => math.asin(x);
double asinl(double x) => math.asin(x);

double atan(double x) => math.atan(x);
double atanf(double x) => math.atan(x);
double atanl(double x) => math.atan(x);

double atan2(double y, double x) => math.atan2(y, x);
double atan2f(double y, double x) => math.atan2(y, x);
double atan2l(double y, double x) => math.atan2(y, x);

double cos(double x) => math.cos(x);
double cosf(double x) => math.cos(x);
double cosl(double x) => math.cos(x);

double sin(double x) => math.sin(x);
double sinf(double x) => math.sin(x);
double sinl(double x) => math.sin(x);

double tan(double x) => math.tan(x);
double tanf(double x) => math.tan(x);
double tanl(double x) => math.tan(x);

// ============================================================
// Hyperbolic functions
// ============================================================

double acosh(double x) => math.log(x + math.sqrt(x * x - 1));
double acoshf(double x) => acosh(x);
double acoshl(double x) => acosh(x);

double asinh(double x) => math.log(x + math.sqrt(x * x + 1));
double asinhf(double x) => asinh(x);
double asinhl(double x) => asinh(x);

double atanh(double x) => 0.5 * math.log((1 + x) / (1 - x));
double atanhf(double x) => atanh(x);
double atanhl(double x) => atanh(x);

double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2;
double coshf(double x) => cosh(x);
double coshl(double x) => cosh(x);

double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2;
double sinhf(double x) => sinh(x);
double sinhl(double x) => sinh(x);

double tanh(double x) {
  if (x > 20) return 1.0;
  if (x < -20) return -1.0;
  double e2x = math.exp(2 * x);
  return (e2x - 1) / (e2x + 1);
}

double tanhf(double x) => tanh(x);
double tanhl(double x) => tanh(x);

// ============================================================
// Exponential and logarithmic
// ============================================================

double exp(double x) => math.exp(x);
double expf(double x) => math.exp(x);
double expl(double x) => math.exp(x);

double exp2(double x) => math.pow(2.0, x).toDouble();
double exp2f(double x) => exp2(x);
double exp2l(double x) => exp2(x);

double expm1(double x) {
  if (x.abs() < 1e-5) return x + 0.5 * x * x;
  return math.exp(x) - 1;
}

double expm1f(double x) => expm1(x);
double expm1l(double x) => expm1(x);

double log(double x) => math.log(x);
double logf(double x) => math.log(x);
double logl(double x) => math.log(x);

double log10(double x) => math.log(x) / math.ln10;
double log10f(double x) => log10(x);
double log10l(double x) => log10(x);

double log1p(double x) {
  if (x.abs() < 1e-4) return x - 0.5 * x * x + x * x * x / 3.0;
  return math.log(1 + x);
}

double log1pf(double x) => log1p(x);
double log1pl(double x) => log1p(x);

double log2(double x) => math.log(x) / math.ln2;
double log2f(double x) => log2(x);
double log2l(double x) => log2(x);

double logb(double x) {
  if (x == 0) return -double.infinity;
  if (x.isInfinite) return double.infinity;
  if (x.isNaN) return double.nan;
  return ilogb(x).toDouble();
}

double logbf(double x) => logb(x);
double logbl(double x) => logb(x);

// ============================================================
// Power functions
// ============================================================

double cbrt(double x) {
  if (x < 0) return -math.pow(-x, 1.0 / 3.0).toDouble();
  return math.pow(x, 1.0 / 3.0).toDouble();
}

double cbrtf(double x) => cbrt(x);
double cbrtl(double x) => cbrt(x);

double pow(double x, double y) => math.pow(x, y).toDouble();
double powf(double x, double y) => pow(x, y);
double powl(double x, double y) => pow(x, y);

double sqrt(double x) => math.sqrt(x);
double sqrtf(double x) => math.sqrt(x);
double sqrtl(double x) => math.sqrt(x);

double hypot(double x, double y) {
  x = x.abs();
  y = y.abs();
  if (x.isInfinite || y.isInfinite) return double.infinity;
  if (x < y) {
    double t = x;
    x = y;
    y = t;
  }
  if (x == 0) return 0.0;
  double r = y / x;
  return x * math.sqrt(1 + r * r);
}

double hypotf(double x, double y) => hypot(x, y);
double hypotl(double x, double y) => hypot(x, y);

// ============================================================
// Rounding
// ============================================================

double ceil(double x) => x.ceilToDouble();
double ceilf(double x) => x.ceilToDouble();
double ceill(double x) => x.ceilToDouble();

double floor(double x) => x.floorToDouble();
double floorf(double x) => x.floorToDouble();
double floorl(double x) => x.floorToDouble();

double round(double x) => x.roundToDouble();
double roundf(double x) => x.roundToDouble();
double roundl(double x) => x.roundToDouble();

double trunc(double x) => x.truncateToDouble();
double truncf(double x) => x.truncateToDouble();
double truncl(double x) => x.truncateToDouble();

double rint(double x) {
  if (x.isNaN || x.isInfinite || x == 0.0) return x;
  const twoTo52 = 4503599627370496.0;
  if (x.abs() >= twoTo52) return x;
  if (x > 0) {
    return (x + twoTo52) - twoTo52;
  } else {
    return (x - twoTo52) + twoTo52;
  }
}

double rintf(double x) => rint(x);
double rintl(double x) => rint(x);

double nearbyint(double x) => rint(x);
double nearbyintf(double x) => rint(x);
double nearbyintl(double x) => rint(x);

int llrint(double x) => rint(x).toInt();
int llrintf(double x) => rint(x).toInt();
int llrintl(double x) => rint(x).toInt();

int llround(double x) => x.round();
int llroundf(double x) => x.round();
int llroundl(double x) => x.round();

int lrint(double x) => rint(x).toInt();
int lrintf(double x) => rint(x).toInt();
int lrintl(double x) => rint(x).toInt();

int lround(double x) => x.round();
int lroundf(double x) => x.round();
int lroundl(double x) => x.round();

// ============================================================
// Absolute value and difference
// ============================================================

double fabs(double x) => x.abs();
double fabsf(double x) => x.abs();
double fabsl(double x) => x.abs();

double fdim(double x, double y) => x > y ? x - y : 0.0;
double fdimf(double x, double y) => fdim(x, y);
double fdiml(double x, double y) => fdim(x, y);

// ============================================================
// FMA, min, max, mod
// ============================================================

double fma(double x, double y, double z) => x * y + z;
double fmaf(double x, double y, double z) => fma(x, y, z);
double fmal(double x, double y, double z) => fma(x, y, z);

double fmax(double x, double y) {
  if (x.isNaN) return y;
  if (y.isNaN) return x;
  return x > y ? x : y;
}

double fmaxf(double x, double y) => fmax(x, y);
double fmaxl(double x, double y) => fmax(x, y);

double fmin(double x, double y) {
  if (x.isNaN) return y;
  if (y.isNaN) return x;
  return x < y ? x : y;
}

double fminf(double x, double y) => fmin(x, y);
double fminl(double x, double y) => fmin(x, y);

double fmod(double x, double y) => x.remainder(y);
double fmodf(double x, double y) => x.remainder(y);
double fmodl(double x, double y) => x.remainder(y);

// ============================================================
// Decomposition functions
// ============================================================

double frexp(double x, List<int> exp) {
  exp[0] = 0;
  if (x == 0.0 || x.isNaN || x.isInfinite) return x;

  bool neg = x < 0;
  x = x.abs();

  int e = 0;
  if (x < _DBL_MIN) {
    x *= 18446744073709551616.0; // 2^64
    e -= 64;
  }

  int bits = _doubleBits(x);
  e += ((bits >> 52) & 0x7FF) - 1022;
  // Set exponent to -1 (biased 1022) -> mantissa in [0.5, 1.0)
  bits = (bits & 0x800FFFFFFFFFFFFF) | (0x3FE << 52);
  x = _bitsToDouble(bits);

  exp[0] = e;
  return neg ? -x : x;
}

double frexpf(double x, List<int> exp) => frexp(x, exp);
double frexpl(double x, List<int> exp) => frexp(x, exp);

double ldexp(double x, int n) => x * math.pow(2.0, n).toDouble();
double ldexpf(double x, int n) => ldexp(x, n);
double ldexpl(double x, int n) => ldexp(x, n);

int ilogb(double x) {
  if (x == 0) return FP_ILOGB0;
  if (x.isNaN) return FP_ILOGBNAN;
  if (x.isInfinite) return 0x7fffffff;
  List<int> e = [0];
  frexp(x, e);
  return e[0] - 1;
}

int ilogbf(double x) => ilogb(x);
int ilogbl(double x) => ilogb(x);

double scalbn(double x, int n) => ldexp(x, n);
double scalbnf(double x, int n) => scalbn(x, n);
double scalbnl(double x, int n) => scalbn(x, n);

double scalbln(double x, int n) => scalbn(x, n);
double scalblnf(double x, int n) => scalbn(x, n);
double scalblnl(double x, int n) => scalbn(x, n);

double modf(double x, List<double> iptr) {
  if (x.isNaN) {
    iptr[0] = double.nan;
    return double.nan;
  }
  if (x.isInfinite) {
    iptr[0] = x;
    return copysign(0.0, x);
  }
  iptr[0] = x.truncateToDouble();
  return x - iptr[0];
}

double modff(double x, List<double> iptr) => modf(x, iptr);
double modfl(double x, List<double> iptr) => modf(x, iptr);

// ============================================================
// NaN
// ============================================================

double nan([String? tag]) => double.nan;
double nanf([String? tag]) => double.nan;
double nanl([String? tag]) => double.nan;

// ============================================================
// copysign, nextafter, nexttoward
// ============================================================

double copysign(double x, double y) {
  int bx = _doubleBits(x);
  int by = _doubleBits(y);
  bx = (bx & 0x7FFFFFFFFFFFFFFF) | (by & ~0x7FFFFFFFFFFFFFFF);
  return _bitsToDouble(bx);
}

double copysignf(double x, double y) => copysign(x, y);
double copysignl(double x, double y) => copysign(x, y);

double nextafter(double x, double y) {
  if (x.isNaN || y.isNaN) return double.nan;
  if (x == y) return y;
  if (x == 0.0) {
    return y > 0 ? 5e-324 : -5e-324;
  }
  int bits = _doubleBits(x);
  if ((x < y) == (x > 0)) {
    bits += 1;
  } else {
    bits -= 1;
  }
  return _bitsToDouble(bits);
}

double nextafterf(double x, double y) => nextafter(x, y);
double nextafterl(double x, double y) => nextafter(x, y);

double nexttoward(double x, double y) => nextafter(x, y);
double nexttowardf(double x, double y) => nextafter(x, y);
double nexttowardl(double x, double y) => nextafter(x, y);

// ============================================================
// remainder, remquo
// ============================================================

double remainder(double x, double y) {
  double n = rint(x / y);
  return x - n * y;
}

double remainderf(double x, double y) => remainder(x, y);
double remainderl(double x, double y) => remainder(x, y);

double remquo(double x, double y, List<int> quo) {
  double n = rint(x / y);
  quo[0] = n.toInt();
  return x - n * y;
}

double remquof(double x, double y, List<int> quo) => remquo(x, y, quo);
double remquol(double x, double y, List<int> quo) => remquo(x, y, quo);

// ============================================================
// Error functions
// ============================================================

double erf(double x) {
  // Abramowitz and Stegun approximation 7.1.26
  double sign = x < 0 ? -1.0 : 1.0;
  x = x.abs();
  const a1 = 0.254829592;
  const a2 = -0.284496736;
  const a3 = 1.421413741;
  const a4 = -1.453152027;
  const a5 = 1.061405429;
  const p = 0.3275911;
  double t = 1.0 / (1.0 + p * x);
  double y = 1.0 -
      (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * math.exp(-x * x);
  return sign * y;
}

double erff(double x) => erf(x);
double erfl(double x) => erf(x);

double erfc(double x) => 1.0 - erf(x);
double erfcf(double x) => erfc(x);
double erfcl(double x) => erfc(x);

// ============================================================
// Gamma functions
// ============================================================

const _lanczos_g = 7;
const _lanczos_c = [
  0.99999999999980993,
  676.5203681218851,
  -1259.1392167224028,
  771.32342877765313,
  -176.61502916214059,
  12.507343278686905,
  -0.13857109526572012,
  9.9843695780195716e-6,
  1.5056327351493116e-7,
];

double tgamma(double x) {
  if (x.isNaN) return double.nan;
  if (x.isInfinite) return x > 0 ? double.infinity : double.nan;
  if (x == 0.0) return signbit(x) ? double.negativeInfinity : double.infinity;
  if (x < 0 && x == x.floorToDouble()) return double.nan;

  if (x < 0.5) {
    return M_PI / (math.sin(M_PI * x) * tgamma(1 - x));
  }

  double z = x - 1;
  double sum = _lanczos_c[0];
  for (int i = 1; i < _lanczos_g + 2; i++) {
    sum += _lanczos_c[i] / (z + i);
  }
  double t = z + _lanczos_g + 0.5;
  return math.sqrt(2 * M_PI) *
      math.pow(t, z + 0.5).toDouble() *
      math.exp(-t) *
      sum;
}

double tgammaf(double x) => tgamma(x);
double tgammal(double x) => tgamma(x);

double lgamma(double x) {
  if (x.isNaN) return double.nan;
  if (x.isInfinite) return double.infinity;
  if (x == 0.0) {
    signgam = signbit(x) ? -1 : 1;
    return double.infinity;
  }
  if (x < 0 && x == x.floorToDouble()) {
    signgam = 1;
    return double.infinity;
  }

  if (x < 0.5) {
    double sinpx = math.sin(M_PI * x);
    signgam = sinpx > 0 ? 1 : -1;
    if (sinpx == 0) return double.infinity;
    return math.log(M_PI / sinpx.abs()) - lgamma(1 - x);
  }

  signgam = 1;
  double z = x - 1;
  double sum = _lanczos_c[0];
  for (int i = 1; i < _lanczos_g + 2; i++) {
    sum += _lanczos_c[i] / (z + i);
  }
  double t = z + _lanczos_g + 0.5;
  return 0.5 * math.log(2 * M_PI) +
      (z + 0.5) * math.log(t) -
      t +
      math.log(sum);
}

double lgammaf(double x) => lgamma(x);
double lgammal(double x) => lgamma(x);

double lgamma_r(double x, List<int> signp) {
  double result = lgamma(x);
  signp[0] = signgam;
  return result;
}

double lgammaf_r(double x, List<int> signp) => lgamma_r(x, signp);
double lgammal_r(double x, List<int> signp) => lgamma_r(x, signp);

// ============================================================
// Bessel functions
// ============================================================

double j0(double x) {
  x = x.abs();
  if (x < 8.0) {
    double sum = 0, term = 1;
    for (int k = 0; k < 60; k++) {
      sum += term;
      term *= -(x * x) / (4.0 * (k + 1) * (k + 1));
      if (term.abs() < 1e-17 * sum.abs() && k > 0) break;
    }
    return sum;
  }
  double theta = x - M_PI_4;
  return math.sqrt(M_2_PI / x) * math.cos(theta);
}

double j0f(double x) => j0(x);

double j1(double x) {
  double sign = x < 0 ? -1.0 : 1.0;
  x = x.abs();
  if (x < 8.0) {
    double sum = 0, term = x / 2.0;
    for (int k = 0; k < 60; k++) {
      sum += term;
      term *= -(x * x) / (4.0 * (k + 1) * (k + 2));
      if (term.abs() < 1e-17 * sum.abs() && k > 0) break;
    }
    return sign * sum;
  }
  double theta = x - 3 * M_PI_4;
  return sign * math.sqrt(M_2_PI / x) * math.cos(theta);
}

double j1f(double x) => j1(x);

double jn(int n, double x) {
  if (n < 0) return (n % 2 == 0 ? 1.0 : -1.0) * jn(-n, x);
  if (n == 0) return j0(x);
  if (n == 1) return j1(x);
  if (x == 0.0) return 0.0;

  if (x.abs() > n.toDouble()) {
    // Forward recurrence stable when |x| > n
    double jPrev = j0(x);
    double jCurr = j1(x);
    for (int k = 1; k < n; k++) {
      double jNext = (2 * k / x) * jCurr - jPrev;
      jPrev = jCurr;
      jCurr = jNext;
    }
    return jCurr;
  } else {
    // Miller's backward recurrence
    int m = n + 20 + (n ~/ 2);
    if (m < 50) m = 50;
    double jPrev = 0.0;
    double jCurr = 1.0;
    double scale = 0.0;
    double result = 0.0;
    for (int k = m; k >= 0; k--) {
      double jNext = (2 * (k + 1) / x) * jCurr - jPrev;
      jPrev = jCurr;
      jCurr = jNext;
      if (k == n) result = jCurr;
      if (k == 0) scale = jCurr;
    }
    return result * j0(x) / scale;
  }
}

double jnf(int n, double x) => jn(n, x);

double y0(double x) {
  if (x <= 0) return x == 0 ? -double.infinity : double.nan;
  if (x < 8.0) {
    const euler = 0.5772156649015329;
    double j0val = j0(x);
    double lnx2 = math.log(x / 2);

    double psum = 0;
    double pk = 1.0;
    double hval = 0;
    for (int k = 1; k < 60; k++) {
      hval += 1.0 / k;
      pk *= -(x * x) / (4.0 * k * k);
      psum += -pk * hval;
      if (pk.abs() * hval < 1e-17 * psum.abs() && k > 5) break;
    }
    return (2 / M_PI) * ((euler + lnx2) * j0val + psum);
  }
  double theta = x - M_PI_4;
  return math.sqrt(M_2_PI / x) * math.sin(theta);
}

double y0f(double x) => y0(x);

double y1(double x) {
  if (x <= 0) return x == 0 ? -double.infinity : double.nan;
  if (x < 8.0) {
    // Use Wronskian: J0*Y1 - J1*Y0 = 2/(pi*x)
    double j0val = j0(x);
    double j1val = j1(x);
    double y0val = y0(x);
    return (2.0 / (M_PI * x) + j1val * y0val) / j0val;
  }
  double theta = x - 3 * M_PI_4;
  return math.sqrt(M_2_PI / x) * math.sin(theta);
}

double y1f(double x) => y1(x);

double yn(int n, double x) {
  if (x <= 0) return x == 0 ? -double.infinity : double.nan;
  if (n < 0) return (n % 2 == 0 ? 1.0 : -1.0) * yn(-n, x);
  if (n == 0) return y0(x);
  if (n == 1) return y1(x);

  // Forward recurrence is stable for Y_n
  double yPrev = y0(x);
  double yCurr = y1(x);
  for (int k = 1; k < n; k++) {
    double yNext = (2 * k / x) * yCurr - yPrev;
    yPrev = yCurr;
    yCurr = yNext;
  }
  return yCurr;
}

double ynf(int n, double x) => yn(n, x);

// ============================================================
// GNU extensions
// ============================================================

void sincos(double x, List<double> sinp, List<double> cosp) {
  sinp[0] = math.sin(x);
  cosp[0] = math.cos(x);
}

void sincosf(double x, List<double> sinp, List<double> cosp) =>
    sincos(x, sinp, cosp);
void sincosl(double x, List<double> sinp, List<double> cosp) =>
    sincos(x, sinp, cosp);

double exp10(double x) => math.pow(10.0, x).toDouble();
double exp10f(double x) => exp10(x);
double exp10l(double x) => exp10(x);

double pow10(double x) => exp10(x);
double pow10f(double x) => exp10(x);
double pow10l(double x) => exp10(x);

double drem(double x, double y) => remainder(x, y);
double dremf(double x, double y) => remainder(x, y);

int finite(double x) => x.isFinite ? 1 : 0;
int finitef(double x) => finite(x);

double scalb(double x, double y) => x * math.pow(2.0, y).toDouble();
double scalbf(double x, double y) => scalb(x, y);

double significand(double x) {
  if (x == 0 || x.isNaN || x.isInfinite) return x;
  return scalbn(x, -ilogb(x));
}

double significandf(double x) => significand(x);
