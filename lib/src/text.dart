// ignore_for_file: non_constant_identifier_names

// Text strings management functions
import 'package:cdart/stdio.dart';


@Deprecated('Use string interpolation instead')
String? TextFormat(String format, List<Object> args) => sprintf(format, args);
@Deprecated('Use .toLowerCase() instead')
String TextToLower(String text) => text.toLowerCase();
@Deprecated('Use .indexOf() instead')
int TextFindIndex(String text, String find) => text.indexOf(find);
