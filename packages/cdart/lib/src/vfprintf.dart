// dart format off
import 'dart:math' as math;

import '../stdarg.dart';
import '../limits.dart';
import '../ctype.dart';
import '../stdio.dart';

import 'stdio_impl.dart';

// ─── Argument types ──────────────────────────────────────────────────────────

sealed class Arg { const Arg(); }

final class ArgInt extends Arg {
  final int i;
  const ArgInt(this.i);
}

final class ArgPtr extends Arg {
  final String p;
  const ArgPtr(this.p);
}

final class ArgDouble extends Arg {
  final double f;
  const ArgDouble(this.f);
}

// ─── Flag constants ───────────────────────────────────────────────────────────

const ALT_FORM = '#';
const ZERO_PAD = '0';
const LEFT_ADJ = '-';
const PAD_POS  = ' ';
const MARK_POS = '+';
const GROUPED  = '\'';
const FLAGMASK = {ALT_FORM, ZERO_PAD, LEFT_ADJ, PAD_POS, MARK_POS, GROUPED};

// ─── ArgType state machine ───────────────────────────────────────────────────

enum ArgType {
  BARE, LPRE, LLPRE, HPRE, HHPRE, BIGLPRE,
  ZTPRE, JPRE,
  STOP,
  PTR, INT, UINT, ULLONG,
  LONG, ULONG,
  SHORT, USHORT, CHAR, UCHAR,
  LLONG, SIZET, IMAX, UMAX, PDIFF, UIPTR,
  DBL, LDBL,
  NOARG,
  MAXSTATE;

  bool get toBool => this != ArgType.BARE;
  bool operator <(ArgType other) => index < other.index;
}

bool _oob(String c) =>
    c.isEmpty ||
    (c.codeUnitAt(0) - 'A'.codeUnitAt(0)) >
        ('z'.codeUnitAt(0) - 'A'.codeUnitAt(0));

const _states = <ArgType, Map<String, ArgType>>{
  ArgType.BARE: {
    'd': ArgType.INT,    'i': ArgType.INT,
    'o': ArgType.UINT,   'u': ArgType.UINT,  'x': ArgType.UINT,  'X': ArgType.UINT,
    'e': ArgType.DBL,    'f': ArgType.DBL,   'g': ArgType.DBL,   'a': ArgType.DBL,
    'E': ArgType.DBL,    'F': ArgType.DBL,   'G': ArgType.DBL,   'A': ArgType.DBL,
    'c': ArgType.INT,    'C': ArgType.UINT,
    's': ArgType.PTR,    'S': ArgType.PTR,   'p': ArgType.UIPTR, 'n': ArgType.PTR,
    'm': ArgType.NOARG,
    'l': ArgType.LPRE,   'h': ArgType.HPRE,  'L': ArgType.BIGLPRE,
    'z': ArgType.ZTPRE,  'j': ArgType.JPRE,  't': ArgType.ZTPRE,
  },
  ArgType.LPRE: {
    'd': ArgType.LONG,   'i': ArgType.LONG,
    'o': ArgType.ULONG,  'u': ArgType.ULONG, 'x': ArgType.ULONG, 'X': ArgType.ULONG,
    'e': ArgType.DBL,    'f': ArgType.DBL,   'g': ArgType.DBL,   'a': ArgType.DBL,
    'E': ArgType.DBL,    'F': ArgType.DBL,   'G': ArgType.DBL,   'A': ArgType.DBL,
    'c': ArgType.UINT,   's': ArgType.PTR,   'n': ArgType.PTR,
    'l': ArgType.LLPRE,
  },
  ArgType.LLPRE: {
    'd': ArgType.LLONG,  'i': ArgType.LLONG,
    'o': ArgType.ULLONG, 'u': ArgType.ULLONG,
    'x': ArgType.ULLONG, 'X': ArgType.ULLONG,
    'n': ArgType.PTR,
  },
  ArgType.HPRE: {
    'd': ArgType.SHORT,  'i': ArgType.SHORT,
    'o': ArgType.USHORT, 'u': ArgType.USHORT, 'x': ArgType.USHORT, 'X': ArgType.USHORT,
    'n': ArgType.PTR,
    'h': ArgType.HHPRE,
  },
  ArgType.HHPRE: {
    'd': ArgType.CHAR,   'i': ArgType.CHAR,
    'o': ArgType.UCHAR,  'u': ArgType.UCHAR,  'x': ArgType.UCHAR,  'X': ArgType.UCHAR,
    'n': ArgType.PTR,
  },
  ArgType.BIGLPRE: {
    'e': ArgType.LDBL,   'f': ArgType.LDBL,   'g': ArgType.LDBL,   'a': ArgType.LDBL,
    'E': ArgType.LDBL,   'F': ArgType.LDBL,   'G': ArgType.LDBL,   'A': ArgType.LDBL,
    'n': ArgType.PTR,
  },
  ArgType.ZTPRE: {
    'd': ArgType.PDIFF,  'i': ArgType.PDIFF,
    'o': ArgType.SIZET,  'u': ArgType.SIZET,
    'x': ArgType.SIZET,  'X': ArgType.SIZET,
    'n': ArgType.PTR,
  },
  ArgType.JPRE: {
    'd': ArgType.IMAX,   'i': ArgType.IMAX,
    'o': ArgType.UMAX,   'u': ArgType.UMAX,
    'x': ArgType.UMAX,   'X': ArgType.UMAX,
    'n': ArgType.PTR,
  },
};

// ─── Low-level output helpers ─────────────────────────────────────────────────

void _out(FILE f, String s) {
  if (!f.hasError) f.write(s);
}

/// Emit the standard padded-field sequence (mirrors musl's pad+out sequence).
/// [prefix] is sign/0x/etc., [digits] is the formatted number body.
/// [p] is the effective precision (>= digits.length after caller adjustment).
int _emitInt(FILE f, String prefix, String digits, int w, int p, Set<String> fl) {
  final pl      = prefix.length;
  final dlen    = digits.length;
  final precPad = p > dlen ? p - dlen : 0; // zeros to reach precision
  final inner   = pl + precPad + dlen;     // total content width

  // Leading spaces (right-align, no zero-pad flag)
  if (!fl.contains(LEFT_ADJ) && !fl.contains(ZERO_PAD) && inner < w) {
    _out(f, ' ' * (w - inner));
  }
  _out(f, prefix);
  // Leading zeros for width (zero-pad flag active)
  if (fl.contains(ZERO_PAD) && !fl.contains(LEFT_ADJ) && inner < w) {
    _out(f, '0' * (w - inner));
  }
  _out(f, '0' * precPad); // precision zeros
  _out(f, digits);
  // Trailing spaces (left-align)
  if (fl.contains(LEFT_ADJ) && inner < w) {
    _out(f, ' ' * (w - inner));
  }
  return math.max(w, inner);
}

// ─── Integer formatters ───────────────────────────────────────────────────────

String _fmtX(int x, bool lower) {
  if (x == 0) return '';
  final digits = lower ? '0123456789abcdef' : '0123456789ABCDEF';
  final buf = <String>[];
  var n = x;
  while (n != 0) { buf.add(digits[n & 0xf]); n = n >>> 4; }
  return buf.reversed.join();
}

String _fmtO(int x) {
  if (x == 0) return '';
  final buf = <String>[];
  var n = x;
  while (n != 0) { buf.add(String.fromCharCode(0x30 + (n & 7))); n = n >>> 3; }
  return buf.reversed.join();
}

String _fmtU(int x) {
  if (x == 0) return '';
  if (x > 0)  return x.toString();
  return BigInt.from(x).toUnsigned(64).toString();
}

// ─── Float formatter ──────────────────────────────────────────────────────────

String _hexFloat(double absY, int prec, bool upper) {
  if (absY == 0.0) {
    if (prec <= 0) return upper ? '0X0P+0' : '0x0p+0';
    return '${upper ? '0X0.' : '0x0.'}${'0' * prec}${upper ? 'P+0' : 'p+0'}';
  }
  if (absY.isInfinite) return upper ? 'INF' : 'inf';
  if (absY.isNaN)      return upper ? 'NAN' : 'nan';
  var e = 0;
  var m = absY;
  while (m >= 2.0) { m /= 2.0; e++; }
  while (m <  1.0) { m *= 2.0; e--; }
  m -= 1.0; // fractional part of normalized mantissa
  final hexDigs = upper ? '0123456789ABCDEF' : '0123456789abcdef';
  final sb = StringBuffer(upper ? '0X1' : '0x1');
  final expSign = e >= 0 ? '+' : '-';
  final expStr  = '${upper ? 'P' : 'p'}$expSign${e.abs()}';

  if (prec < 0) {
    // Auto: emit only as many hex digits as needed (max 13 for double).
    if (m != 0.0) {
      sb.write('.');
      var frac = m;
      for (int i = 0; i < 13 && frac != 0.0; i++) {
        frac *= 16;
        final d = frac.toInt();
        sb.write(hexDigs[d]);
        frac -= d;
      }
    }
  } else {
    sb.write('.');
    var frac = m;
    for (int i = 0; i < prec; i++) {
      frac *= 16;
      final d = frac.toInt();
      sb.write(hexDigs[d]);
      frac -= d;
    }
  }
  sb.write(expStr);
  return sb.toString();
}

// Returns exponent for a double in scientific notation.
int _getExp(double absY) {
  if (absY == 0.0) return 0;
  return int.parse(absY.toStringAsExponential().split('e')[1]);
}

String _sciStr(double absY, int p, bool upper) {
  final raw = absY.toStringAsExponential(p);
  final ei  = raw.indexOf('e');
  final mant = raw.substring(0, ei);
  final expPart = raw.substring(ei + 1);
  final esign   = expPart[0];
  var   enum2   = expPart.substring(1);
  if (enum2.length < 2) enum2 = '0$enum2';
  return '$mant${upper ? 'E' : 'e'}$esign$enum2';
}

int _fmtFp(FILE f, double y, int w, int p, Set<String> fl, String t) {
  final bool isNeg = y < 0 || (y == 0.0 && y.isNegative);
  final double absY = isNeg ? -y : y;

  String signStr;
  if (isNeg)                      signStr = '-';
  else if (fl.contains(MARK_POS)) signStr = '+';
  else if (fl.contains(PAD_POS))  signStr = ' ';
  else                            signStr = '';
  final pl = signStr.length;

  if (!y.isFinite) {
    final s = y.isNaN
        ? (t == t.toUpperCase() ? 'NAN' : 'nan')
        : (t == t.toUpperCase() ? 'INF' : 'inf');
    final noZ = Set<String>.from(fl)..remove(ZERO_PAD);
    final inner = pl + 3;
    if (!noZ.contains(LEFT_ADJ) && inner < w) _out(f, ' ' * (w - inner));
    _out(f, signStr); _out(f, s);
    if (noZ.contains(LEFT_ADJ) && inner < w)  _out(f, ' ' * (w - inner));
    return math.max(w, inner);
  }

  final tl = t.toLowerCase();
  if (p < 0 && tl != 'a') p = 6; // %a uses auto precision (see _hexFloat)
  String body;

  if (tl == 'f') {
    body = absY.toStringAsFixed(p);
    if (fl.contains(ALT_FORM) && !body.contains('.')) body += '.';
  } else if (tl == 'e') {
    body = _sciStr(absY, p, t == 'E');
    if (fl.contains(ALT_FORM)) {
      final ei = body.indexOf(RegExp(r'[eE]'));
      if (!body.substring(0, ei).contains('.'))
        body = '${body.substring(0, ei)}.${body.substring(ei)}';
    }
  } else if (tl == 'g') {
    if (p == 0) p = 1;
    final exp = _getExp(absY);
    if (exp < -4 || exp >= p) {
      var s = _sciStr(absY, p - 1, t == 'G');
      if (!fl.contains(ALT_FORM)) {
        final ei   = s.indexOf(RegExp(r'[eE]'));
        var   mant = s.substring(0, ei);
        final ePart = s.substring(ei);
        if (mant.contains('.')) {
          mant = mant.replaceAll(RegExp(r'0+$'), '');
          if (mant.endsWith('.')) mant = mant.substring(0, mant.length - 1);
        }
        s = mant + ePart;
      }
      body = s;
    } else {
      final fPrec = math.max(0, p - 1 - exp);
      var s = absY.toStringAsFixed(fPrec);
      if (!fl.contains(ALT_FORM)) {
        if (s.contains('.')) {
          s = s.replaceAll(RegExp(r'0+$'), '');
          if (s.endsWith('.')) s = s.substring(0, s.length - 1);
        }
      } else if (!s.contains('.')) {
        s += '.';
      }
      body = s;
    }
  } else { // a / A
    body = _hexFloat(absY, p, t == 'A');
  }

  final inner = pl + body.length;
  if (!fl.contains(LEFT_ADJ) && !fl.contains(ZERO_PAD) && inner < w) _out(f, ' ' * (w - inner));
  _out(f, signStr);
  if (fl.contains(ZERO_PAD) && !fl.contains(LEFT_ADJ) && inner < w)  _out(f, '0' * (w - inner));
  _out(f, body);
  if (fl.contains(LEFT_ADJ) && inner < w) _out(f, ' ' * (w - inner));
  return math.max(w, inner);
}

// ─── pop_arg ──────────────────────────────────────────────────────────────────

Arg _popArg(ArgType type, va_list ap) {
  switch (type) {
    case ArgType.PTR:
      final val = ap.current;
      ap.add(1);
      if (val is String) return ArgPtr(val);
      if (val is int)    return ArgInt(val); // null pointer (0)
      return ArgPtr(val.toString());
    case ArgType.DBL:
    case ArgType.LDBL:
      return ArgDouble(va_arg<double>(ap, double));
    default:
      return ArgInt(va_arg<int>(ap, int));
  }
}

// ─── vfprintf ─────────────────────────────────────────────────────────────────

int vfprintf(FILE f, String fmt, va_list ap) {
  final nl_type = List<ArgType>.filled(NL_ARGMAX + 1, ArgType.BARE);
  final nl_arg  = List<Arg>.filled(NL_ARGMAX + 1, const ArgInt(0));

  // First pass: scan for positional argument types (f == null).
  final ap2 = va_list(<Object>[], 0);
  va_copy(ap2, ap);
  if (printf_core(null, fmt, ap2, nl_arg, nl_type) < 0) return -1;

  // Second pass: actually format.
  final ap3 = va_list(<Object>[], 0);
  va_copy(ap3, ap);
  return printf_core(f, fmt, ap3, nl_arg, nl_type);
}

int printf_core(FILE? f, String fmt, va_list ap,
    List<Arg> nl_arg, List<ArgType> nl_type) {
  int pos   = 0;
  int cnt   = 0;
  int l     = 0;
  bool l10n = false;

  bool atEnd() => pos >= fmt.length;

  for (;;) {
    if (l > INT_MAX - cnt) return -1; // overflow
    cnt += l;
    l = 0;
    if (atEnd()) break;

    // ── 1. Literal text up to next '%' ──────────────────────────────────
    final litStart = pos;
    while (!atEnd() && fmt[pos] != '%') pos++;
    // Collapse '%%' → one '%' in the output range [litStart, litEnd)
    var litEnd = pos;
    while (pos + 1 < fmt.length && fmt[pos] == '%' && fmt[pos + 1] == '%') {
      litEnd++;
      pos += 2;
    }
    l = litEnd - litStart;
    if (f != null) _out(f, fmt.substring(litStart, litEnd));
    if (l > 0) continue;
    if (atEnd()) break;

    // ── 2. Positional index %N$ ──────────────────────────────────────────
    int argpos;
    if (pos + 2 < fmt.length &&
        isdigit(fmt[pos + 1]) &&
        fmt[pos + 2] == '\$') {
      l10n   = true;
      argpos = fmt.codeUnitAt(pos + 1) - 0x30;
      pos   += 3;
    } else {
      argpos = -1;
      pos++;       // skip '%'
    }

    // ── 3. Flags ─────────────────────────────────────────────────────────
    final fl = <String>{};
    while (!atEnd() && FLAGMASK.contains(fmt[pos])) fl.add(fmt[pos++]);

    // ── 4. Field width ───────────────────────────────────────────────────
    int w = 0;
    if (!atEnd() && fmt[pos] == '*') {
      pos++;
      if (!atEnd() &&
          pos + 1 < fmt.length &&
          isdigit(fmt[pos]) &&
          fmt[pos + 1] == '\$') {
        l10n = true;
        final idx = fmt.codeUnitAt(pos) - 0x30;
        if (f == null) { nl_type[idx] = ArgType.INT; w = 0; }
        else w = (nl_arg[idx] as ArgInt).i;
        pos += 2;
      } else if (!l10n) {
        w = (f != null) ? va_arg<int>(ap, int) : 0;
      } else return -1;
      if (w < 0) { fl.add(LEFT_ADJ); w = -w; }
    } else {
      final wStart = pos;
      while (!atEnd() && isdigit(fmt[pos])) pos++;
      if (pos > wStart) w = int.parse(fmt.substring(wStart, pos));
    }

    // ── 5. Precision ─────────────────────────────────────────────────────
    int  p  = -1;
    bool xp = false;
    if (!atEnd() && fmt[pos] == '.') {
      pos++;
      if (!atEnd() && fmt[pos] == '*') {
        pos++;
        if (!atEnd() &&
            pos + 1 < fmt.length &&
            isdigit(fmt[pos]) &&
            fmt[pos + 1] == '\$') {
          final idx = fmt.codeUnitAt(pos) - 0x30;
          if (f == null) { nl_type[idx] = ArgType.INT; p = 0; }
          else p = (nl_arg[idx] as ArgInt).i;
          pos += 2;
        } else if (!l10n) {
          p = (f != null) ? va_arg<int>(ap, int) : 0;
        } else return -1;
        xp = (p >= 0);
      } else {
        final pStart = pos;
        while (!atEnd() && isdigit(fmt[pos])) pos++;
        p  = (pos > pStart) ? int.parse(fmt.substring(pStart, pos)) : 0;
        xp = true;
      }
    }

    // ── 6. Length modifier + conversion specifier (state machine) ────────
    var st = ArgType.BARE;
    var ps = ArgType.BARE;
    do {
      if (atEnd()) return -1;
      final c = fmt[pos];
      if (_oob(c)) return -1;
      ps = st;
      st = _states[st]?[c] ?? ArgType.BARE;
      pos++;
    } while (st < ArgType.STOP);
    if (!st.toBool) return -1;

    // ── 7. Resolve argument ───────────────────────────────────────────────
    Arg arg = const ArgInt(0);
    if (st == ArgType.NOARG) {
      if (argpos >= 0) return -1;
    } else {
      if (argpos >= 0) {
        if (f == null) nl_type[argpos] = st;
        else arg = nl_arg[argpos];
      } else if (f != null) {
        arg = _popArg(st, ap);
      } else {
        return 0;
      }
    }
    if (f == null) continue; // scan-only pass

    if (ferror(f)) return -1;

    String t = fmt[pos - 1];

    // Transform ls→S, lc→C
    if (ps.toBool && (t.codeUnitAt(0) & 15) == 3) {
      t = String.fromCharCode(t.codeUnitAt(0) & ~32);
    }
    if (fl.contains(LEFT_ADJ)) fl.remove(ZERO_PAD);

    // ── 8. Format and emit ────────────────────────────────────────────────
    final int argI = (arg is ArgInt) ? arg.i : 0;

    switch (t) {

      // ── %n ────────────────────────────────────────────────────────────────
      case 'n':
        // %n not supported (security risk); silently skip.
        l = 0; continue;

      // ── %p ────────────────────────────────────────────────────────────────
      case 'p':
        final effP = math.max(p < 0 ? 16 : p, 16);
        final pfx  = (argI != 0) ? '0x' : '';
        if (xp) fl.remove(ZERO_PAD);
        final hex = argI == 0 ? '0' : _fmtX(argI, true);
        l = _emitInt(f, pfx, hex, w, math.max(effP, hex.length), fl);
        break;

      // ── %x / %X ──────────────────────────────────────────────────────────
      case 'x': case 'X':
        final lower = t == 'x';
        final pfx   = (argI != 0 && fl.contains(ALT_FORM))
            ? (lower ? '0x' : '0X') : '';
        if (xp && p < 0) return -1;
        if (xp) fl.remove(ZERO_PAD);
        if (argI == 0 && xp && p == 0) {
          l = _emitInt(f, pfx, '', w, 0, fl);
        } else {
          final hex  = argI == 0 ? '0' : _fmtX(argI, lower);
          final effP = math.max(p, hex.length);
          l = _emitInt(f, pfx, hex, w, effP, fl);
        }
        break;

      // ── %o ────────────────────────────────────────────────────────────────
      case 'o':
        if (xp && p < 0) return -1;
        if (xp) fl.remove(ZERO_PAD);
        if (argI == 0 && xp && p == 0) {
          l = _emitInt(f, '', '', w, 0, fl);
        } else {
          final oct = argI == 0 ? '0' : _fmtO(argI);
          var effP  = math.max(p, oct.length);
          if (fl.contains(ALT_FORM) && effP < oct.length + 1) effP = oct.length + 1;
          l = _emitInt(f, '', oct, w, effP, fl);
        }
        break;

      // ── %d / %i ──────────────────────────────────────────────────────────
      case 'd': case 'i':
        String sign;
        int absVal;
        if (argI < 0) {
          sign   = '-';
          absVal = -argI;
        } else if (fl.contains(MARK_POS)) {
          sign = '+'; absVal = argI;
        } else if (fl.contains(PAD_POS)) {
          sign = ' '; absVal = argI;
        } else {
          sign = ''; absVal = argI;
        }
        if (xp && p < 0) return -1;
        if (xp) fl.remove(ZERO_PAD);
        if (argI == 0 && xp && p == 0) {
          l = _emitInt(f, sign, '', w, 0, fl);
        } else {
          final dec  = absVal == 0 ? '0' : absVal.toString();
          final effP = math.max(p, dec.length);
          l = _emitInt(f, sign, dec, w, effP, fl);
        }
        break;

      // ── %u ────────────────────────────────────────────────────────────────
      case 'u':
        if (xp && p < 0) return -1;
        if (xp) fl.remove(ZERO_PAD);
        if (argI == 0 && xp && p == 0) {
          l = _emitInt(f, '', '', w, 0, fl);
        } else {
          final dec  = argI == 0 ? '0' : _fmtU(argI);
          final effP = math.max(p, dec.length);
          l = _emitInt(f, '', dec, w, effP, fl);
        }
        break;

      // ── %c ────────────────────────────────────────────────────────────────
      case 'c':
        fl.remove(ZERO_PAD);
        final ch = String.fromCharCode(argI & 0xFF);
        l = _emitInt(f, '', ch, w, 1, fl);
        break;

      // ── %C (wide char) ────────────────────────────────────────────────────
      case 'C':
        fl.remove(ZERO_PAD);
        if (argI == 0) {
          l = _emitInt(f, '', '\x00', w, 1, fl);
        } else {
          final wch = String.fromCharCode(argI);
          final inner = wch.length;
          if (!fl.contains(LEFT_ADJ) && inner < w) _out(f, ' ' * (w - inner));
          _out(f, wch);
          if (fl.contains(LEFT_ADJ) && inner < w)  _out(f, ' ' * (w - inner));
          l = math.max(w, inner);
        }
        break;

      // ── %s ────────────────────────────────────────────────────────────────
      case 's':
        final str  = (arg is ArgPtr) ? arg.p
            : (arg is ArgInt && argI == 0) ? '(null)'
            : '(null)';
        final slen = (p >= 0) ? math.min(str.length, p) : str.length;
        fl.remove(ZERO_PAD);
        if (!fl.contains(LEFT_ADJ) && slen < w) _out(f, ' ' * (w - slen));
        _out(f, str.substring(0, slen));
        if (fl.contains(LEFT_ADJ) && slen < w)  _out(f, ' ' * (w - slen));
        l = math.max(w, slen);
        break;

      // ── %S (wide string – same as %s in Dart) ────────────────────────────
      case 'S':
        final str  = (arg is ArgPtr) ? arg.p : '';
        final slen = (p >= 0) ? math.min(str.length, p) : str.length;
        fl.remove(ZERO_PAD);
        if (!fl.contains(LEFT_ADJ) && slen < w) _out(f, ' ' * (w - slen));
        _out(f, str.substring(0, slen));
        if (fl.contains(LEFT_ADJ) && slen < w)  _out(f, ' ' * (w - slen));
        l = math.max(w, slen);
        break;

      // ── %m (strerror – simplified) ────────────────────────────────────────
      case 'm':
        const em = 'Unknown error';
        fl.remove(ZERO_PAD);
        if (!fl.contains(LEFT_ADJ) && em.length < w) _out(f, ' ' * (w - em.length));
        _out(f, em);
        if (fl.contains(LEFT_ADJ) && em.length < w)  _out(f, ' ' * (w - em.length));
        l = math.max(w, em.length);
        break;

      // ── %e %f %g %a (and upper-case variants) ────────────────────────────
      case 'e': case 'E':
      case 'f': case 'F':
      case 'g': case 'G':
      case 'a': case 'A':
        if (xp && p < 0) return -1;
        final fval = (arg is ArgDouble) ? arg.f
            : (arg is ArgInt) ? arg.i.toDouble()
            : 0.0;
        l = _fmtFp(f, fval, w, p, fl, t);
        if (l < 0) return -1;
        break;

      default:
        return -1;
    }
  }

  if (f != null) return cnt;
  if (!l10n)     return 0;

  // Populate nl_arg with positional arguments (in index order).
  int i;
  for (i = 1; i <= NL_ARGMAX && nl_type[i] != ArgType.BARE; i++) {
    nl_arg[i] = _popArg(nl_type[i], ap);
  }
  // Verify no gap exists after the last populated slot.
  for (; i <= NL_ARGMAX && nl_type[i] == ArgType.BARE; i++);
  if (i <= NL_ARGMAX) return -1;
  return 1;
}

// ─── sprintf convenience wrapper ─────────────────────────────────────────────

/// Format [fmt] with [args] and return the result string, or null on error.
String? sprintf(String fmt, List<Object> args) {
  final f  = FILE();
  final ap = va_list(args, 0);
  return vfprintf(f, fmt, ap) < 0 ? null : f.content;
}
