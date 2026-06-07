// ignore_for_file: camel_case_types

typedef float = double;

typedef chars = String;
typedef ints = List<int>;
typedef unsigned = int;

class Ref<T> {
  final List<T> _ref;
  Ref(T value) : _ref = [value];
  T get value => _ref[0];
  set value(T newValue) => _ref[0] = newValue;
}

class chars_view {
  final String _str;
  final int _pos;

  chars_view(this._str, [this._pos = 0]);

  String operator [](int index) => _str[index];
  chars_view operator +(int offset) => chars_view(_str, _pos + offset);
  int operator -(chars_view other) => _pos - other._pos;
  String get current => _str[_pos];
}

class pointer_view<T> {
  List<T> _list;
  int _pos;

  pointer_view(this._list, [this._pos = 0]);

  T get current => _list[_pos];
  set current(T newValue) => _list[_pos] = newValue;

  pointer_view<T> operator +(int offset) =>
      pointer_view<T>(_list, _pos + offset);
  int operator -(pointer_view<T> other) => _pos - other._pos;

  T operator [](int index) => _list[_pos + index];

  pointer_view<T> clone() => pointer_view<T>(_list.sublist(_pos), 0);

  void add(int offset) {
    _pos += offset;
  }

  static void copy<T>(pointer_view<T> dest, pointer_view<T> src) {
    dest._list = src._list.sublist(src._pos);
    dest._pos = 0;
  }
}

extension FloatExt on double {
  float get f => this;
}

extension IntExt on int {
  bool get toBool => this != 0;
  int get U => this;
}

extension OjbectExt on Object? {
  bool get toBool => this != null;
}

extension StringExt on String {
  int operator -(String other) =>
      this[0].codeUnitAt(0) - other[0].codeUnitAt(0);
}
