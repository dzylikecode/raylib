import 'package:meta/meta.dart';

import 'src/raylib.g.dart' as raylib;
import 'package:vector_math/vector_math.dart';
import 'package:image/image.dart' as img;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;
import 'src/raylib_const.dart' as consts;

// ── Rectangle ───────────────────────────────────────────────────────────

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

  Pointer<raylib.Shader> shader(Shader value) => value.ptr;

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

  Pointer<raylib.AutomationEvent> automationEvent(AutomationEvent value) {
    final ptr = this<raylib.AutomationEvent>();
    ptr.ref.frame = value.frame;
    ptr.ref.type = value.type;
    for (var i = 0; i < 4; i++) {
      ptr.ref.params[i] = value.params[i];
    }
    return ptr;
  }

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


// ── Texture ────────────────────────────────────────────────────────────

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

// ── RenderTexture ───────────────────────────────────────────────────────

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

// ── Shader ─────────────────────────────────────────────────────────────

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

  /// Raylib-managed locations array.
  /// Use [GetShaderLocation] rather than indexing this directly.
  Pointer<Int> get locs => ptr.ref.locs;

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

class Camera2D {
  final Pointer<raylib.Camera2D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Camera2D>>(_free);
  static void _free(Pointer<raylib.Camera2D> ptr) {
    ffi.malloc.free(ptr);
  }

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

    // 初始化，否则值是随机的，视野都不知道去哪里了
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
    _finalizer.detach(this); // 取消自动释放
    _free(ptr);
    _disposed = true;
  }
}

// ── VrDeviceInfo ────────────────────────────────────────────────────────

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

// ── VrStereoConfig ──────────────────────────────────────────────────────

/// Handle to a VR stereo rendering configuration.
///
/// Created by [LoadVrStereoConfig]; released by [UnloadVrStereoConfig].
/// The [dispose] method frees the wrapper struct allocated by this class
/// and calls the native UnloadVrStereoConfig automatically.
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
    ..m0 = src.m0 ..m4 = src.m4 ..m8  = src.m8  ..m12 = src.m12
    ..m1 = src.m1 ..m5 = src.m5 ..m9  = src.m9  ..m13 = src.m13
    ..m2 = src.m2 ..m6 = src.m6 ..m10 = src.m10 ..m14 = src.m14
    ..m3 = src.m3 ..m7 = src.m7 ..m11 = src.m11 ..m15 = src.m15;
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

class Camera3D {
  final Pointer<raylib.Camera3D> ptr;
  bool _disposed = false;

  static final _finalizer = Finalizer<Pointer<raylib.Camera3D>>(_free);

  static void _free(Pointer<raylib.Camera3D> ptr) {
    ffi.malloc.free(ptr);
  }

  Camera3D._(this.ptr) {
    _finalizer.attach(this, ptr, detach: this);
  }

  factory Camera3D({
    Vector3? position,
    Vector3? target,
    Vector3? up,
    double fovy = 45.0,
    int projection = 0, // CAMERA_PERSPECTIVE
  }) {
    final pointer = ffi.malloc<raylib.Camera3D>();

    return Camera3D._(pointer)
      ..position = position ?? .zero()
      ..target = target ?? .zero()
      ..up =
          up ??
          .zero() // TODO: (0,1,0) 应该是这个
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

  int get projection => ptr.ref.projection;
  set projection(int value) => ptr.ref.projection = value;

  @mustCallSuper
  void dispose() {
    if (_disposed) return;
    _finalizer.detach(this); // 取消自动释放
    _free(ptr);
    _disposed = true;
  }
}

// ── AutomationEvent ──────────────────────────────────────────────────────

/// A single recorded input event.
///
/// [frame] is the frame the event occurred on.
/// [type] is the event type (see raylib automation event type constants).
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

// ── AutomationEventList ──────────────────────────────────────────────────

/// Handle to a recorded automation event list.
///
/// Created by [LoadAutomationEventList]; released by [UnloadAutomationEventList]
/// or [dispose]. The Finalizer ensures the native list is freed even if
/// [dispose] is never called explicitly.
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
