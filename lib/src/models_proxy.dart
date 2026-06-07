// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'structs.dart';

Pointer<Uint8> _bytes(ffi.Arena arena, Uint8List data) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return ptr;
}

void DrawTriangleStrip3D(List<Vector3> points, Color color) => ffi.using((
  arena,
) {
  raw.DrawTriangleStrip3D(arena.vector3s(points), points.length, color.ptr.ref);
});

void UpdateMeshBuffer(Mesh mesh, int index, Uint8List data, int offset) =>
    ffi.using((arena) {
      raw.UpdateMeshBuffer(
        mesh.ptr.ref,
        index,
        _bytes(arena, data).cast(),
        data.length,
        offset,
      );
    });

void DrawMeshInstanced(
  Mesh mesh,
  Material material,
  List<Matrix4> transforms,
) => ffi.using((arena) {
  raw.DrawMeshInstanced(
    mesh.ptr.ref,
    material.ptr.ref,
    arena.matrix4s(transforms),
    transforms.length,
  );
});

List<Material> LoadMaterials(String fileName) => ffi.using((arena) {
  final count = arena<Int>();
  final ptr = raw.LoadMaterials(
    fileName.toNativeUtf8(allocator: arena).cast(),
    count,
  );
  return [for (var i = 0; i < count.value; i++) ptr[i].toDart()];
});

void SetMaterialTexture(Material material, int mapType, Texture2D texture) =>
    ffi.using((arena) {
      raw.SetMaterialTexture(material.ptr, mapType, arena.texture(texture).ref);
    });

void SetModelMeshMaterial(Model model, int meshId, int materialId) =>
    raw.SetModelMeshMaterial(model.ptr, meshId, materialId);

List<ModelAnimation> LoadModelAnimations(String fileName) => ffi.using((arena) {
  final count = arena<Int>();
  final ptr = raw.LoadModelAnimations(
    fileName.toNativeUtf8(allocator: arena).cast(),
    count,
  );
  final result = [for (var i = 0; i < count.value; i++) ptr[i].toDart()];
  raw.UnloadModelAnimations(ptr, count.value);
  return result;
});

void UnloadModelAnimations(List<ModelAnimation> animations) {}
