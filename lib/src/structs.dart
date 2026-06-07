// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'raylib.g.dart' as raw;
import 'package:image/image.dart' as img;
import 'raylib_const.dart';

import 'package:vector_math/vector_math.dart'
    show Vector2, Vector3, Vector4, Matrix4, Quaternion, Ray;
export 'package:vector_math/vector_math.dart'
    show Vector2, Vector3, Vector4, Matrix4, Quaternion, Ray;

typedef TraceLogCallback = void Function(LogRecord);

typedef LoadFileDataCallback = Uint8List Function(String);
typedef SaveFileDataCallback = bool Function(String, Uint8List);
typedef LoadFileTextCallback = String Function(String);
typedef SaveFileTextCallback = bool Function(String, String);


typedef Matrix = Matrix4;

@Deprecated('Use Camera3D instead')
typedef Camera = Camera3D;

@Deprecated('Use RenderTexture2D instead')
typedef RenderTexture = RenderTexture2D;

extension Vector2Extension on raw.Vector2 {
  Vector2 toDart() => .new(x, y);
}

extension Vector3Extension on raw.Vector3 {
  Vector3 toDart() => .new(x, y, z);
}

extension Vector4Extension on raw.Vector4 {
  Vector4 toDart() => .new(x, y, z, w);
}

extension MatrixExtension on raw.Matrix {
  // dart format off
  Matrix4 toDart() => .new(
     m0,  m1,  m2,  m3,
     m4,  m5,  m6,  m7,
     m8,  m9, m10, m11,
    m12, m13, m14, m15,
  );
  // dart format on
}

class Color {
  static final _finalizer = Finalizer<Pointer<raw.Color>>(ffi.malloc.free);
  final Pointer<raw.Color> ptr;
  bool _disposed = false;

  Color._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Color({int r = 0, int g = 0, int b = 0, int a = 255}) =>
      Color._(ffi.malloc<raw.Color>())
        ..r = r
        ..g = g
        ..b = b
        ..a = a;
  factory Color.fromRGBA(int r, int g, int b, int a) =>
      Color(r: r, g: g, b: b, a: a);

  int get r => ptr.ref.r;
  set r(int value) => ptr.ref.r = value;

  int get g => ptr.ref.g;
  set g(int value) => ptr.ref.g = value;

  int get b => ptr.ref.b;
  set b(int value) => ptr.ref.b = value;

  int get a => ptr.ref.a;
  set a(int value) => ptr.ref.a = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this); // 取消自动释放
    ffi.malloc.free(ptr);
    _disposed = true;
  }

  static final lightGray = Color(r: 200, g: 200, b: 200, a: 255);
  static final gray = Color(r: 130, g: 130, b: 130, a: 255);
  static final darkGray = Color(r: 80, g: 80, b: 80, a: 255);
  static final yellow = Color(r: 253, g: 249, b: 0, a: 255);
  static final gold = Color(r: 255, g: 203, b: 0, a: 255);
  static final orange = Color(r: 255, g: 161, b: 0, a: 255);
  static final pink = Color(r: 255, g: 109, b: 194, a: 255);
  static final red = Color(r: 230, g: 41, b: 55, a: 255);
  static final maroon = Color(r: 190, g: 33, b: 55, a: 255);
  static final green = Color(r: 0, g: 228, b: 48, a: 255);
  static final lime = Color(r: 0, g: 158, b: 47, a: 255);
  static final darkGreen = Color(r: 0, g: 117, b: 44, a: 255);
  static final skyBlue = Color(r: 102, g: 191, b: 255, a: 255);
  static final blue = Color(r: 0, g: 121, b: 241, a: 255);
  static final darkBlue = Color(r: 0, g: 82, b: 172, a: 255);
  static final purple = Color(r: 200, g: 122, b: 255, a: 255);
  static final violet = Color(r: 135, g: 60, b: 190, a: 255);
  static final darkPurple = Color(r: 112, g: 31, b: 126, a: 255);
  static final beige = Color(r: 211, g: 176, b: 131, a: 255);
  static final brown = Color(r: 127, g: 106, b: 79, a: 255);
  static final darkBrown = Color(r: 76, g: 63, b: 47, a: 255);
  static final white = Color(r: 255, g: 255, b: 255, a: 255);
  static final black = Color(r: 0, g: 0, b: 0, a: 255);
  static final blank = Color(r: 0, g: 0, b: 0, a: 0);
  static final magenta = Color(r: 255, g: 0, b: 255, a: 255);
  static final rayWhite = Color(r: 245, g: 245, b: 245, a: 255);

  @override
  String toString() => 'r: $r, g: $g, b: $b, a: $a';
}

Color Fade(Color color, double alpha) {
  final c = raw.Fade(color.ptr.ref, alpha);
  return .fromRGBA(c.r, c.g, c.b, c.a);
}

@Deprecated('Use .lightGray instead')
final Color LIGHTGRAY = .lightGray;
@Deprecated('Use .gray instead')
final Color GRAY = .gray;
@Deprecated('Use .darkGray instead')
final Color DARKGRAY = .darkGray;
@Deprecated('Use .yellow instead')
final Color YELLOW = .yellow;
@Deprecated('Use .gold instead')
final Color GOLD = .gold;
@Deprecated('Use .orange instead')
final Color ORANGE = .orange;
@Deprecated('Use .pink instead')
final Color PINK = .pink;
@Deprecated('Use .red instead')
final Color RED = .red;
@Deprecated('Use .maroon instead')
final Color MAROON = .maroon;
@Deprecated('Use .green instead')
final Color GREEN = .green;
@Deprecated('Use .lime instead')
final Color LIME = .lime;
@Deprecated('Use .darkGreen instead')
final Color DARKGREEN = .darkGreen;
@Deprecated('Use .skyBlue instead')
final Color SKYBLUE = .skyBlue;
@Deprecated('Use .blue instead')
final Color BLUE = .blue;
@Deprecated('Use .darkBlue instead')
final Color DARKBLUE = .darkBlue;
@Deprecated('Use .purple instead')
final Color PURPLE = .purple;
@Deprecated('Use .violet instead')
final Color VIOLET = .violet;
@Deprecated('Use .darkPurple instead')
final Color DARKPURPLE = .darkPurple;
@Deprecated('Use .beige instead')
final Color BEIGE = .beige;
@Deprecated('Use .brown instead')
final Color BROWN = .brown;
@Deprecated('Use .darkBrown instead')
final Color DARKBROWN = .darkBrown;
@Deprecated('Use .white instead')
final Color WHITE = .white;
@Deprecated('Use .black instead')
final Color BLACK = .black;
@Deprecated('Use .blank instead')
final Color BLANK = .blank;
@Deprecated('Use .magenta instead')
final Color MAGENTA = .magenta;
@Deprecated('Use .rayWhite instead')
final Color RAYWHITE = .rayWhite;

class Rectangle {
  final Pointer<raw.Rectangle> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Rectangle>>(ffi.malloc.free);

  Rectangle._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Rectangle.zero() => Rectangle();

  factory Rectangle({
    double x = 0,
    double y = 0,
    double width = 0,
    double height = 0,
  }) => ._(ffi.malloc<raw.Rectangle>())
    ..x = x
    ..y = y
    ..width = width
    ..height = height;

  factory Rectangle.fromLTWH(
    double left,
    double top,
    double width,
    double height,
  ) => Rectangle(x: left, y: top, width: width, height: height);

  double get x => ptr.ref.x;
  set x(double value) => ptr.ref.x = value;

  double get y => ptr.ref.y;
  set y(double value) => ptr.ref.y = value;

  double get width => ptr.ref.width;
  set width(double value) => ptr.ref.width = value;

  double get height => ptr.ref.height;
  set height(double value) => ptr.ref.height = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    ffi.malloc.free(ptr);
    _disposed = true;
  }

  @override
  String toString() => 'x: $x, y: $y, width: $width, height: $height';
}

extension RectangleExt on raw.Rectangle {
  Rectangle toDart() => .new(x: x, y: y, width: width, height: height);
}

class Image {
  final Pointer<raw.Image> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Image>>(_free);
  static void _free(Pointer<raw.Image> ptr) {
    raw.UnloadImage(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Image._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get width => ptr.ref.width;
  int get height => ptr.ref.height;
  int get mipmaps => ptr.ref.mipmaps;
  PixelFormat get format => .fromValue(ptr.ref.format);

  /// Convert to `package:image` Image for Dart-side pixel manipulation.
  ///
  /// Only uncompressed formats (grayscale/grayAlpha/R8G8B8/R8G8B8A8) are
  /// supported. Throws [UnsupportedError] for others.
  img.Image toDart() {
    final n = width * height;
    final ref = ptr.ref;
    final fmt = PixelFormat.fromValue(ref.format);
    return switch (fmt) {
      .uncompressedGrayscale => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(ref.data.cast<Uint8>().asTypedList(n)).buffer,
        numChannels: 1,
      ),
      .uncompressedGrayAlpha => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(
          ref.data.cast<Uint8>().asTypedList(n * 2),
        ).buffer,
        numChannels: 2,
      ),
      .uncompressedR8g8b8 => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(
          ref.data.cast<Uint8>().asTypedList(n * 3),
        ).buffer,
        numChannels: 3,
      ),
      .uncompressedR8g8b8a8 => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(
          ref.data.cast<Uint8>().asTypedList(n * 4),
        ).buffer,
        numChannels: 4,
        order: img.ChannelOrder.rgba,
      ),
      _ => throw UnsupportedError(
        'PixelFormat ${ref.format} is not supported for conversion to dart Image',
      ),
    };
  }

  /// Create an [Image] from a `package:image` Image.
  factory Image.fromImage(img.Image value) {
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
    final dataPtr = ffi.malloc<Uint8>(bytes.length);
    dataPtr.asTypedList(bytes.length).setAll(0, bytes);
    final ptr = ffi.malloc<raw.Image>();
    ptr.ref
      ..data = dataPtr.cast()
      ..width = value.width
      ..height = value.height
      ..mipmaps = 1
      ..format = PixelFormat.uncompressedR8g8b8a8.value;
    return Image._(ptr);
  }

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibImageToDart on raw.Image {
  Image toDart() {
    final p = ffi.malloc<raw.Image>();
    p.ref
      ..data = data
      ..width = width
      ..height = height
      ..mipmaps = mipmaps
      ..format = format;
    return ._(p);
  }
}

class Texture {
  final int id;
  final int width;
  final int height;
  final int mipmaps;
  final PixelFormat format;

  const Texture({
    required this.id,
    required this.width,
    required this.height,
    this.mipmaps = 1,
    required this.format,
  });

  @override
  bool operator ==(Object other) => other is Texture && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

typedef Texture2D = Texture;
typedef TextureCubemap = Texture;

extension RaylibTextureToDart on raw.Texture {
  Texture toDart() => Texture(
    id: id,
    width: width,
    height: height,
    mipmaps: mipmaps,
    format: .fromValue(format),
  );
}

class RenderTexture2D {
  final int id;
  final Texture texture;
  final Texture depth;

  const RenderTexture2D({
    required this.id,
    required this.texture,
    required this.depth,
  });

  @override
  bool operator ==(Object other) => other is RenderTexture2D && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

extension RaylibRenderTextureToDart on raw.RenderTexture {
  RenderTexture2D toDart() =>
      RenderTexture2D(id: id, texture: texture.toDart(), depth: depth.toDart());
}

class NPatchInfo {
  final Rectangle source;
  final int left;
  final int top;
  final int right;
  final int bottom;
  final PixelFormat layout;

  NPatchInfo({
    required this.source,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.layout,
  });
}

extension RaylibNPatchInfoToDart on raw.NPatchInfo {
  NPatchInfo toDart() => NPatchInfo(
    source: source.toDart(),
    left: left,
    top: top,
    right: right,
    bottom: bottom,
    layout: .fromValue(layout),
  );
}

@immutable
class GlyphInfo {
  /// Unicode codepoint.
  final int value;
  final int offsetX;
  final int offsetY;
  final int advanceX;

  const GlyphInfo({
    required this.value,
    required this.offsetX,
    required this.offsetY,
    required this.advanceX,
  });
}

extension RaylibGlyphInfoToDart on raw.GlyphInfo {
  GlyphInfo toDart() => GlyphInfo(
    value: value,
    offsetX: offsetX,
    offsetY: offsetY,
    advanceX: advanceX,
  );
}

class Font {
  final Pointer<raw.Font> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Font>>(_free);
  static void _free(Pointer<raw.Font> ptr) {
    raw.UnloadFont(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Font._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get baseSize => ptr.ref.baseSize;
  int get glyphCount => ptr.ref.glyphCount;
  int get glyphPadding => ptr.ref.glyphPadding;
  Texture get texture => ptr.ref.texture.toDart();

  GlyphInfo glyphInfo(int index) {
    final g = ptr.ref.glyphs[index];
    return GlyphInfo(
      value: g.value,
      offsetX: g.offsetX,
      offsetY: g.offsetY,
      advanceX: g.advanceX,
    );
  }

  Rectangle glyphRect(int index) => ptr.ref.recs[index].toDart();

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibFontToDart on raw.Font {
  Font toDart() {
    final p = ffi.malloc<raw.Font>();
    p.ref
      ..baseSize = baseSize
      ..glyphCount = glyphCount
      ..glyphPadding = glyphPadding
      ..texture.id = texture.id
      ..texture.width = texture.width
      ..texture.height = texture.height
      ..texture.mipmaps = texture.mipmaps
      ..texture.format = texture.format
      ..recs = recs
      ..glyphs = glyphs;
    return Font._(p);
  }
}

class Camera2D {
  final Pointer<raw.Camera2D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Camera2D>>(_free);
  static void _free(Pointer<raw.Camera2D> ptr) => ffi.malloc.free(ptr);

  Camera2D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera2D({
    Vector2? offset,
    Vector2? target,
    double rotation = 0.0,
    double zoom = 1.0,
  }) {
    final pointer = ffi.malloc<raw.Camera2D>();
    return Camera2D._(pointer)
      ..offset = offset ?? .zero()
      ..target = target ?? .zero()
      ..rotation = rotation
      ..zoom = zoom;
  }

  Vector2 get offset => ptr.ref.offset.toDart();
  set offset(Vector2 value) {
    ptr.ref.offset.x = value.x;
    ptr.ref.offset.y = value.y;
  }

  Vector2 get target => ptr.ref.target.toDart();
  set target(Vector2 value) {
    ptr.ref.target.x = value.x;
    ptr.ref.target.y = value.y;
  }

  double get rotation => ptr.ref.rotation;
  set rotation(double value) => ptr.ref.rotation = value;

  double get zoom => ptr.ref.zoom;
  set zoom(double value) => ptr.ref.zoom = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

class Camera3D {
  final Pointer<raw.Camera3D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Camera3D>>(_free);
  static void _free(Pointer<raw.Camera3D> ptr) => ffi.malloc.free(ptr);

  Camera3D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera3D({
    Vector3? position,
    Vector3? target,
    Vector3? up,
    double fovy = 45.0,
    CameraProjection projection = .perspective,
  }) {
    final pointer = ffi.malloc<raw.Camera3D>();
    return Camera3D._(pointer)
      ..position = position ?? .zero()
      ..target = target ?? .zero()
      ..up = up ?? Vector3(0, 1, 0)
      ..fovy = fovy
      ..projection = projection;
  }

  Vector3 get position => ptr.ref.position.toDart();
  set position(Vector3 value) {
    ptr.ref.position.x = value.x;
    ptr.ref.position.y = value.y;
    ptr.ref.position.z = value.z;
  }

  Vector3 get target => ptr.ref.target.toDart();
  set target(Vector3 value) {
    ptr.ref.target.x = value.x;
    ptr.ref.target.y = value.y;
    ptr.ref.target.z = value.z;
  }

  Vector3 get up => ptr.ref.up.toDart();
  set up(Vector3 value) {
    ptr.ref.up.x = value.x;
    ptr.ref.up.y = value.y;
    ptr.ref.up.z = value.z;
  }

  double get fovy => ptr.ref.fovy;
  set fovy(double value) => ptr.ref.fovy = value;

  CameraProjection get projection => .fromValue(ptr.ref.projection);
  set projection(CameraProjection value) => ptr.ref.projection = value.value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

class Mesh {
  static const _maxMeshVertexBuffers = 7;

  final Pointer<raw.Mesh> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Mesh>>(_free);
  static void _free(Pointer<raw.Mesh> ptr) {
    raw.UnloadMesh(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Mesh._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get vertexCount => ptr.ref.vertexCount;
  int get triangleCount => ptr.ref.triangleCount;

  static List<Vector2> _vector2List(Float32List values) => [
    for (var i = 0; i < values.length; i += 2)
      Vector2(values[i], values[i + 1]),
  ];

  static List<Vector3> _vector3List(Float32List values) => [
    for (var i = 0; i < values.length; i += 3)
      Vector3(values[i], values[i + 1], values[i + 2]),
  ];

  static List<Vector4> _vector4List(Float32List values) => [
    for (var i = 0; i < values.length; i += 4)
      Vector4(values[i], values[i + 1], values[i + 2], values[i + 3]),
  ];

  static List<Color> _colorList(Uint8List values) => [
    for (var i = 0; i < values.length; i += 4)
      Color.fromRGBA(values[i], values[i + 1], values[i + 2], values[i + 3]),
  ];

  static List<(int, int, int)> _triangleList(Uint16List values) => [
    for (var i = 0; i < values.length; i += 3)
      (values[i], values[i + 1], values[i + 2]),
  ];

  static List<(int, int, int, int)> _quadList(Uint8List values) => [
    for (var i = 0; i < values.length; i += 4)
      (values[i], values[i + 1], values[i + 2], values[i + 3]),
  ];

  /// Raw XYZ vertex position buffer; length = vertexCount × 3.
  Float32List get vertexBuffer => ptr.ref.vertices == nullptr
      ? Float32List(0)
      : ptr.ref.vertices.asTypedList(vertexCount * 3);

  /// XYZ vertex positions.
  List<Vector3> get vertices => _vector3List(vertexBuffer);

  /// Raw UV texture coordinate buffer; length = vertexCount × 2.
  Float32List get texcoordBuffer => ptr.ref.texcoords == nullptr
      ? Float32List(0)
      : ptr.ref.texcoords.asTypedList(vertexCount * 2);

  /// UV texture coordinates.
  List<Vector2> get texcoords => _vector2List(texcoordBuffer);

  /// Raw secondary UV coordinate buffer; length = vertexCount × 2.
  Float32List get texcoord2Buffer => ptr.ref.texcoords2 == nullptr
      ? Float32List(0)
      : ptr.ref.texcoords2.asTypedList(vertexCount * 2);

  /// Secondary UV coords.
  List<Vector2> get texcoords2 => _vector2List(texcoord2Buffer);

  /// Raw XYZ normal buffer; length = vertexCount × 3.
  Float32List get normalBuffer => ptr.ref.normals == nullptr
      ? Float32List(0)
      : ptr.ref.normals.asTypedList(vertexCount * 3);

  /// XYZ normals.
  List<Vector3> get normals => _vector3List(normalBuffer);

  /// Raw XYZW tangent buffer; length = vertexCount × 4.
  Float32List get tangentBuffer => ptr.ref.tangents == nullptr
      ? Float32List(0)
      : ptr.ref.tangents.asTypedList(vertexCount * 4);

  /// XYZW tangents.
  List<Vector4> get tangents => _vector4List(tangentBuffer);

  /// Raw RGBA vertex color buffer; length = vertexCount × 4.
  Uint8List get colorBuffer => ptr.ref.colors == nullptr
      ? Uint8List(0)
      : ptr.ref.colors.cast<Uint8>().asTypedList(vertexCount * 4);

  /// RGBA vertex colors.
  List<Color> get colors => _colorList(colorBuffer);

  /// Raw triangle index buffer; length = triangleCount × 3.
  Uint16List get indexBuffer => ptr.ref.indices == nullptr
      ? Uint16List(0)
      : ptr.ref.indices.cast<Uint16>().asTypedList(triangleCount * 3);

  /// Triangle vertex indices.
  List<(int, int, int)> get indices => _triangleList(indexBuffer);

  int get boneCount => ptr.ref.boneCount;

  /// Raw vertex bone index buffer; length = vertexCount × 4.
  Uint8List get boneIndexBuffer => ptr.ref.boneIndices == nullptr
      ? Uint8List(0)
      : ptr.ref.boneIndices.cast<Uint8>().asTypedList(vertexCount * 4);

  /// Vertex bone indices.
  List<(int, int, int, int)> get boneIndices => _quadList(boneIndexBuffer);

  /// Raw vertex bone weight buffer; length = vertexCount × 4.
  Float32List get boneWeightBuffer => ptr.ref.boneWeights == nullptr
      ? Float32List(0)
      : ptr.ref.boneWeights.asTypedList(vertexCount * 4);

  /// Vertex bone weights.
  List<Vector4> get boneWeights => _vector4List(boneWeightBuffer);

  /// Raw animated XYZ vertex position buffer; length = vertexCount × 3.
  Float32List get animVertexBuffer => ptr.ref.animVertices == nullptr
      ? Float32List(0)
      : ptr.ref.animVertices.asTypedList(vertexCount * 3);

  /// Animated XYZ vertex positions.
  List<Vector3> get animVertices => _vector3List(animVertexBuffer);

  /// Raw animated XYZ normal buffer; length = vertexCount × 3.
  Float32List get animNormalBuffer => ptr.ref.animNormals == nullptr
      ? Float32List(0)
      : ptr.ref.animNormals.asTypedList(vertexCount * 3);

  /// Animated XYZ normals.
  List<Vector3> get animNormals => _vector3List(animNormalBuffer);

  /// OpenGL VAO id (0 if not uploaded).
  int get vaoId => ptr.ref.vaoId;

  /// OpenGL VBO ids.
  Uint32List get vboId => ptr.ref.vboId == nullptr
      ? Uint32List(0)
      : ptr.ref.vboId.cast<Uint32>().asTypedList(_maxMeshVertexBuffers);

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibMeshToDart on raw.Mesh {
  Mesh toDart() {
    final p = ffi.malloc<raw.Mesh>();
    p.ref
      ..vertexCount = vertexCount
      ..triangleCount = triangleCount
      ..vertices = vertices
      ..texcoords = texcoords
      ..texcoords2 = texcoords2
      ..normals = normals
      ..tangents = tangents
      ..colors = colors
      ..indices = indices
      ..animVertices = animVertices
      ..animNormals = animNormals
      ..boneIndices = boneIndices
      ..boneWeights = boneWeights
      ..boneCount = boneCount
      ..vaoId = vaoId
      ..vboId = vboId;
    return ._(p);
  }
}

class Shader {
  final Pointer<raw.Shader> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Shader>>(_free);
  static void _free(Pointer<raw.Shader> ptr) {
    raw.UnloadShader(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Shader._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get id => ptr.ref.id;

  @override
  bool operator ==(Object other) => other is Shader && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibShaderToDart on raw.Shader {
  Shader toDart() {
    final p = ffi.malloc<raw.Shader>();
    p.ref
      ..id = id
      ..locs = locs;
    return ._(p);
  }
}

@immutable
class MaterialMap {
  final Texture texture;
  final int colorR;
  final int colorG;
  final int colorB;
  final int colorA;
  final double value;

  const MaterialMap({
    required this.texture,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.colorA,
    required this.value,
  });
}

extension RaylibMaterialMapToDart on raw.MaterialMap {
  MaterialMap toDart() => MaterialMap(
    texture: texture.toDart(),
    colorR: color.r,
    colorG: color.g,
    colorB: color.b,
    colorA: color.a,
    value: value,
  );
}

class Material {
  final Pointer<raw.Material> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Material>>(_free);
  static void _free(Pointer<raw.Material> ptr) {
    raw.UnloadMaterial(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Material._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  MaterialMap operator [](int index) => ptr.ref.maps[index].toDart();

  (double, double, double, double) get params => (
    ptr.ref.params[0],
    ptr.ref.params[1],
    ptr.ref.params[2],
    ptr.ref.params[3],
  );

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibMaterialToDart on raw.Material {
  Material toDart() {
    final p = ffi.malloc<raw.Material>();
    p.ref.shader
      ..id = shader.id
      ..locs = shader.locs;
    p.ref.maps = maps;
    for (var i = 0; i < 4; i++) {
      p.ref.params[i] = params[i];
    }
    return ._(p);
  }
}

@immutable
class Transform {
  final Vector3 translation;

  /// Rotation quaternion (x, y, z, w).
  final Quaternion rotation;

  final Vector3 scale;

  const Transform({
    required this.translation,
    required this.rotation,
    required this.scale,
  });
}

extension TransformExt on raw.Transform {
  Transform toDart() => Transform(
    translation: translation.toDart(),
    rotation: Quaternion(rotation.x, rotation.y, rotation.z, rotation.w),
    scale: scale.toDart(),
  );
}

@immutable
class BoneInfo {
  final String name;

  /// Index of the parent bone (-1 for root).
  final int parent;

  const BoneInfo({required this.name, required this.parent});
}

extension BoneInfoExt on raw.BoneInfo {
  BoneInfo toDart() {
    final sb = StringBuffer();
    for (var i = 0; i < 32; i++) {
      final c = name[i];
      if (c == 0) break;
      sb.writeCharCode(c);
    }
    return BoneInfo(name: sb.toString(), parent: parent);
  }
}

@immutable
class ModelSkeleton {
  final int boneCount;
  final List<BoneInfo> bones;
  final List<Transform> bindPose;

  const ModelSkeleton({
    required this.boneCount,
    required this.bones,
    required this.bindPose,
  });
}

extension ModelSkeletonExt on raw.ModelSkeleton {
  ModelSkeleton toDart() => ModelSkeleton(
    boneCount: boneCount,
    bones: bones == nullptr
        ? []
        : [for (var i = 0; i < boneCount; i++) bones[i].toDart()],
    bindPose: bindPose == nullptr
        ? []
        : [for (var i = 0; i < boneCount; i++) bindPose[i].toDart()],
  );
}

class Model {
  final Pointer<raw.Model> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Model>>(_free);
  static void _free(Pointer<raw.Model> ptr) {
    raw.UnloadModel(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Model._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  Matrix4 get transform => ptr.ref.transform.toDart();
  set transform(Matrix4 value) => _copyMatrix4(ptr.ref.transform, value);

  int get meshCount => ptr.ref.meshCount;
  int get materialCount => ptr.ref.materialCount;
  int get boneCount => ptr.ref.skeleton.boneCount;
  ModelSkeleton get skeleton => ptr.ref.skeleton.toDart();

  List<Transform> get currentPose => ptr.ref.currentPose == nullptr
      ? []
      : [for (var i = 0; i < boneCount; i++) ptr.ref.currentPose[i].toDart()];

  List<Matrix4> get boneMatrices => ptr.ref.boneMatrices == nullptr
      ? []
      : [for (var i = 0; i < boneCount; i++) ptr.ref.boneMatrices[i].toDart()];

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibModelToDart on raw.Model {
  Model toDart() {
    final p = ffi.malloc<raw.Model>();
    _copyMatrix(p.ref.transform, transform);
    p.ref
      ..meshCount = meshCount
      ..materialCount = materialCount
      ..meshes = meshes
      ..materials = materials
      ..meshMaterial = meshMaterial
      ..currentPose = currentPose
      ..boneMatrices = boneMatrices;
    p.ref.skeleton
      ..boneCount = skeleton.boneCount
      ..bones = skeleton.bones
      ..bindPose = skeleton.bindPose;
    return Model._(p);
  }
}

typedef ModelAnimPose = List<Transform>;

class ModelAnimation {
  final String name;
  final int boneCount;
  final int keyframeCount;
  final List<ModelAnimPose> keyframePoses;

  const ModelAnimation({
    required this.name,
    required this.boneCount,
    required this.keyframeCount,
    required this.keyframePoses,
  });
}

extension RaylibModelAnimationToDart on raw.ModelAnimation {
  ModelAnimation toDart() {
    final p = ffi.malloc<raw.ModelAnimation>();
    final namePtr = p.ref.name;
    return ModelAnimation(
      name: utf8.decode(
        Uint8List.fromList([
          for (int index = 0; namePtr[index] != 0 && index < 32; index++)
            namePtr[index],
        ]),
      ),
      boneCount: boneCount,
      keyframeCount: keyframeCount,
      keyframePoses: keyframePoses == nullptr
          ? []
          : [
              for (var i = 0; i < keyframeCount; i++)
                [
                  for (var j = 0; j < boneCount; j++)
                    keyframePoses[i][j].toDart(),
                ],
            ],
    );
  }
}

extension RayExtension on raw.Ray {
  Ray toDart() => .originDirection(position.toDart(), direction.toDart());
}

@immutable
class RayCollision {
  final bool hit;
  final double distance;
  final Vector3 point;
  final Vector3 normal;

  const RayCollision({
    required this.hit,
    required this.distance,
    required this.point,
    required this.normal,
  });
}

extension RayCollisionExt on raw.RayCollision {
  RayCollision toDart() => RayCollision(
    hit: hit,
    distance: distance,
    point: point.toDart(),
    normal: normal.toDart(),
  );
}

@immutable
class BoundingBox {
  final Vector3 min;
  final Vector3 max;

  const BoundingBox({required this.min, required this.max});
}

extension BoundingBoxExt on raw.BoundingBox {
  BoundingBox toDart() => BoundingBox(min: min.toDart(), max: max.toDart());
}

class Wave {
  final Pointer<raw.Wave> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Wave>>(_free);
  static void _free(Pointer<raw.Wave> ptr) {
    raw.UnloadWave(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Wave._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get frameCount => ptr.ref.frameCount;
  int get sampleRate => ptr.ref.sampleRate;
  int get sampleSize => ptr.ref.sampleSize;
  int get channels => ptr.ref.channels;

  /// Raw PCM sample bytes.
  /// Size = frameCount × channels × (sampleSize ÷ 8).
  Uint8List get data {
    final byteSize = frameCount * channels * (sampleSize ~/ 8);
    return ptr.ref.data.cast<Uint8>().asTypedList(byteSize);
  }

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibWaveToDart on raw.Wave {
  Wave toDart() {
    final p = ffi.malloc<raw.Wave>();
    p.ref
      ..frameCount = frameCount
      ..sampleRate = sampleRate
      ..sampleSize = sampleSize
      ..channels = channels
      ..data = data;
    return Wave._(p);
  }
}

class AudioStream {
  final Pointer<raw.AudioStream> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.AudioStream>>(_free);
  static void _free(Pointer<raw.AudioStream> ptr) {
    raw.UnloadAudioStream(ptr.ref);
    ffi.malloc.free(ptr);
  }

  AudioStream._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get sampleRate => ptr.ref.sampleRate;
  int get sampleSize => ptr.ref.sampleSize;
  int get channels => ptr.ref.channels;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibAudioStreamToDart on raw.AudioStream {
  AudioStream toDart() {
    final p = ffi.malloc<raw.AudioStream>();
    p.ref
      ..buffer = buffer
      ..processor = processor
      ..sampleRate = sampleRate
      ..sampleSize = sampleSize
      ..channels = channels;
    return AudioStream._(p);
  }
}

class Sound {
  final Pointer<raw.Sound> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Sound>>(_free);
  static void _free(Pointer<raw.Sound> ptr) {
    raw.UnloadSound(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Sound._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get frameCount => ptr.ref.frameCount;
  int get sampleRate => ptr.ref.stream.sampleRate;
  int get sampleSize => ptr.ref.stream.sampleSize;
  int get channels => ptr.ref.stream.channels;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibSoundToDart on raw.Sound {
  Sound toDart() {
    final p = ffi.malloc<raw.Sound>();
    p.ref
      ..stream.buffer = stream.buffer
      ..stream.processor = stream.processor
      ..stream.sampleRate = stream.sampleRate
      ..stream.sampleSize = stream.sampleSize
      ..stream.channels = stream.channels
      ..frameCount = frameCount;
    return Sound._(p);
  }
}

class Music {
  final Pointer<raw.Music> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.Music>>(_free);
  static void _free(Pointer<raw.Music> ptr) {
    raw.UnloadMusicStream(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Music._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get frameCount => ptr.ref.frameCount;
  bool get looping => ptr.ref.looping;
  set looping(bool value) => ptr.ref.looping = value;
  int get sampleRate => ptr.ref.stream.sampleRate;
  int get sampleSize => ptr.ref.stream.sampleSize;
  int get channels => ptr.ref.stream.channels;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibMusicToDart on raw.Music {
  Music toDart() {
    final p = ffi.malloc<raw.Music>();
    p.ref
      ..stream.buffer = stream.buffer
      ..stream.processor = stream.processor
      ..stream.sampleRate = stream.sampleRate
      ..stream.sampleSize = stream.sampleSize
      ..stream.channels = stream.channels
      ..frameCount = frameCount
      ..looping = looping
      ..ctxType = ctxType
      ..ctxData = ctxData;
    return ._(p);
  }
}

class VrDeviceInfo {
  final int hResolution;
  final int vResolution;
  final double hScreenSize;
  final double vScreenSize;
  final double eyeToScreenDistance;
  final double lensSeparationDistance;
  final double interpupillaryDistance;

  /// 4-element distortion coefficients [k0, k1, k2, k3].
  final List<double> lensDistortionValues;

  /// 4-element chromatic aberration correction values [r, rg, b, bg].
  final List<double> chromaAbCorrection;

  const VrDeviceInfo({
    required this.hResolution,
    required this.vResolution,
    required this.hScreenSize,
    required this.vScreenSize,
    required this.eyeToScreenDistance,
    required this.lensSeparationDistance,
    required this.interpupillaryDistance,
    required this.lensDistortionValues,
    required this.chromaAbCorrection,
  });
}

class VrStereoConfig {
  final Pointer<raw.VrStereoConfig> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.VrStereoConfig>>(_free);
  static void _free(Pointer<raw.VrStereoConfig> ptr) {
    raw.UnloadVrStereoConfig(ptr.ref);
    ffi.malloc.free(ptr);
  }

  VrStereoConfig._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

void _copyMatrix(raw.Matrix dst, raw.Matrix src) {
  dst
    ..m0 = src.m0
    ..m4 = src.m4
    ..m8 = src.m8
    ..m12 = src.m12
    ..m1 = src.m1
    ..m5 = src.m5
    ..m9 = src.m9
    ..m13 = src.m13
    ..m2 = src.m2
    ..m6 = src.m6
    ..m10 = src.m10
    ..m14 = src.m14
    ..m3 = src.m3
    ..m7 = src.m7
    ..m11 = src.m11
    ..m15 = src.m15;
}

void _copyMatrix4(raw.Matrix dst, Matrix4 src) {
  final s = src.storage;
  dst
    ..m0 = s[0]
    ..m4 = s[4]
    ..m8 = s[8]
    ..m12 = s[12]
    ..m1 = s[1]
    ..m5 = s[5]
    ..m9 = s[9]
    ..m13 = s[13]
    ..m2 = s[2]
    ..m6 = s[6]
    ..m10 = s[10]
    ..m14 = s[14]
    ..m3 = s[3]
    ..m7 = s[7]
    ..m11 = s[11]
    ..m15 = s[15];
}

extension RaylibVrStereoConfigToDart on raw.VrStereoConfig {
  VrStereoConfig toDart() {
    final p = ffi.malloc<raw.VrStereoConfig>();
    _copyMatrix(p.ref.projection[0], projection[0]);
    _copyMatrix(p.ref.projection[1], projection[1]);
    _copyMatrix(p.ref.viewOffset[0], viewOffset[0]);
    _copyMatrix(p.ref.viewOffset[1], viewOffset[1]);
    for (var i = 0; i < 2; i++) {
      p.ref.leftLensCenter[i] = leftLensCenter[i];
      p.ref.rightLensCenter[i] = rightLensCenter[i];
      p.ref.leftScreenCenter[i] = leftScreenCenter[i];
      p.ref.rightScreenCenter[i] = rightScreenCenter[i];
      p.ref.scale[i] = scale[i];
      p.ref.scaleIn[i] = scaleIn[i];
    }
    return VrStereoConfig._(p);
  }
}

class FilePathList {
  final List<String> paths;

  const FilePathList(this.paths);
}

extension RaylibFilePathListToDart on raw.FilePathList {
  FilePathList toDart() => FilePathList([
    for (var i = 0; i < count; i++) paths[i].cast<ffi.Utf8>().toDartString(),
  ]);
}

@immutable
class AutomationEvent {
  final int frame;
  final int type;

  /// Always exactly 4 elements.
  final List<int> params;

  const AutomationEvent({
    required this.frame,
    required this.type,
    required this.params,
  }) : assert(params.length == 4);
}

class AutomationEventList {
  final Pointer<raw.AutomationEventList> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raw.AutomationEventList>>(_free);
  static void _free(Pointer<raw.AutomationEventList> ptr) {
    raw.UnloadAutomationEventList(ptr.ref);
    ffi.malloc.free(ptr);
  }

  AutomationEventList._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get count => ptr.ref.count;
  int get capacity => ptr.ref.capacity;

  AutomationEvent operator [](int index) {
    final e = ptr.ref.events[index];
    return AutomationEvent(
      frame: e.frame,
      type: e.type,
      params: .generate(4, (i) => e.params[i], growable: false),
    );
  }

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibAutomationEventListToDart on raw.AutomationEventList {
  AutomationEventList toDart() {
    final p = ffi.malloc<raw.AutomationEventList>();
    p.ref
      ..capacity = capacity
      ..count = count
      ..events = events;
    return ._(p);
  }
}

extension ArenaExt on ffi.Arena {
  Pointer<raw.Vector2> vector2(Vector2 value) {
    final ptr = this<raw.Vector2>();
    ptr.ref
      ..x = value.x
      ..y = value.y;
    return ptr;
  }

  Pointer<raw.Vector2> vector2s(List<Vector2> value) {
    final size = value.length;
    final ptrs = this<raw.Vector2>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y;
    }
    return ptrs;
  }

  Pointer<raw.Vector3> vector3(Vector3 value) {
    final ptr = this<raw.Vector3>();
    ptr.ref
      ..x = value.x
      ..y = value.y
      ..z = value.z;
    return ptr;
  }

  Pointer<raw.Vector3> vector3s(List<Vector3> value) {
    final size = value.length;
    final ptrs = this<raw.Vector3>(size);
    for (var i = 0; i < size; i++) {
      ptrs[i]
        ..x = value[i].x
        ..y = value[i].y
        ..z = value[i].z;
    }
    return ptrs;
  }

  Pointer<raw.Ray> ray(Ray value) {
    final ptr = this<raw.Ray>();
    ptr.ref
      ..position.x = value.origin.x
      ..position.y = value.origin.y
      ..position.z = value.origin.z
      ..direction.x = value.direction.x
      ..direction.y = value.direction.y
      ..direction.z = value.direction.z;
    return ptr;
  }

  Pointer<raw.BoundingBox> boundingBox(BoundingBox value) {
    final ptr = this<raw.BoundingBox>();
    ptr.ref
      ..min.x = value.min.x
      ..min.y = value.min.y
      ..min.z = value.min.z
      ..max.x = value.max.x
      ..max.y = value.max.y
      ..max.z = value.max.z;
    return ptr;
  }

  Pointer<raw.Texture> texture(Texture value) {
    final ptr = this<raw.Texture>();
    ptr.ref
      ..id = value.id
      ..width = value.width
      ..height = value.height
      ..mipmaps = value.mipmaps
      ..format = value.format.value;
    return ptr;
  }

  Pointer<raw.RenderTexture> renderTexture(RenderTexture2D value) {
    final ptr = this<raw.RenderTexture>();
    ptr.ref
      ..id = value.id
      ..texture.id = value.texture.id
      ..texture.width = value.texture.width
      ..texture.height = value.texture.height
      ..texture.mipmaps = value.texture.mipmaps
      ..texture.format = value.texture.format.value
      ..depth.id = value.depth.id
      ..depth.width = value.depth.width
      ..depth.height = value.depth.height
      ..depth.mipmaps = value.depth.mipmaps
      ..depth.format = value.depth.format.value;
    return ptr;
  }

  Pointer<raw.NPatchInfo> nPatchInfo(NPatchInfo value) {
    final ptr = this<raw.NPatchInfo>();
    ptr.ref
      ..source.x = value.source.x
      ..source.y = value.source.y
      ..source.width = value.source.width
      ..source.height = value.source.height
      ..left = value.left
      ..top = value.top
      ..right = value.right
      ..bottom = value.bottom
      ..layout = value.layout.value;
    return ptr;
  }

  Pointer<raw.Matrix> matrix4(Matrix4 value) {
    final ptr = this<raw.Matrix>();
    _copyMatrix4(ptr.ref, value);
    return ptr;
  }

  Pointer<raw.Matrix> matrix4s(List<Matrix4> values) {
    final ptr = this<raw.Matrix>(values.length);
    for (var i = 0; i < values.length; i++) {
      _copyMatrix4(ptr[i], values[i]);
    }
    return ptr;
  }

  Pointer<raw.Shader> shader(Shader value) => value.ptr;

  Pointer<raw.VrDeviceInfo> vrDeviceInfo(VrDeviceInfo value) {
    final ptr = this<raw.VrDeviceInfo>();
    ptr.ref
      ..hResolution = value.hResolution
      ..vResolution = value.vResolution
      ..hScreenSize = value.hScreenSize
      ..vScreenSize = value.vScreenSize
      ..eyeToScreenDistance = value.eyeToScreenDistance
      ..lensSeparationDistance = value.lensSeparationDistance
      ..interpupillaryDistance = value.interpupillaryDistance;
    for (var i = 0; i < 4; i++) {
      ptr.ref.lensDistortionValues[i] = value.lensDistortionValues[i];
      ptr.ref.chromaAbCorrection[i] = value.chromaAbCorrection[i];
    }
    return ptr;
  }

  Pointer<raw.AutomationEvent> automationEvent(AutomationEvent value) {
    final ptr = this<raw.AutomationEvent>();
    ptr.ref.frame = value.frame;
    ptr.ref.type = value.type;
    for (var i = 0; i < 4; i++) {
      ptr.ref.params[i] = value.params[i];
    }
    return ptr;
  }

  Pointer<raw.Image> image(Image value) => value.ptr;
}
