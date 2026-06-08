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

void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color) =>
    ffi.using((arena) {
      raw.DrawLine3D(
        arena.vector3(startPos).ref,
        arena.vector3(endPos).ref,
        color.ptr.ref,
      );
    });

void DrawPoint3D(Vector3 position, Color color) => ffi.using((arena) {
  raw.DrawPoint3D(arena.vector3(position).ref, color.ptr.ref);
});

void DrawCircle3D(
  Vector3 center,
  double radius,
  Vector3 rotationAxis,
  double rotationAngle,
  Color color,
) => ffi.using((arena) {
  raw.DrawCircle3D(
    arena.vector3(center).ref,
    radius,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    color.ptr.ref,
  );
});

void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color) =>
    ffi.using((arena) {
      raw.DrawTriangle3D(
        arena.vector3(v1).ref,
        arena.vector3(v2).ref,
        arena.vector3(v3).ref,
        color.ptr.ref,
      );
    });

void DrawTriangleStrip3D(List<Vector3> points, Color color) => ffi.using((
  arena,
) {
  raw.DrawTriangleStrip3D(arena.vector3s(points), points.length, color.ptr.ref);
});

void DrawCube(
  Vector3 position,
  double width,
  double height,
  double length,
  Color color,
) => ffi.using((arena) {
  raw.DrawCube(
    arena.vector3(position).ref,
    width,
    height,
    length,
    color.ptr.ref,
  );
});

void DrawCubeV(Vector3 position, Vector3 size, Color color) =>
    ffi.using((arena) {
      raw.DrawCubeV(
        arena.vector3(position).ref,
        arena.vector3(size).ref,
        color.ptr.ref,
      );
    });

void DrawCubeWires(
  Vector3 position,
  double width,
  double height,
  double length,
  Color color,
) => ffi.using((arena) {
  raw.DrawCubeWires(
    arena.vector3(position).ref,
    width,
    height,
    length,
    color.ptr.ref,
  );
});

void DrawCubeWiresV(Vector3 position, Vector3 size, Color color) =>
    ffi.using((arena) {
      raw.DrawCubeWiresV(
        arena.vector3(position).ref,
        arena.vector3(size).ref,
        color.ptr.ref,
      );
    });

void DrawSphere(Vector3 centerPos, double radius, Color color) =>
    ffi.using((arena) {
      raw.DrawSphere(arena.vector3(centerPos).ref, radius, color.ptr.ref);
    });

void DrawSphereEx(
  Vector3 centerPos,
  double radius,
  int rings,
  int slices,
  Color color,
) => ffi.using((arena) {
  raw.DrawSphereEx(
    arena.vector3(centerPos).ref,
    radius,
    rings,
    slices,
    color.ptr.ref,
  );
});

void DrawSphereWires(
  Vector3 centerPos,
  double radius,
  int rings,
  int slices,
  Color color,
) => ffi.using((arena) {
  raw.DrawSphereWires(
    arena.vector3(centerPos).ref,
    radius,
    rings,
    slices,
    color.ptr.ref,
  );
});

void DrawCylinder(
  Vector3 position,
  double radiusTop,
  double radiusBottom,
  double height,
  int slices,
  Color color,
) => ffi.using((arena) {
  raw.DrawCylinder(
    arena.vector3(position).ref,
    radiusTop,
    radiusBottom,
    height,
    slices,
    color.ptr.ref,
  );
});

void DrawCylinderEx(
  Vector3 startPos,
  Vector3 endPos,
  double startRadius,
  double endRadius,
  int sides,
  Color color,
) => ffi.using((arena) {
  raw.DrawCylinderEx(
    arena.vector3(startPos).ref,
    arena.vector3(endPos).ref,
    startRadius,
    endRadius,
    sides,
    color.ptr.ref,
  );
});

void DrawCylinderWires(
  Vector3 position,
  double radiusTop,
  double radiusBottom,
  double height,
  int slices,
  Color color,
) => ffi.using((arena) {
  raw.DrawCylinderWires(
    arena.vector3(position).ref,
    radiusTop,
    radiusBottom,
    height,
    slices,
    color.ptr.ref,
  );
});

void DrawCylinderWiresEx(
  Vector3 startPos,
  Vector3 endPos,
  double startRadius,
  double endRadius,
  int sides,
  Color color,
) => ffi.using((arena) {
  raw.DrawCylinderWiresEx(
    arena.vector3(startPos).ref,
    arena.vector3(endPos).ref,
    startRadius,
    endRadius,
    sides,
    color.ptr.ref,
  );
});

void DrawCapsule(
  Vector3 startPos,
  Vector3 endPos,
  double radius,
  int slices,
  int rings,
  Color color,
) => ffi.using((arena) {
  raw.DrawCapsule(
    arena.vector3(startPos).ref,
    arena.vector3(endPos).ref,
    radius,
    slices,
    rings,
    color.ptr.ref,
  );
});

void DrawCapsuleWires(
  Vector3 startPos,
  Vector3 endPos,
  double radius,
  int slices,
  int rings,
  Color color,
) => ffi.using((arena) {
  raw.DrawCapsuleWires(
    arena.vector3(startPos).ref,
    arena.vector3(endPos).ref,
    radius,
    slices,
    rings,
    color.ptr.ref,
  );
});

void DrawPlane(Vector3 centerPos, Vector2 size, Color color) =>
    ffi.using((arena) {
      raw.DrawPlane(
        arena.vector3(centerPos).ref,
        arena.vector2(size).ref,
        color.ptr.ref,
      );
    });

void DrawRay(Ray ray, Color color) => ffi.using((arena) {
  raw.DrawRay(arena.ray(ray).ref, color.ptr.ref);
});

Model LoadModel(String fileName) => ffi.using((arena) {
  return raw.LoadModel(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Model LoadModelFromMesh(Mesh mesh) =>
    raw.LoadModelFromMesh(mesh.ptr.ref).toDart();

bool IsModelValid(Model model) => raw.IsModelValid(model.ptr.ref);

void UnloadModel(Model model) => model.dispose();

BoundingBox GetModelBoundingBox(Model model) =>
    raw.GetModelBoundingBox(model.ptr.ref).toDart();

void DrawModel(Model model, Vector3 position, double scale, Color tint) =>
    ffi.using((arena) {
      raw.DrawModel(
        model.ptr.ref,
        arena.vector3(position).ref,
        scale,
        tint.ptr.ref,
      );
    });

void DrawModelEx(
  Model model,
  Vector3 position,
  Vector3 rotationAxis,
  double rotationAngle,
  Vector3 scale,
  Color tint,
) => ffi.using((arena) {
  raw.DrawModelEx(
    model.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    arena.vector3(scale).ref,
    tint.ptr.ref,
  );
});

void DrawModelWires(Model model, Vector3 position, double scale, Color tint) =>
    ffi.using((arena) {
      raw.DrawModelWires(
        model.ptr.ref,
        arena.vector3(position).ref,
        scale,
        tint.ptr.ref,
      );
    });

void DrawModelWiresEx(
  Model model,
  Vector3 position,
  Vector3 rotationAxis,
  double rotationAngle,
  Vector3 scale,
  Color tint,
) => ffi.using((arena) {
  raw.DrawModelWiresEx(
    model.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    arena.vector3(scale).ref,
    tint.ptr.ref,
  );
});

void DrawBoundingBox(BoundingBox box, Color color) => ffi.using((arena) {
  raw.DrawBoundingBox(arena.boundingBox(box).ref, color.ptr.ref);
});

void DrawBillboard(
  Camera camera,
  Texture2D texture,
  Vector3 position,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raw.DrawBillboard(
    camera.ptr.ref,
    arena.texture(texture).ref,
    arena.vector3(position).ref,
    scale,
    tint.ptr.ref,
  );
});

void DrawBillboardRec(
  Camera camera,
  Texture2D texture,
  Rectangle source,
  Vector3 position,
  Vector2 size,
  Color tint,
) => ffi.using((arena) {
  raw.DrawBillboardRec(
    camera.ptr.ref,
    arena.texture(texture).ref,
    source.ptr.ref,
    arena.vector3(position).ref,
    arena.vector2(size).ref,
    tint.ptr.ref,
  );
});

void DrawBillboardPro(
  Camera camera,
  Texture2D texture,
  Rectangle source,
  Vector3 position,
  Vector3 up,
  Vector2 size,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raw.DrawBillboardPro(
    camera.ptr.ref,
    arena.texture(texture).ref,
    source.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(up).ref,
    arena.vector2(size).ref,
    arena.vector2(origin).ref,
    rotation,
    tint.ptr.ref,
  );
});

void UploadMesh(Mesh mesh, bool dynamic) => raw.UploadMesh(mesh.ptr, dynamic);

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

void UnloadMesh(Mesh mesh) => mesh.dispose();

void DrawMesh(Mesh mesh, Material material, Matrix4 transform) => ffi.using((
  arena,
) {
  raw.DrawMesh(mesh.ptr.ref, material.ptr.ref, arena.matrix4(transform).ref);
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

BoundingBox GetMeshBoundingBox(Mesh mesh) =>
    raw.GetMeshBoundingBox(mesh.ptr.ref).toDart();

void GenMeshTangents(Mesh mesh) => raw.GenMeshTangents(mesh.ptr);

bool ExportMesh(Mesh mesh, String fileName) => ffi.using((arena) {
  return raw.ExportMesh(
    mesh.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

bool ExportMeshAsCode(Mesh mesh, String fileName) => ffi.using((arena) {
  return raw.ExportMeshAsCode(
    mesh.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

Mesh GenMeshPoly(int sides, double radius) =>
    raw.GenMeshPoly(sides, radius).toDart();

Mesh GenMeshPlane(double width, double length, int resX, int resZ) =>
    raw.GenMeshPlane(width, length, resX, resZ).toDart();

Mesh GenMeshCube(double width, double height, double length) =>
    raw.GenMeshCube(width, height, length).toDart();

Mesh GenMeshSphere(double radius, int rings, int slices) =>
    raw.GenMeshSphere(radius, rings, slices).toDart();

Mesh GenMeshHemiSphere(double radius, int rings, int slices) =>
    raw.GenMeshHemiSphere(radius, rings, slices).toDart();

Mesh GenMeshCylinder(double radius, double height, int slices) =>
    raw.GenMeshCylinder(radius, height, slices).toDart();

Mesh GenMeshCone(double radius, double height, int slices) =>
    raw.GenMeshCone(radius, height, slices).toDart();

Mesh GenMeshTorus(double radius, double size, int radSeg, int sides) =>
    raw.GenMeshTorus(radius, size, radSeg, sides).toDart();

Mesh GenMeshKnot(double radius, double size, int radSeg, int sides) =>
    raw.GenMeshKnot(radius, size, radSeg, sides).toDart();

Mesh GenMeshHeightmap(Image heightmap, Vector3 size) => ffi.using((arena) {
  return raw.GenMeshHeightmap(
    heightmap.ptr.ref,
    arena.vector3(size).ref,
  ).toDart();
});

Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize) => ffi.using((arena) {
  return raw.GenMeshCubicmap(
    cubicmap.ptr.ref,
    arena.vector3(cubeSize).ref,
  ).toDart();
});

List<Material> LoadMaterials(String fileName) => ffi.using((arena) {
  final count = arena<Int>();
  final ptr = raw.LoadMaterials(
    fileName.toNativeUtf8(allocator: arena).cast(),
    count,
  );
  return [for (var i = 0; i < count.value; i++) ptr[i].toDart()];
});

Material LoadMaterialDefault() => raw.LoadMaterialDefault().toDart();

bool IsMaterialValid(Material material) =>
    raw.IsMaterialValid(material.ptr.ref);

void UnloadMaterial(Material material) => material.dispose();

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

void UpdateModelAnimation(Model model, ModelAnimation anim, double frame) =>
    ffi.using((arena) {
      raw.UpdateModelAnimation(
        model.ptr.ref,
        arena.modelAnimation(anim).ref,
        frame,
      );
    });

void UpdateModelAnimationEx(
  Model model,
  ModelAnimation animA,
  double frameA,
  ModelAnimation animB,
  double frameB,
  double blend,
) => ffi.using((arena) {
  raw.UpdateModelAnimationEx(
    model.ptr.ref,
    arena.modelAnimation(animA).ref,
    frameA,
    arena.modelAnimation(animB).ref,
    frameB,
    blend,
  );
});

void UnloadModelAnimations(List<ModelAnimation> animations) {}

bool IsModelAnimationValid(Model model, ModelAnimation anim) =>
    ffi.using((arena) {
      return raw.IsModelAnimationValid(
        model.ptr.ref,
        arena.modelAnimation(anim).ref,
      );
    });

bool CheckCollisionSpheres(
  Vector3 center1,
  double radius1,
  Vector3 center2,
  double radius2,
) => ffi.using((arena) {
  return raw.CheckCollisionSpheres(
    arena.vector3(center1).ref,
    radius1,
    arena.vector3(center2).ref,
    radius2,
  );
});

bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2) =>
    ffi.using((arena) {
      return raw.CheckCollisionBoxes(
        arena.boundingBox(box1).ref,
        arena.boundingBox(box2).ref,
      );
    });

bool CheckCollisionBoxSphere(BoundingBox box, Vector3 center, double radius) =>
    ffi.using((arena) {
      return raw.CheckCollisionBoxSphere(
        arena.boundingBox(box).ref,
        arena.vector3(center).ref,
        radius,
      );
    });

RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, double radius) =>
    ffi.using((arena) {
      return raw.GetRayCollisionSphere(
        arena.ray(ray).ref,
        arena.vector3(center).ref,
        radius,
      ).toDart();
    });

RayCollision GetRayCollisionBox(Ray ray, BoundingBox box) => ffi.using((arena) {
  return raw.GetRayCollisionBox(
    arena.ray(ray).ref,
    arena.boundingBox(box).ref,
  ).toDart();
});

RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix4 transform) =>
    ffi.using((arena) {
      return raw.GetRayCollisionMesh(
        arena.ray(ray).ref,
        mesh.ptr.ref,
        arena.matrix4(transform).ref,
      ).toDart();
    });

RayCollision GetRayCollisionTriangle(
  Ray ray,
  Vector3 p1,
  Vector3 p2,
  Vector3 p3,
) => ffi.using((arena) {
  return raw.GetRayCollisionTriangle(
    arena.ray(ray).ref,
    arena.vector3(p1).ref,
    arena.vector3(p2).ref,
    arena.vector3(p3).ref,
  ).toDart();
});

RayCollision GetRayCollisionQuad(
  Ray ray,
  Vector3 p1,
  Vector3 p2,
  Vector3 p3,
  Vector3 p4,
) => ffi.using((arena) {
  return raw.GetRayCollisionQuad(
    arena.ray(ray).ref,
    arena.vector3(p1).ref,
    arena.vector3(p2).ref,
    arena.vector3(p3).ref,
    arena.vector3(p4).ref,
  ).toDart();
});
