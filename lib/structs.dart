import 'src/raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'package:image/image.dart' as img;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;

extension Vector2Extension on raylib.Vector2 {
  Vector2 toDart() => .new(x, y);
}

extension Vector3Extension on raylib.Vector3 {
  Vector3 toDart() => .new(x, y, z);
}

extension RayExtension on raylib.Ray {
  Ray toDart() => .originDirection(position.toDart(), direction.toDart());
}

extension MatrixExtension on raylib.Matrix {
  Matrix4 toDart() => .new(
    m0,
    m1,
    m2,
    m3,
    m4,
    m5,
    m6,
    m7,
    m8,
    m9,
    m10,
    m11,
    m12,
    m13,
    m14,
    m15,
  );
}

/// raylib.Image → dart Image
///
/// Only uncompressed formats (1, 2, 4, 7) are supported.
/// Throws [UnsupportedError] for compressed or packed formats.
/// The caller is responsible for calling raylib.UnloadImage after this.
extension RaylibImageToDart on raylib.Image {
  img.Image toDart() {
    final n = width * height;
    return switch (format) {
      1 => img.Image.fromBytes( // GRAYSCALE
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n)).buffer,
        numChannels: 1,
      ),
      2 => img.Image.fromBytes( // GRAY_ALPHA
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 2)).buffer,
        numChannels: 2,
      ),
      4 => img.Image.fromBytes( // R8G8B8
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 3)).buffer,
        numChannels: 3,
      ),
      7 => img.Image.fromBytes( // R8G8B8A8
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 4)).buffer,
        numChannels: 4,
        order: img.ChannelOrder.rgba,
      ),
      _ => throw UnsupportedError('PixelFormat $format is not supported for conversion to dart Image'),
    };
  }
}

extension ArenaExt on ffi.Arena {
  Pointer<raylib.Vector2> vector2(Vector2 value) {
    final ptr = this<raylib.Vector2>();
    ptr.ref
      ..x = value.x
      ..y = value.y;
    return ptr;
  }

  Pointer<raylib.Vector2> vector2s(List<Vector2> value) {
    final size = value.length;
    final ptrs = this<raylib.Vector2>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y;
    }
    return ptrs;
  }

  Pointer<raylib.Vector3> vector3(Vector3 value) {
    final ptr = this<raylib.Vector3>();
    ptr.ref
      ..x = value.x
      ..y = value.y
      ..z = value.z;
    return ptr;
  }

  Pointer<raylib.Vector3> vector3s(List<Vector3> value) {
    final size = value.length;
    final ptrs = this<raylib.Vector3>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y
        ..z = value[i].z;
    }
    return ptrs;
  }

  Pointer<raylib.Ray> ray(Ray value) {
    final ptr = this<raylib.Ray>();
    ptr.ref
      ..position.x = value.origin.x
      ..position.y = value.origin.y
      ..position.z = value.origin.z
      ..direction.x = value.direction.x
      ..direction.y = value.direction.y
      ..direction.z = value.direction.z;
    return ptr;
  }

  /// dart Image → native raylib.Image (PIXELFORMAT_UNCOMPRESSED_R8G8B8A8)
  ///
  /// Both the pixel data and the Image struct are arena-managed —
  /// no manual free needed, they are released when the arena is disposed.
  Pointer<raylib.Image> image(img.Image value) {
    final Uint8List bytes;
    if (value.numChannels == 4 && value.format == img.Format.uint8) {
      bytes = value.getBytes(order: img.ChannelOrder.rgba);
    } else {
      bytes = Uint8List(value.width * value.height * 4);
      var i = 0;
      for (final pixel in value) {
        bytes[i++] = (pixel.rNormalized * 255).round();
        bytes[i++] = (pixel.gNormalized * 255).round();
        bytes[i++] = (pixel.bNormalized * 255).round();
        bytes[i++] = (pixel.aNormalized * 255).round();
      }
    }
    final dataPtr = this<Uint8>(bytes.length);
    dataPtr.asTypedList(bytes.length).setAll(0, bytes);
    final ptr = this<raylib.Image>();
    ptr.ref
      ..data = dataPtr.cast()
      ..width = value.width
      ..height = value.height
      ..mipmaps = 1
      ..format = 7; // PIXELFORMAT_UNCOMPRESSED_R8G8B8A8
    return ptr;
  }
}
