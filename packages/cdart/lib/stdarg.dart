import 'base.dart';

typedef va_list = pointer_view<Object>;

void va_copy(va_list dest, va_list src) {
  va_list.copy(dest, src);
}

T va_arg<T>(va_list ap, Type type) {
  final current = ap.current as T;
  ap.add(1);
  return current;
}
