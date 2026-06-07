import 'package:c_proto_parser/c_proto_parser.dart';

void main() {
  final function = parseCFunctionPrototype(
    'void InitWindow(int width, int height, const char *title);',
  );

  print(function.name);
  print(function.returnType);
  print(function.params);
}
