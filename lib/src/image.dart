import 'package:image/image.dart';
import 'raylib.g.dart' as raylib;

export 'package:image/image.dart' show Image;

// extension ImageToRaylib on Image {
//   raylib.Image toRaylib() => raylib.Image(
//         width: width,
//         height: height,
//         mipmaps: mipmaps,
//         format: format,
//         data: data.toNativeArray(),
//       );
// }