import 'package:meta/meta.dart';

import 'src/raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'package:image/image.dart' as img;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;
import 'src/raylib_const.dart' as consts;

export 'package:image/image.dart' show Image; // for img.Image
export 'package:vector_math/vector_math.dart' show Vector2;
export 'package:vector_math/vector_math.dart' show Vector3;
export 'package:vector_math/vector_math.dart' show Vector4;
export 'package:vector_math/vector_math.dart' show Matrix4;
export 'package:vector_math/vector_math.dart' show Quaternion;

// ── Vector2 ──────────────────────────────────────────────────────────────
// via package:vector_math — Vector2

extension Vector2Extension on raylib.Vector2 {
  Vector2 toDart() => .new(x, y);
}

// ── Vector3 ──────────────────────────────────────────────────────────────
// via package:vector_math — Vector3

extension Vector3Extension on raylib.Vector3 {
  Vector3 toDart() => .new(x, y, z);
}

// ── Vector4 ──────────────────────────────────────────────────────────────
// via package:vector_math — Vector4

extension Vector4Extension on raylib.Vector4 {
  Vector4 toDart() => .new(x, y, z, w);
}

// ── Matrix ───────────────────────────────────────────────────────────────
// via package:vector_math — Matrix4

extension MatrixExtension on raylib.Matrix {
  Matrix4 toDart() => .new(
    m0,  m1,  m2,  m3,
    m4,  m5,  m6,  m7,
    m8,  m9,  m10, m11,
    m12, m13, m14, m15,
  );
}

// ── Color ────────────────────────────────────────────────────────────────
// see colors.dart

// ── Rectangle ────────────────────────────────────────────────────────────

class Rectangle {
  final Pointer<raylib.Rectangle> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Rectangle>>(ffi.malloc.free);

  Rectangle._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Rectangle.zero() => Rectangle();

  factory Rectangle({
    double x = 0,
    double y = 0,
    double width = 0,
    double height = 0,
  }) => Rectangle._(ffi.malloc<raylib.Rectangle>())
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

extension RectangleExt on raylib.Rectangle {
  Rectangle toDart() => .new(x: x, y: y, width: width, height: height);
}

// ── Image ────────────────────────────────────────────────────────────────
// via package:image — img.Image
//
// raylib.Image → img.Image: RaylibImageToDart.toDart()
// img.Image → raylib.Image: ArenaExt.image()
//
// Only uncompressed formats (grayscale/grayAlpha/R8G8B8/R8G8B8A8) are
// supported for conversion. Throws [UnsupportedError] for others.
// The caller is responsible for UnloadImage after toDart().

extension RaylibImageToDart on raylib.Image {
  img.Image toDart() {
    final n = width * height;
    final fmt = consts.PixelFormat.fromValue(format);
    return switch (fmt) {
      .uncompressedGrayscale => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n)).buffer,
        numChannels: 1,
      ),
      .uncompressedGrayAlpha => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 2)).buffer,
        numChannels: 2,
      ),
      .uncompressedR8g8b8 => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 3)).buffer,
        numChannels: 3,
      ),
      .uncompressedR8g8b8a8 => .fromBytes(
        width: width,
        height: height,
        bytes: Uint8List.fromList(data.cast<Uint8>().asTypedList(n * 4)).buffer,
        numChannels: 4,
        order: .rgba,
      ),
      _ => throw UnsupportedError('PixelFormat $format is not supported for conversion to dart Image'),
    };
  }
}

// ── Texture ──────────────────────────────────────────────────────────────

/// Immutable handle to a GPU texture.
///
/// Use [UnloadTexture] to release GPU memory when done.
/// No automatic cleanup — GPU resources must not be freed after the
/// OpenGL context is destroyed.
class Texture {
  final int id;
  final int width;
  final int height;
  final int mipmaps;
  final consts.PixelFormat format;

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

extension RaylibTextureToDart on raylib.Texture {
  Texture toDart() => Texture(
    id: id,
    width: width,
    height: height,
    mipmaps: mipmaps,
    format: consts.PixelFormat.fromValue(format),
  );
}

// ── RenderTexture ────────────────────────────────────────────────────────

/// Immutable handle to a GPU framebuffer (FBO).
///
/// Use [UnloadRenderTexture] to release GPU memory when done.
class RenderTexture2D {
  final int id;

  /// Color buffer (texture attachment).
  final Texture texture;

  /// Depth buffer (texture attachment).
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

extension RaylibRenderTextureToDart on raylib.RenderTexture {
  RenderTexture2D toDart() => RenderTexture2D(
    id: id,
    texture: texture.toDart(),
    depth: depth.toDart(),
  );
}

// ── NPatchInfo ───────────────────────────────────────────────────────────

/// Nine-patch image slice configuration.
class NPatchInfo {
  final Rectangle source;
  final int left;
  final int top;
  final int right;
  final int bottom;
  final consts.NPatchLayout layout;

  NPatchInfo({
    required this.source,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.layout,
  });
}

// ── GlyphInfo ────────────────────────────────────────────────────────────

/// Font glyph metrics for a single character.
///
/// The glyph bitmap image is omitted — use [Font.glyphRect] if needed.
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

// ── Font ─────────────────────────────────────────────────────────────────

/// Handle to a loaded font.
///
/// Created by LoadFont / LoadFontEx; released by [UnloadFont] or [dispose].
class Font {
  final Pointer<raylib.Font> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Font>>(_free);
  static void _free(Pointer<raylib.Font> ptr) {
    raylib.UnloadFont(ptr.ref);
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
    final g = (ptr.ref.glyphs + index).ref;
    return GlyphInfo(
      value: g.value,
      offsetX: g.offsetX,
      offsetY: g.offsetY,
      advanceX: g.advanceX,
    );
  }

  Rectangle glyphRect(int index) => (ptr.ref.recs + index).ref.toDart();

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibFontToDart on raylib.Font {
  Font toDart() {
    final p = ffi.malloc<raylib.Font>();
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

// ── Camera2D ─────────────────────────────────────────────────────────────

class Camera2D {
  final Pointer<raylib.Camera2D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Camera2D>>(_free);
  static void _free(Pointer<raylib.Camera2D> ptr) => ffi.malloc.free(ptr);

  Camera2D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera2D({
    Vector2? offset,
    Vector2? target,
    double rotation = 0.0,
    double zoom = 1.0,
  }) {
    final pointer = ffi.malloc<raylib.Camera2D>();
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

// ── Camera3D ─────────────────────────────────────────────────────────────

class Camera3D {
  final Pointer<raylib.Camera3D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Camera3D>>(_free);
  static void _free(Pointer<raylib.Camera3D> ptr) => ffi.malloc.free(ptr);

  Camera3D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera3D({
    Vector3? position,
    Vector3? target,
    Vector3? up,
    double fovy = 45.0,
    consts.CameraProjection projection = .perspective,
  }) {
    final pointer = ffi.malloc<raylib.Camera3D>();
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

  consts.CameraProjection get projection => .fromValue(ptr.ref.projection);
  set projection(consts.CameraProjection value) => ptr.ref.projection = value.value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

// ── Shader ───────────────────────────────────────────────────────────────

/// Handle to a GPU shader program.
///
/// Holds a stable native pointer so the raylib-managed [locs] array can be
/// read/written without copying.
///
/// Call [UnloadShader] (or [dispose]) to release GPU resources.
/// Must be called before the OpenGL context is destroyed.
class Shader {
  final Pointer<raylib.Shader> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Shader>>(_free);
  static void _free(Pointer<raylib.Shader> ptr) {
    raylib.UnloadShader(ptr.ref);
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

extension RaylibShaderToDart on raylib.Shader {
  Shader toDart() {
    final p = ffi.malloc<raylib.Shader>();
    p.ref
      ..id = id
      ..locs = locs;
    return Shader._(p);
  }
}

// ── MaterialMap ───────────────────────────────────────────────────────────

/// Texture + color tint + scalar value for one material channel.
///
/// Access via [Material.operator[]] with a MATERIAL_MAP_* index.
/// The color components (r, g, b, a) can be passed to `Color(r:r, g:g, b:b, a:a)`.
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

// ── Material ──────────────────────────────────────────────────────────────

/// Handle to a material (shader + texture maps + params).
///
/// Created by LoadMaterials / LoadMaterialDefault;
/// released by [UnloadMaterial] or [dispose].
class Material {
  final Pointer<raylib.Material> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Material>>(_free);
  static void _free(Pointer<raylib.Material> ptr) {
    raylib.UnloadMaterial(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Material._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  /// Access a material map by index (use MATERIAL_MAP_* constants).
  MaterialMap operator [](int index) {
    final m = (ptr.ref.maps + index).ref;
    return MaterialMap(
      texture: m.texture.toDart(),
      colorR: m.color.r,
      colorG: m.color.g,
      colorB: m.color.b,
      colorA: m.color.a,
      value: m.value,
    );
  }

  /// User-defined float parameters [0..3].
  Float32List get params => Float32List.fromList([
    ptr.ref.params[0],
    ptr.ref.params[1],
    ptr.ref.params[2],
    ptr.ref.params[3],
  ]);

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibMaterialToDart on raylib.Material {
  Material toDart() {
    final p = ffi.malloc<raylib.Material>();
    p.ref.shader
      ..id = shader.id
      ..locs = shader.locs;
    p.ref.maps = maps;
    for (var i = 0; i < 4; i++) {
      p.ref.params[i] = params[i];
    }
    return Material._(p);
  }
}

// ── Mesh ──────────────────────────────────────────────────────────────────

/// Handle to mesh vertex data (CPU + GPU).
///
/// Created by GenMesh* or LoadModel internally;
/// released by [UnloadMesh] or [dispose].
class Mesh {
  final Pointer<raylib.Mesh> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Mesh>>(_free);
  static void _free(Pointer<raylib.Mesh> ptr) {
    raylib.UnloadMesh(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Mesh._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get vertexCount => ptr.ref.vertexCount;
  int get triangleCount => ptr.ref.triangleCount;

  /// OpenGL VAO id (0 if not uploaded).
  int get vaoId => ptr.ref.vaoId;

  /// XYZ vertex positions; length = vertexCount × 3.
  Float32List? get vertices => ptr.ref.vertices == nullptr
      ? null : ptr.ref.vertices.asTypedList(vertexCount * 3);

  /// UV texture coordinates; length = vertexCount × 2.
  Float32List? get texcoords => ptr.ref.texcoords == nullptr
      ? null : ptr.ref.texcoords.asTypedList(vertexCount * 2);

  /// Secondary UV coords; length = vertexCount × 2.
  Float32List? get texcoords2 => ptr.ref.texcoords2 == nullptr
      ? null : ptr.ref.texcoords2.asTypedList(vertexCount * 2);

  /// XYZ normals; length = vertexCount × 3.
  Float32List? get normals => ptr.ref.normals == nullptr
      ? null : ptr.ref.normals.asTypedList(vertexCount * 3);

  /// XYZW tangents; length = vertexCount × 4.
  Float32List? get tangents => ptr.ref.tangents == nullptr
      ? null : ptr.ref.tangents.asTypedList(vertexCount * 4);

  /// RGBA vertex colors; length = vertexCount × 4.
  Uint8List? get colors => ptr.ref.colors == nullptr
      ? null : ptr.ref.colors.cast<Uint8>().asTypedList(vertexCount * 4);

  /// Triangle indices; length = triangleCount × 3.
  Uint16List? get indices => ptr.ref.indices == nullptr
      ? null : ptr.ref.indices.cast<Uint16>().asTypedList(triangleCount * 3);

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibMeshToDart on raylib.Mesh {
  Mesh toDart() {
    final p = ffi.malloc<raylib.Mesh>();
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
      ..boneIds = boneIds
      ..boneWeights = boneWeights
      ..boneMatrices = boneMatrices
      ..boneCount = boneCount
      ..vaoId = vaoId
      ..vboId = vboId;
    return Mesh._(p);
  }
}

// ── Model ─────────────────────────────────────────────────────────────────

/// Handle to a 3D model (meshes + materials + bones).
///
/// Created by LoadModel / LoadModelFromMesh;
/// released by [UnloadModel] or [dispose].
class Model {
  final Pointer<raylib.Model> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Model>>(_free);
  static void _free(Pointer<raylib.Model> ptr) {
    raylib.UnloadModel(ptr.ref);
    ffi.malloc.free(ptr);
  }

  Model._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  Matrix4 get transform => ptr.ref.transform.toDart();
  set transform(Matrix4 value) => _copyMatrix4(ptr.ref.transform, value);

  int get meshCount => ptr.ref.meshCount;
  int get materialCount => ptr.ref.materialCount;
  int get boneCount => ptr.ref.boneCount;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibModelToDart on raylib.Model {
  Model toDart() {
    final p = ffi.malloc<raylib.Model>();
    _copyMatrix(p.ref.transform, transform);
    p.ref
      ..meshCount = meshCount
      ..materialCount = materialCount
      ..meshes = meshes
      ..materials = materials
      ..meshMaterial = meshMaterial
      ..boneCount = boneCount
      ..bones = bones
      ..bindPose = bindPose;
    return Model._(p);
  }
}

// ── ModelAnimation ────────────────────────────────────────────────────────

/// Handle to a skeletal animation.
///
/// Created by LoadModelAnimations;
/// released by [UnloadModelAnimation] or [dispose].
class ModelAnimation {
  final Pointer<raylib.ModelAnimation> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.ModelAnimation>>(_free);
  static void _free(Pointer<raylib.ModelAnimation> ptr) {
    raylib.UnloadModelAnimation(ptr.ref);
    ffi.malloc.free(ptr);
  }

  ModelAnimation._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get boneCount => ptr.ref.boneCount;
  int get frameCount => ptr.ref.frameCount;

  String get name {
    final sb = StringBuffer();
    for (var i = 0; i < 32; i++) {
      final c = ptr.ref.name[i];
      if (c == 0) break;
      sb.writeCharCode(c);
    }
    return sb.toString();
  }

  BoneInfo boneInfo(int index) => (ptr.ref.bones + index).ref.toDart();

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this);
    _free(ptr);
    _disposed = true;
  }
}

extension RaylibModelAnimationToDart on raylib.ModelAnimation {
  ModelAnimation toDart() {
    final p = ffi.malloc<raylib.ModelAnimation>();
    p.ref
      ..boneCount = boneCount
      ..frameCount = frameCount
      ..bones = bones
      ..framePoses = framePoses;
    for (var i = 0; i < 32; i++) {
      p.ref.name[i] = name[i];
    }
    return ModelAnimation._(p);
  }
}

// ── Transform ────────────────────────────────────────────────────────────

/// Vertex transformation data (translation, rotation, scale).
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

extension TransformExt on raylib.Transform {
  Transform toDart() => Transform(
    translation: translation.toDart(),
    rotation: Quaternion(rotation.x, rotation.y, rotation.z, rotation.w),
    scale: scale.toDart(),
  );
}

// ── BoneInfo ─────────────────────────────────────────────────────────────

/// Skeletal bone definition.
@immutable
class BoneInfo {
  final String name;

  /// Index of the parent bone (-1 for root).
  final int parent;

  const BoneInfo({required this.name, required this.parent});
}

extension BoneInfoExt on raylib.BoneInfo {
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

// ── Ray ──────────────────────────────────────────────────────────────────
// via package:vector_math — Ray

extension RayExtension on raylib.Ray {
  Ray toDart() => .originDirection(position.toDart(), direction.toDart());
}

// ── RayCollision ─────────────────────────────────────────────────────────

/// Result of a ray cast hit test.
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

extension RayCollisionExt on raylib.RayCollision {
  RayCollision toDart() => RayCollision(
    hit: hit,
    distance: distance,
    point: point.toDart(),
    normal: normal.toDart(),
  );
}

// ── BoundingBox ───────────────────────────────────────────────────────────

/// Axis-aligned bounding box.
@immutable
class BoundingBox {
  final Vector3 min;
  final Vector3 max;

  const BoundingBox({required this.min, required this.max});
}

extension BoundingBoxExt on raylib.BoundingBox {
  BoundingBox toDart() => BoundingBox(min: min.toDart(), max: max.toDart());
}

// ── Wave ──────────────────────────────────────────────────────────────────

/// Handle to audio wave data (PCM samples in RAM).
///
/// Created by LoadWave / LoadWaveFromMemory;
/// released by [UnloadWave] or [dispose].
class Wave {
  final Pointer<raylib.Wave> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Wave>>(_free);
  static void _free(Pointer<raylib.Wave> ptr) {
    raylib.UnloadWave(ptr.ref);
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

extension RaylibWaveToDart on raylib.Wave {
  Wave toDart() {
    final p = ffi.malloc<raylib.Wave>();
    p.ref
      ..frameCount = frameCount
      ..sampleRate = sampleRate
      ..sampleSize = sampleSize
      ..channels = channels
      ..data = data;
    return Wave._(p);
  }
}

// ── AudioStream ───────────────────────────────────────────────────────────

/// Handle to a raw audio stream (for streaming audio data).
///
/// Created by LoadAudioStream;
/// released by [UnloadAudioStream] or [dispose].
class AudioStream {
  final Pointer<raylib.AudioStream> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.AudioStream>>(_free);
  static void _free(Pointer<raylib.AudioStream> ptr) {
    raylib.UnloadAudioStream(ptr.ref);
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

extension RaylibAudioStreamToDart on raylib.AudioStream {
  AudioStream toDart() {
    final p = ffi.malloc<raylib.AudioStream>();
    p.ref
      ..buffer = buffer
      ..processor = processor
      ..sampleRate = sampleRate
      ..sampleSize = sampleSize
      ..channels = channels;
    return AudioStream._(p);
  }
}

// ── Sound ─────────────────────────────────────────────────────────────────

/// Handle to a loaded sound (short audio clip).
///
/// Created by LoadSound / LoadSoundFromWave;
/// released by [UnloadSound] or [dispose].
class Sound {
  final Pointer<raylib.Sound> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Sound>>(_free);
  static void _free(Pointer<raylib.Sound> ptr) {
    raylib.UnloadSound(ptr.ref);
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

extension RaylibSoundToDart on raylib.Sound {
  Sound toDart() {
    final p = ffi.malloc<raylib.Sound>();
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

// ── Music ─────────────────────────────────────────────────────────────────

/// Handle to a music stream (long audio, streamed from file/memory).
///
/// Created by LoadMusicStream / LoadMusicStreamFromMemory;
/// released by [UnloadMusicStream] or [dispose].
class Music {
  final Pointer<raylib.Music> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Music>>(_free);
  static void _free(Pointer<raylib.Music> ptr) {
    raylib.UnloadMusicStream(ptr.ref);
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

extension RaylibMusicToDart on raylib.Music {
  Music toDart() {
    final p = ffi.malloc<raylib.Music>();
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
    return Music._(p);
  }
}

// ── VrDeviceInfo ─────────────────────────────────────────────────────────

/// Immutable description of a VR headset's optical/display properties.
///
/// Pass to [LoadVrStereoConfig] to generate a [VrStereoConfig].
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

// ── VrStereoConfig ───────────────────────────────────────────────────────

/// Handle to a VR stereo rendering configuration.
///
/// Created by [LoadVrStereoConfig]; released by [UnloadVrStereoConfig] or
/// [dispose]. The Finalizer ensures the native config is freed even if
/// [dispose] is never called explicitly.
class VrStereoConfig {
  final Pointer<raylib.VrStereoConfig> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.VrStereoConfig>>(_free);
  static void _free(Pointer<raylib.VrStereoConfig> ptr) {
    raylib.UnloadVrStereoConfig(ptr.ref);
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

void _copyMatrix(raylib.Matrix dst, raylib.Matrix src) {
  dst
    ..m0  = src.m0  ..m4  = src.m4  ..m8  = src.m8  ..m12 = src.m12
    ..m1  = src.m1  ..m5  = src.m5  ..m9  = src.m9  ..m13 = src.m13
    ..m2  = src.m2  ..m6  = src.m6  ..m10 = src.m10 ..m14 = src.m14
    ..m3  = src.m3  ..m7  = src.m7  ..m11 = src.m11 ..m15 = src.m15;
}

void _copyMatrix4(raylib.Matrix dst, Matrix4 src) {
  final s = src.storage;
  dst
    ..m0  = s[0]  ..m4  = s[4]  ..m8  = s[8]  ..m12 = s[12]
    ..m1  = s[1]  ..m5  = s[5]  ..m9  = s[9]  ..m13 = s[13]
    ..m2  = s[2]  ..m6  = s[6]  ..m10 = s[10] ..m14 = s[14]
    ..m3  = s[3]  ..m7  = s[7]  ..m11 = s[11] ..m15 = s[15];
}

extension RaylibVrStereoConfigToDart on raylib.VrStereoConfig {
  VrStereoConfig toDart() {
    final p = ffi.malloc<raylib.VrStereoConfig>();
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

// ── FilePathList ──────────────────────────────────────────────────────────
// not yet wrapped (LoadDirectoryFiles/LoadDirectoryFilesEx already return
// List<String> directly — no Dart wrapper class needed)

// ── AutomationEvent ──────────────────────────────────────────────────────

/// A single recorded input event.
///
/// [frame] is the frame the event occurred on.
/// [type] is the event type (internal to raylib, not a public enum).
/// [params] is a fixed 4-element list of event parameters.
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

// ── AutomationEventList ───────────────────────────────────────────────────

/// Handle to a recorded automation event list.
///
/// Created by [LoadAutomationEventList]; released by
/// [UnloadAutomationEventList] or [dispose].
class AutomationEventList {
  final Pointer<raylib.AutomationEventList> ptr;
  bool _disposed = false;

  static final _finalizer =
      Finalizer<Pointer<raylib.AutomationEventList>>(_free);
  static void _free(Pointer<raylib.AutomationEventList> ptr) {
    raylib.UnloadAutomationEventList(ptr.ref);
    ffi.malloc.free(ptr);
  }

  AutomationEventList._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  int get count => ptr.ref.count;
  int get capacity => ptr.ref.capacity;

  AutomationEvent operator [](int index) {
    final e = (ptr.ref.events + index).ref;
    return AutomationEvent(
      frame: e.frame,
      type: e.type,
      params: List<int>.generate(4, (i) => e.params[i], growable: false),
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

extension RaylibAutomationEventListToDart on raylib.AutomationEventList {
  AutomationEventList toDart() {
    final p = ffi.malloc<raylib.AutomationEventList>();
    p.ref
      ..capacity = capacity
      ..count = count
      ..events = events;
    return AutomationEventList._(p);
  }
}

// ── ArenaExt ─────────────────────────────────────────────────────────────

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

  Pointer<raylib.BoundingBox> boundingBox(BoundingBox value) {
    final ptr = this<raylib.BoundingBox>();
    ptr.ref
      ..min.x = value.min.x
      ..min.y = value.min.y
      ..min.z = value.min.z
      ..max.x = value.max.x
      ..max.y = value.max.y
      ..max.z = value.max.z;
    return ptr;
  }

  Pointer<raylib.Texture> texture(Texture value) {
    final ptr = this<raylib.Texture>();
    ptr.ref
      ..id = value.id
      ..width = value.width
      ..height = value.height
      ..mipmaps = value.mipmaps
      ..format = value.format.value;
    return ptr;
  }

  Pointer<raylib.RenderTexture> renderTexture(RenderTexture2D value) {
    final ptr = this<raylib.RenderTexture>();
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

  Pointer<raylib.NPatchInfo> nPatchInfo(NPatchInfo value) {
    final ptr = this<raylib.NPatchInfo>();
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

  Pointer<raylib.Matrix> matrix4(Matrix4 value) {
    final ptr = this<raylib.Matrix>();
    _copyMatrix4(ptr.ref, value);
    return ptr;
  }

  Pointer<raylib.Matrix> matrix4s(List<Matrix4> values) {
    final ptr = this<raylib.Matrix>(values.length);
    for (var i = 0; i < values.length; i++) {
      _copyMatrix4((ptr + i).ref, values[i]);
    }
    return ptr;
  }

  Pointer<raylib.Shader> shader(Shader value) => value.ptr;

  Pointer<raylib.VrDeviceInfo> vrDeviceInfo(VrDeviceInfo value) {
    final ptr = this<raylib.VrDeviceInfo>();
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

  Pointer<raylib.AutomationEvent> automationEvent(AutomationEvent value) {
    final ptr = this<raylib.AutomationEvent>();
    ptr.ref.frame = value.frame;
    ptr.ref.type = value.type;
    for (var i = 0; i < 4; i++) {
      ptr.ref.params[i] = value.params[i];
    }
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
      ..format = consts.PixelFormat.uncompressedR8g8b8a8.value;
    return ptr;
  }
}
