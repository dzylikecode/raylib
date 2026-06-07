import 'package:vector_math/vector_math.dart';

complex get I => complex(0.0, 1.0);
complex get i => I;

// ignore: camel_case_types
class complex {
  complex(this.real, this.imag);
  double real;
  double imag;

  complex operator +(Object other) {
    final b = _toComplex(other);
    return complex(real + b.real, imag + b.imag);
  }

  complex operator -(Object other) {
    final b = _toComplex(other);
    return complex(real - b.real, imag - b.imag);
  }

  complex operator *(Object other) {
    final b = _toComplex(other);
    return complex(
      real * b.real - imag * b.imag,
      real * b.imag + imag * b.real,
    );
  }

  complex operator /(Object other) {
    final b = _toComplex(other);
    final denom = b.real * b.real + b.imag * b.imag;
    return complex(
      (real * b.real + imag * b.imag) / denom,
      (imag * b.real - real * b.imag) / denom,
    );
  }

  complex get i => this * complex(0.0, 1.0);
  complex get I => i;

  @override
  bool operator ==(Object other) {
    final b = _toComplex(other);
    return real == b.real && imag == b.imag;
  }

  @override
  int get hashCode => Object.hash(real, imag);

  @override
  String toString() => switch ((real, imag)) {
    (0, final im) => '${im}i',
    (final re, 0) => '$re',
    (final re, final im) when im > 0 => '$re + ${im}i',
    (final re, final im) => '$re - ${im.abs()}i',
  };
}

complex _toComplex(Object value) => switch (value) {
  complex c => c,
  num n => n.c,
  _ => throw ArgumentError.value(value, 'value', 'Cannot convert to complex'),
};

extension ComplexNumExt on num {
  complex get i => .new(0.0, toDouble());
  complex get I => i;
  complex get c => .new(toDouble(), 0.0);
}
