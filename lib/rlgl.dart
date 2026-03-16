// ignore_for_file: non_constant_identifier_names
//
// 本文件导出 rlgl 模块（底层 OpenGL 抽象层）。
//
// 大部分 rlgl 函数仅使用基础类型（int / double / bool），可直接导出。
// 需要指针/Matrix/RenderBatch 等复杂类型的函数先注释，在后面封装 Dart 接口。
//
// 不代理：
//   rlEnableStatePointer, rlDisableStatePointer — OpenGL 1.1 only，Dart 绑定未生成
//   rlLoadExtensions — 需要 void* loader，Dart 侧不需要手动调用
//   rlLoadRenderBatch, rlUnloadRenderBatch, rlDrawRenderBatch,
//   rlSetRenderBatchActive — 需要 rlRenderBatch 包装类，暂不支持

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'structs.dart';

// ── Matrix operations ────────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlMatrixMode;
export 'src/raylib.g.dart' show rlPushMatrix;
export 'src/raylib.g.dart' show rlPopMatrix;
export 'src/raylib.g.dart' show rlLoadIdentity;
export 'src/raylib.g.dart' show rlTranslatef;
export 'src/raylib.g.dart' show rlRotatef;
export 'src/raylib.g.dart' show rlScalef;
// export 'src/raylib.g.dart' show rlMultMatrixf;         // → Dart wrapper below
export 'src/raylib.g.dart' show rlFrustum;
export 'src/raylib.g.dart' show rlOrtho;
export 'src/raylib.g.dart' show rlViewport;
export 'src/raylib.g.dart' show rlSetClipPlanes;
export 'src/raylib.g.dart' show rlGetCullDistanceNear;
export 'src/raylib.g.dart' show rlGetCullDistanceFar;

// ── Vertex level operations ──────────────────────────────────────────────
export 'src/raylib.g.dart' show rlBegin;
export 'src/raylib.g.dart' show rlEnd;
export 'src/raylib.g.dart' show rlVertex2i;
export 'src/raylib.g.dart' show rlVertex2f;
export 'src/raylib.g.dart' show rlVertex3f;
export 'src/raylib.g.dart' show rlTexCoord2f;
export 'src/raylib.g.dart' show rlNormal3f;
export 'src/raylib.g.dart' show rlColor4ub;
export 'src/raylib.g.dart' show rlColor3f;
export 'src/raylib.g.dart' show rlColor4f;

// ── OpenGL style functions (Vertex buffers state) ────────────────────────
export 'src/raylib.g.dart' show rlEnableVertexArray;
export 'src/raylib.g.dart' show rlDisableVertexArray;
export 'src/raylib.g.dart' show rlEnableVertexBuffer;
export 'src/raylib.g.dart' show rlDisableVertexBuffer;
export 'src/raylib.g.dart' show rlEnableVertexBufferElement;
export 'src/raylib.g.dart' show rlDisableVertexBufferElement;
export 'src/raylib.g.dart' show rlEnableVertexAttribute;
export 'src/raylib.g.dart' show rlDisableVertexAttribute;
// rlEnableStatePointer   — not available (OpenGL 1.1 only)
// rlDisableStatePointer  — not available (OpenGL 1.1 only)

// ── OpenGL style functions (Textures state) ──────────────────────────────
export 'src/raylib.g.dart' show rlActiveTextureSlot;
export 'src/raylib.g.dart' show rlEnableTexture;
export 'src/raylib.g.dart' show rlDisableTexture;
export 'src/raylib.g.dart' show rlEnableTextureCubemap;
export 'src/raylib.g.dart' show rlDisableTextureCubemap;
export 'src/raylib.g.dart' show rlTextureParameters;
export 'src/raylib.g.dart' show rlCubemapParameters;

// ── OpenGL style functions (Shader state) ────────────────────────────────
export 'src/raylib.g.dart' show rlEnableShader;
export 'src/raylib.g.dart' show rlDisableShader;

// ── OpenGL style functions (Framebuffer state) ───────────────────────────
export 'src/raylib.g.dart' show rlEnableFramebuffer;
export 'src/raylib.g.dart' show rlDisableFramebuffer;
export 'src/raylib.g.dart' show rlGetActiveFramebuffer;
export 'src/raylib.g.dart' show rlActiveDrawBuffers;
export 'src/raylib.g.dart' show rlBlitFramebuffer;
export 'src/raylib.g.dart' show rlBindFramebuffer;

// ── OpenGL style functions (General render state) ────────────────────────
export 'src/raylib.g.dart' show rlEnableColorBlend;
export 'src/raylib.g.dart' show rlDisableColorBlend;
export 'src/raylib.g.dart' show rlEnableDepthTest;
export 'src/raylib.g.dart' show rlDisableDepthTest;
export 'src/raylib.g.dart' show rlEnableDepthMask;
export 'src/raylib.g.dart' show rlDisableDepthMask;
export 'src/raylib.g.dart' show rlEnableBackfaceCulling;
export 'src/raylib.g.dart' show rlDisableBackfaceCulling;
export 'src/raylib.g.dart' show rlColorMask;
export 'src/raylib.g.dart' show rlSetCullFace;
export 'src/raylib.g.dart' show rlEnableScissorTest;
export 'src/raylib.g.dart' show rlDisableScissorTest;
export 'src/raylib.g.dart' show rlScissor;
export 'src/raylib.g.dart' show rlEnableWireMode;
export 'src/raylib.g.dart' show rlEnablePointMode;
export 'src/raylib.g.dart' show rlDisableWireMode;
export 'src/raylib.g.dart' show rlSetLineWidth;
export 'src/raylib.g.dart' show rlGetLineWidth;
export 'src/raylib.g.dart' show rlEnableSmoothLines;
export 'src/raylib.g.dart' show rlDisableSmoothLines;
export 'src/raylib.g.dart' show rlEnableStereoRender;
export 'src/raylib.g.dart' show rlDisableStereoRender;
export 'src/raylib.g.dart' show rlIsStereoRenderEnabled;
export 'src/raylib.g.dart' show rlClearColor;
export 'src/raylib.g.dart' show rlClearScreenBuffers;
export 'src/raylib.g.dart' show rlCheckErrors;
export 'src/raylib.g.dart' show rlSetBlendMode;
export 'src/raylib.g.dart' show rlSetBlendFactors;
export 'src/raylib.g.dart' show rlSetBlendFactorsSeparate;

// ── rlgl initialization ─────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlglInit;
export 'src/raylib.g.dart' show rlglClose;
// export 'src/raylib.g.dart' show rlLoadExtensions;      // Dart 侧不需要手动调用
export 'src/raylib.g.dart' show rlGetVersion;
export 'src/raylib.g.dart' show rlSetFramebufferWidth;
export 'src/raylib.g.dart' show rlGetFramebufferWidth;
export 'src/raylib.g.dart' show rlSetFramebufferHeight;
export 'src/raylib.g.dart' show rlGetFramebufferHeight;
export 'src/raylib.g.dart' show rlGetTextureIdDefault;
export 'src/raylib.g.dart' show rlGetShaderIdDefault;
// export 'src/raylib.g.dart' show rlGetShaderLocsDefault; // → Dart wrapper below

// ── Render batch management ─────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadRenderBatch;      // 需要 rlRenderBatch 包装类
// export 'src/raylib.g.dart' show rlUnloadRenderBatch;     // 需要 rlRenderBatch 包装类
// export 'src/raylib.g.dart' show rlDrawRenderBatch;       // 需要 rlRenderBatch 包装类
// export 'src/raylib.g.dart' show rlSetRenderBatchActive;  // 需要 rlRenderBatch 包装类
export 'src/raylib.g.dart' show rlDrawRenderBatchActive;
export 'src/raylib.g.dart' show rlCheckRenderBatchLimit;
export 'src/raylib.g.dart' show rlSetTexture;

// ── Vertex buffers management ───────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadVertexArray;
// export 'src/raylib.g.dart' show rlLoadVertexBuffer;              // → Dart wrapper below
// export 'src/raylib.g.dart' show rlLoadVertexBufferElement;       // → Dart wrapper below
// export 'src/raylib.g.dart' show rlUpdateVertexBuffer;            // → Dart wrapper below
// export 'src/raylib.g.dart' show rlUpdateVertexBufferElements;    // → Dart wrapper below
export 'src/raylib.g.dart' show rlUnloadVertexArray;
export 'src/raylib.g.dart' show rlUnloadVertexBuffer;
export 'src/raylib.g.dart' show rlSetVertexAttribute;
export 'src/raylib.g.dart' show rlSetVertexAttributeDivisor;
// export 'src/raylib.g.dart' show rlSetVertexAttributeDefault;     // → Dart wrapper below
export 'src/raylib.g.dart' show rlDrawVertexArray;
// export 'src/raylib.g.dart' show rlDrawVertexArrayElements;       // → Dart wrapper below
export 'src/raylib.g.dart' show rlDrawVertexArrayInstanced;
// export 'src/raylib.g.dart' show rlDrawVertexArrayElementsInstanced; // → Dart wrapper below

// ── Textures management ─────────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadTexture;           // → Dart wrapper below
export 'src/raylib.g.dart' show rlLoadTextureDepth;
// export 'src/raylib.g.dart' show rlLoadTextureCubemap;    // → Dart wrapper below
// export 'src/raylib.g.dart' show rlUpdateTexture;         // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetGlTextureFormats;   // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetPixelFormatName;    // → Dart wrapper below
export 'src/raylib.g.dart' show rlUnloadTexture;
// export 'src/raylib.g.dart' show rlGenTextureMipmaps;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlReadTexturePixels;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlReadScreenPixels;      // → Dart wrapper below

// ── Framebuffer management ──────────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadFramebuffer;
export 'src/raylib.g.dart' show rlFramebufferAttach;
export 'src/raylib.g.dart' show rlFramebufferComplete;
export 'src/raylib.g.dart' show rlUnloadFramebuffer;

// ── Shaders management ──────────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlLoadShaderCode;        // → Dart wrapper below
// export 'src/raylib.g.dart' show rlCompileShader;         // → Dart wrapper below
export 'src/raylib.g.dart' show rlLoadShaderProgram;
export 'src/raylib.g.dart' show rlUnloadShaderProgram;
// export 'src/raylib.g.dart' show rlGetLocationUniform;    // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetLocationAttrib;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetUniform;            // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetUniformMatrix;      // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetUniformMatrices;    // → Dart wrapper below
export 'src/raylib.g.dart' show rlSetUniformSampler;
// export 'src/raylib.g.dart' show rlSetShader;             // → Dart wrapper below

// ── Compute shader management ───────────────────────────────────────────
export 'src/raylib.g.dart' show rlLoadComputeShaderProgram;
export 'src/raylib.g.dart' show rlComputeShaderDispatch;

// ── Shader buffer storage object management (SSBO) ──────────────────────
// export 'src/raylib.g.dart' show rlLoadShaderBuffer;      // → Dart wrapper below
export 'src/raylib.g.dart' show rlUnloadShaderBuffer;
// export 'src/raylib.g.dart' show rlUpdateShaderBuffer;    // → Dart wrapper below
export 'src/raylib.g.dart' show rlBindShaderBuffer;
// export 'src/raylib.g.dart' show rlReadShaderBuffer;      // → Dart wrapper below
export 'src/raylib.g.dart' show rlCopyShaderBuffer;
export 'src/raylib.g.dart' show rlGetShaderBufferSize;

// ── Buffer management ───────────────────────────────────────────────────
export 'src/raylib.g.dart' show rlBindImageTexture;

// ── Matrix state management ─────────────────────────────────────────────
// export 'src/raylib.g.dart' show rlGetMatrixModelview;            // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetMatrixProjection;           // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetMatrixTransform;            // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetMatrixProjectionStereo;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlGetMatrixViewOffsetStereo;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetMatrixProjection;           // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetMatrixModelview;            // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetMatrixProjectionStereo;     // → Dart wrapper below
// export 'src/raylib.g.dart' show rlSetMatrixViewOffsetStereo;     // → Dart wrapper below

// ── Quick and dirty cube/quad buffers ───────────────────────────────────
export 'src/raylib.g.dart' show rlLoadDrawCube;
export 'src/raylib.g.dart' show rlLoadDrawQuad;

// ═════════════════════════════════════════════════════════════════════════
// Dart wrappers for functions that require pointer / Matrix / string
// conversion. Organized in the same order as the exports above.
// ═════════════════════════════════════════════════════════════════════════

// ── Matrix operations ────────────────────────────────────────────────────

void rlMultMatrixf(Matrix4 mat) => ffi.using((arena) {
  final s = mat.storage;
  final ptr = arena<Float>(16);
  for (var i = 0; i < 16; i++) {
    ptr[i] = s[i];
  }
  raylib.rlMultMatrixf(ptr);
});

// ── rlgl initialization ─────────────────────────────────────────────────

Pointer<Int> rlGetShaderLocsDefault() => raylib.rlGetShaderLocsDefault();

// ── Vertex buffers management ───────────────────────────────────────────

int rlLoadVertexBuffer(Uint8List buffer, bool dynamic) => ffi.using((arena) {
  final ptr = arena<Uint8>(buffer.length);
  ptr.asTypedList(buffer.length).setAll(0, buffer);
  return raylib.rlLoadVertexBuffer(ptr.cast(), buffer.length, dynamic);
});

int rlLoadVertexBufferElement(Uint8List buffer, bool dynamic) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(buffer.length);
  ptr.asTypedList(buffer.length).setAll(0, buffer);
  return raylib.rlLoadVertexBufferElement(ptr.cast(), buffer.length, dynamic);
});

void rlUpdateVertexBuffer(int bufferId, Uint8List data, int offset) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  raylib.rlUpdateVertexBuffer(bufferId, ptr.cast(), data.length, offset);
});

void rlUpdateVertexBufferElements(int id, Uint8List data, int offset) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  raylib.rlUpdateVertexBufferElements(id, ptr.cast(), data.length, offset);
});

void rlSetVertexAttributeDefault(
  int locIndex, TypedData value, int attribType, int count,
) => ffi.using((arena) {
  final bytes = value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raylib.rlSetVertexAttributeDefault(locIndex, ptr.cast(), attribType, count);
});

void rlDrawVertexArrayElements(int offset, int count, Uint8List buffer) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(buffer.length);
  ptr.asTypedList(buffer.length).setAll(0, buffer);
  raylib.rlDrawVertexArrayElements(offset, count, ptr.cast());
});

void rlDrawVertexArrayElementsInstanced(
  int offset, int count, Uint8List buffer, int instances,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(buffer.length);
  ptr.asTypedList(buffer.length).setAll(0, buffer);
  raylib.rlDrawVertexArrayElementsInstanced(
    offset, count, ptr.cast(), instances,
  );
});

// ── Textures management ─────────────────────────────────────────────────

int rlLoadTexture(
  Uint8List data, int width, int height, int format, int mipmapCount,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return raylib.rlLoadTexture(ptr.cast(), width, height, format, mipmapCount);
});

int rlLoadTextureCubemap(
  Uint8List data, int size, int format, int mipmapCount,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return raylib.rlLoadTextureCubemap(ptr.cast(), size, format, mipmapCount);
});

void rlUpdateTexture(
  int id, int offsetX, int offsetY,
  int width, int height, int format, Uint8List data,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  raylib.rlUpdateTexture(id, offsetX, offsetY, width, height, format, ptr.cast());
});

({int glInternalFormat, int glFormat, int glType}) rlGetGlTextureFormats(
  int format,
) => ffi.using((arena) {
  final glInternalFormat = arena<UnsignedInt>();
  final glFormat = arena<UnsignedInt>();
  final glType = arena<UnsignedInt>();
  raylib.rlGetGlTextureFormats(format, glInternalFormat, glFormat, glType);
  return (
    glInternalFormat: glInternalFormat.value,
    glFormat: glFormat.value,
    glType: glType.value,
  );
});

String rlGetPixelFormatName(int format) =>
    raylib.rlGetPixelFormatName(format).cast<ffi.Utf8>().toDartString();

int rlGenTextureMipmaps(int id, int width, int height, int format) =>
    ffi.using((arena) {
  final mipmaps = arena<Int>();
  raylib.rlGenTextureMipmaps(id, width, height, format, mipmaps);
  return mipmaps.value;
});

Uint8List rlReadTexturePixels(int id, int width, int height, int format) {
  final ptr = raylib.rlReadTexturePixels(id, width, height, format);
  final size = raylib.GetPixelDataSize(width, height, format);
  final result = Uint8List.fromList(ptr.cast<Uint8>().asTypedList(size));
  ffi.malloc.free(ptr);
  return result;
}

Uint8List rlReadScreenPixels(int width, int height) {
  final ptr = raylib.rlReadScreenPixels(width, height);
  final size = width * height * 4; // RGBA
  final result = Uint8List.fromList(ptr.cast<Uint8>().asTypedList(size));
  ffi.malloc.free(ptr);
  return result;
}

// ── Shaders management ──────────────────────────────────────────────────

int rlLoadShaderCode(String? vsCode, String? fsCode) => ffi.using((arena) {
  return raylib.rlLoadShaderCode(
    vsCode?.toNativeUtf8(allocator: arena).cast() ?? nullptr,
    fsCode?.toNativeUtf8(allocator: arena).cast() ?? nullptr,
  );
});

int rlCompileShader(String shaderCode, int type) => ffi.using((arena) {
  return raylib.rlCompileShader(
    shaderCode.toNativeUtf8(allocator: arena).cast(), type,
  );
});

int rlGetLocationUniform(int shaderId, String uniformName) =>
    ffi.using((arena) {
  return raylib.rlGetLocationUniform(
    shaderId, uniformName.toNativeUtf8(allocator: arena).cast(),
  );
});

int rlGetLocationAttrib(int shaderId, String attribName) =>
    ffi.using((arena) {
  return raylib.rlGetLocationAttrib(
    shaderId, attribName.toNativeUtf8(allocator: arena).cast(),
  );
});

void rlSetUniform(int locIndex, TypedData value, int uniformType, int count) =>
    ffi.using((arena) {
  final bytes = value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raylib.rlSetUniform(locIndex, ptr.cast(), uniformType, count);
});

void rlSetUniformMatrix(int locIndex, Matrix4 mat) => ffi.using((arena) {
  raylib.rlSetUniformMatrix(locIndex, arena.matrix4(mat).ref);
});

void rlSetUniformMatrices(int locIndex, List<Matrix4> mat) =>
    ffi.using((arena) {
  raylib.rlSetUniformMatrices(locIndex, arena.matrix4s(mat), mat.length);
});

void rlSetShader(int id, Pointer<Int> locs) => raylib.rlSetShader(id, locs);

// ── Shader buffer storage object management (SSBO) ──────────────────────

int rlLoadShaderBuffer(int size, Uint8List? data, int usageHint) =>
    ffi.using((arena) {
  if (data != null) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    return raylib.rlLoadShaderBuffer(size, ptr.cast(), usageHint);
  }
  return raylib.rlLoadShaderBuffer(size, nullptr, usageHint);
});

void rlUpdateShaderBuffer(int id, Uint8List data, int offset) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  raylib.rlUpdateShaderBuffer(id, ptr.cast(), data.length, offset);
});

Uint8List rlReadShaderBuffer(int id, int count, int offset) =>
    ffi.using((arena) {
  final ptr = arena<Uint8>(count);
  raylib.rlReadShaderBuffer(id, ptr.cast(), count, offset);
  return Uint8List.fromList(ptr.asTypedList(count));
});

// ── Matrix state management ─────────────────────────────────────────────

Matrix4 rlGetMatrixModelview() => raylib.rlGetMatrixModelview().toDart();

Matrix4 rlGetMatrixProjection() => raylib.rlGetMatrixProjection().toDart();

Matrix4 rlGetMatrixTransform() => raylib.rlGetMatrixTransform().toDart();

Matrix4 rlGetMatrixProjectionStereo(int eye) =>
    raylib.rlGetMatrixProjectionStereo(eye).toDart();

Matrix4 rlGetMatrixViewOffsetStereo(int eye) =>
    raylib.rlGetMatrixViewOffsetStereo(eye).toDart();

void rlSetMatrixProjection(Matrix4 proj) => ffi.using((arena) {
  raylib.rlSetMatrixProjection(arena.matrix4(proj).ref);
});

void rlSetMatrixModelview(Matrix4 view) => ffi.using((arena) {
  raylib.rlSetMatrixModelview(arena.matrix4(view).ref);
});

void rlSetMatrixProjectionStereo(Matrix4 right, Matrix4 left) =>
    ffi.using((arena) {
  raylib.rlSetMatrixProjectionStereo(
    arena.matrix4(right).ref, arena.matrix4(left).ref,
  );
});

void rlSetMatrixViewOffsetStereo(Matrix4 right, Matrix4 left) =>
    ffi.using((arena) {
  raylib.rlSetMatrixViewOffsetStereo(
    arena.matrix4(right).ref, arena.matrix4(left).ref,
  );
});
