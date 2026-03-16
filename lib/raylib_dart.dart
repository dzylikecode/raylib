export 'src/raylib_const.dart';
export 'rcore.dart';
export 'rshapes.dart';
export 'rtextures.dart';
export 'rtext.dart';
export 'rmodels.dart';
export 'raudio.dart';
export 'structs.dart';
export 'colors.dart';

export 'modern.dart';

export 'package:vector_math/vector_math.dart';
export 'package:cdart/cdart.dart' show float;
export 'package:cdart/cdart.dart' show FloatExt;


import 'structs.dart';

@Deprecated('Use Camera3D instead')
typedef Camera = Camera3D;

@Deprecated('Use RenderTexture2D instead')
typedef RenderTexture = RenderTexture2D;
