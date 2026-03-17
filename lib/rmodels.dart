// ignore_for_file: non_constant_identifier_names
//
// 本文件封装 raylib 3D 模型模块。

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';

// ── Basic geometric 3D shapes ────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawLine3D;              // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawPoint3D;             // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCircle3D;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTriangle3D;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawTriangleStrip3D;     // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCube;                // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCubeV;               // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCubeWires;           // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCubeWiresV;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawSphere;              // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawSphereEx;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawSphereWires;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCylinder;            // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCylinderEx;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCylinderWires;       // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCylinderWiresEx;     // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCapsule;             // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawCapsuleWires;        // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawPlane;               // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawRay;                 // → Dart wrapper below
export 'src/raylib.g.dart' show DrawGrid;

// ── Model management ─────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadModel;               // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadModelFromMesh;       // → Dart wrapper below
// export 'src/raylib.g.dart' show IsModelValid;            // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadModel;             // → model.dispose()
// export 'src/raylib.g.dart' show GetModelBoundingBox;     // → Dart wrapper below

// ── Model drawing ────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawModel;               // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawModelEx;             // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawModelWires;          // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawModelWiresEx;        // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawModelPoints;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawModelPointsEx;       // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawBoundingBox;         // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawBillboard;           // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawBillboardRec;        // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawBillboardPro;        // → Dart wrapper below

// ── Mesh management ──────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show UploadMesh;              // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateMeshBuffer;        // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadMesh;              // → mesh.dispose()
// export 'src/raylib.g.dart' show DrawMesh;                // → Dart wrapper below
// export 'src/raylib.g.dart' show DrawMeshInstanced;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GetMeshBoundingBox;      // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshTangents;         // → Dart wrapper below
// export 'src/raylib.g.dart' show ExportMesh;              // → Dart wrapper below
// export 'src/raylib.g.dart' show ExportMeshAsCode;        // → Dart wrapper below

// ── Mesh generation ──────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show GenMeshPoly;             // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshPlane;            // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshCube;             // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshSphere;           // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshHemiSphere;       // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshCylinder;         // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshCone;             // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshTorus;            // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshKnot;             // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshHeightmap;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GenMeshCubicmap;         // → Dart wrapper below

// ── Material loading/unloading ───────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadMaterials;           // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadMaterialDefault;     // → Dart wrapper below
// export 'src/raylib.g.dart' show IsMaterialValid;         // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadMaterial;          // → material.dispose()
// export 'src/raylib.g.dart' show SetMaterialTexture;      // → Dart wrapper below
// export 'src/raylib.g.dart' show SetModelMeshMaterial;    // → Dart wrapper below

// ── Model animations ─────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadModelAnimations;       // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateModelAnimation;      // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateModelAnimationBones; // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadModelAnimation;      // → anim.dispose()
// export 'src/raylib.g.dart' show UnloadModelAnimations;     // → Dart wrapper below
// export 'src/raylib.g.dart' show IsModelAnimationValid;     // → Dart wrapper below

// ── Collision detection ──────────────────────────────────────────────────
// export 'src/raylib.g.dart' show CheckCollisionSpheres;   // → Dart wrapper below
// export 'src/raylib.g.dart' show CheckCollisionBoxes;     // → Dart wrapper below
// export 'src/raylib.g.dart' show CheckCollisionBoxSphere; // → Dart wrapper below
// export 'src/raylib.g.dart' show GetRayCollisionSphere;   // → Dart wrapper below
// export 'src/raylib.g.dart' show GetRayCollisionBox;      // → Dart wrapper below
// export 'src/raylib.g.dart' show GetRayCollisionMesh;     // → Dart wrapper below
// export 'src/raylib.g.dart' show GetRayCollisionTriangle; // → Dart wrapper below
// export 'src/raylib.g.dart' show GetRayCollisionQuad;     // → Dart wrapper below

// ── Basic geometric 3D shapes ────────────────────────────────────────────

void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color) =>
    ffi.using((arena) {
      raylib.DrawLine3D(
        arena.vector3(startPos).ref,
        arena.vector3(endPos).ref,
        color.ptr.ref,
      );
    });

void DrawPoint3D(Vector3 position, Color color) => ffi.using((arena) {
  raylib.DrawPoint3D(arena.vector3(position).ref, color.ptr.ref);
});

void DrawCircle3D(
  Vector3 center,
  double radius,
  Vector3 rotationAxis,
  double rotationAngle,
  Color color,
) => ffi.using((arena) {
  raylib.DrawCircle3D(
    arena.vector3(center).ref,
    radius,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    color.ptr.ref,
  );
});

void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangle3D(
        arena.vector3(v1).ref,
        arena.vector3(v2).ref,
        arena.vector3(v3).ref,
        color.ptr.ref,
      );
    });

void DrawTriangleStrip3D(List<Vector3> points, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangleStrip3D(
        arena.vector3s(points),
        points.length,
        color.ptr.ref,
      );
    });

void DrawCube(
  Vector3 position,
  double width,
  double height,
  double length,
  Color color,
) => ffi.using((arena) {
  raylib.DrawCube(
    arena.vector3(position).ref,
    width,
    height,
    length,
    color.ptr.ref,
  );
});

void DrawCubeV(Vector3 position, Vector3 size, Color color) =>
    ffi.using((arena) {
      raylib.DrawCubeV(
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
  raylib.DrawCubeWires(
    arena.vector3(position).ref,
    width,
    height,
    length,
    color.ptr.ref,
  );
});

void DrawCubeWiresV(Vector3 position, Vector3 size, Color color) =>
    ffi.using((arena) {
      raylib.DrawCubeWiresV(
        arena.vector3(position).ref,
        arena.vector3(size).ref,
        color.ptr.ref,
      );
    });

void DrawSphere(Vector3 centerPos, double radius, Color color) =>
    ffi.using((arena) {
      raylib.DrawSphere(arena.vector3(centerPos).ref, radius, color.ptr.ref);
    });

void DrawSphereEx(
  Vector3 centerPos,
  double radius,
  int rings,
  int slices,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSphereEx(
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
  raylib.DrawSphereWires(
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
  raylib.DrawCylinder(
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
  raylib.DrawCylinderEx(
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
  raylib.DrawCylinderWires(
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
  raylib.DrawCylinderWiresEx(
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
  raylib.DrawCapsule(
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
  raylib.DrawCapsuleWires(
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
      raylib.DrawPlane(
        arena.vector3(centerPos).ref,
        arena.vector2(size).ref,
        color.ptr.ref,
      );
    });

void DrawRay(Ray ray, Color color) => ffi.using((arena) {
  raylib.DrawRay(arena.ray(ray).ref, color.ptr.ref);
});

// ── Model management ─────────────────────────────────────────────────────

Model LoadModel(String fileName) => ffi.using((arena) {
  return raylib.LoadModel(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Model LoadModelFromMesh(Mesh mesh) =>
    raylib.LoadModelFromMesh(mesh.ptr.ref).toDart();

bool IsModelValid(Model model) => raylib.IsModelValid(model.ptr.ref);

void UnloadModel(Model model) => model.dispose();

BoundingBox GetModelBoundingBox(Model model) =>
    raylib.GetModelBoundingBox(model.ptr.ref).toDart();

// ── Model drawing ────────────────────────────────────────────────────────

void DrawModel(Model model, Vector3 position, double scale, Color tint) =>
    ffi.using((arena) {
      raylib.DrawModel(
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
  raylib.DrawModelEx(
    model.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    arena.vector3(scale).ref,
    tint.ptr.ref,
  );
});

void DrawModelWires(
  Model model,
  Vector3 position,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawModelWires(
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
  raylib.DrawModelWiresEx(
    model.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    arena.vector3(scale).ref,
    tint.ptr.ref,
  );
});

void DrawModelPoints(
  Model model,
  Vector3 position,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawModelPoints(
    model.ptr.ref,
    arena.vector3(position).ref,
    scale,
    tint.ptr.ref,
  );
});

void DrawModelPointsEx(
  Model model,
  Vector3 position,
  Vector3 rotationAxis,
  double rotationAngle,
  Vector3 scale,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawModelPointsEx(
    model.ptr.ref,
    arena.vector3(position).ref,
    arena.vector3(rotationAxis).ref,
    rotationAngle,
    arena.vector3(scale).ref,
    tint.ptr.ref,
  );
});

void DrawBoundingBox(BoundingBox box, Color color) => ffi.using((arena) {
  raylib.DrawBoundingBox(arena.boundingBox(box).ref, color.ptr.ref);
});

void DrawBillboard(
  Camera3D camera,
  Texture2D texture,
  Vector3 position,
  double scale,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawBillboard(
    camera.ptr.ref,
    arena.texture(texture).ref,
    arena.vector3(position).ref,
    scale,
    tint.ptr.ref,
  );
});

void DrawBillboardRec(
  Camera3D camera,
  Texture2D texture,
  Rectangle source,
  Vector3 position,
  Vector2 size,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawBillboardRec(
    camera.ptr.ref,
    arena.texture(texture).ref,
    source.ptr.ref,
    arena.vector3(position).ref,
    arena.vector2(size).ref,
    tint.ptr.ref,
  );
});

void DrawBillboardPro(
  Camera3D camera,
  Texture2D texture,
  Rectangle source,
  Vector3 position,
  Vector3 up,
  Vector2 size,
  Vector2 origin,
  double rotation,
  Color tint,
) => ffi.using((arena) {
  raylib.DrawBillboardPro(
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

// ── Mesh management ──────────────────────────────────────────────────────

/// Uploads [mesh] vertex data to the GPU (sets vaoId/vboId in-place).
void UploadMesh(Mesh mesh, bool dynamic) =>
    raylib.UploadMesh(mesh.ptr, dynamic);

/// Replaces VBO [index] data in [mesh] with [data] starting at byte [offset].
void UpdateMeshBuffer(Mesh mesh, int index, Uint8List data, int offset) =>
    ffi.using((arena) {
      final ptr = arena<Uint8>(data.length);
      ptr.asTypedList(data.length).setAll(0, data);
      raylib.UpdateMeshBuffer(
        mesh.ptr.ref, index, ptr.cast(), data.length, offset,
      );
    });

void UnloadMesh(Mesh mesh) => mesh.dispose();

void DrawMesh(Mesh mesh, Material material, Matrix4 transform) =>
    ffi.using((arena) {
      raylib.DrawMesh(
        mesh.ptr.ref,
        material.ptr.ref,
        arena.matrix4(transform).ref,
      );
    });

/// [transforms] replaces the C `Matrix *transforms, int instances` pair.
void DrawMeshInstanced(
  Mesh mesh,
  Material material,
  List<Matrix4> transforms,
) => ffi.using((arena) {
  raylib.DrawMeshInstanced(
    mesh.ptr.ref,
    material.ptr.ref,
    arena.matrix4s(transforms),
    transforms.length,
  );
});

BoundingBox GetMeshBoundingBox(Mesh mesh) =>
    raylib.GetMeshBoundingBox(mesh.ptr.ref).toDart();

/// Generates tangents for [mesh] in-place (requires normals and texcoords).
void GenMeshTangents(Mesh mesh) => raylib.GenMeshTangents(mesh.ptr);

bool ExportMesh(Mesh mesh, String fileName) => ffi.using((arena) {
  return raylib.ExportMesh(
    mesh.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

bool ExportMeshAsCode(Mesh mesh, String fileName) => ffi.using((arena) {
  return raylib.ExportMeshAsCode(
    mesh.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

// ── Mesh generation ──────────────────────────────────────────────────────

Mesh GenMeshPoly(int sides, double radius) =>
    raylib.GenMeshPoly(sides, radius).toDart();

Mesh GenMeshPlane(double width, double length, int resX, int resZ) =>
    raylib.GenMeshPlane(width, length, resX, resZ).toDart();

Mesh GenMeshCube(double width, double height, double length) =>
    raylib.GenMeshCube(width, height, length).toDart();

Mesh GenMeshSphere(double radius, int rings, int slices) =>
    raylib.GenMeshSphere(radius, rings, slices).toDart();

Mesh GenMeshHemiSphere(double radius, int rings, int slices) =>
    raylib.GenMeshHemiSphere(radius, rings, slices).toDart();

Mesh GenMeshCylinder(double radius, double height, int slices) =>
    raylib.GenMeshCylinder(radius, height, slices).toDart();

Mesh GenMeshCone(double radius, double height, int slices) =>
    raylib.GenMeshCone(radius, height, slices).toDart();

Mesh GenMeshTorus(double radius, double size, int radSeg, int sides) =>
    raylib.GenMeshTorus(radius, size, radSeg, sides).toDart();

Mesh GenMeshKnot(double radius, double size, int radSeg, int sides) =>
    raylib.GenMeshKnot(radius, size, radSeg, sides).toDart();

Mesh GenMeshHeightmap(Image heightmap, Vector3 size) =>
    ffi.using((arena) {
      return raylib.GenMeshHeightmap(
        heightmap.ptr.ref,
        arena.vector3(size).ref,
      ).toDart();
    });

Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize) =>
    ffi.using((arena) {
      return raylib.GenMeshCubicmap(
        cubicmap.ptr.ref,
        arena.vector3(cubeSize).ref,
      ).toDart();
    });

// ── Material loading/unloading ───────────────────────────────────────────

/// Returns all materials loaded from [fileName].
/// Each material is independently managed by its own [Finalizer].
List<Material> LoadMaterials(String fileName) {
  return ffi.using((arena) {
    final countPtr = arena<Int>();
    final ptr = raylib.LoadMaterials(
      fileName.toNativeUtf8(allocator: arena).cast(),
      countPtr,
    );
    final count = countPtr.value;
    final result = List.generate(count, (i) => (ptr + i).ref.toDart());
    ffi.malloc.free(ptr);
    return result;
  });
}

Material LoadMaterialDefault() => raylib.LoadMaterialDefault().toDart();

bool IsMaterialValid(Material material) =>
    raylib.IsMaterialValid(material.ptr.ref);

void UnloadMaterial(Material material) => material.dispose();

/// Sets the texture for map slot [mapType] on [material] in-place.
void SetMaterialTexture(Material material, int mapType, Texture texture) =>
    ffi.using((arena) {
      raylib.SetMaterialTexture(
        material.ptr,
        mapType,
        arena.texture(texture).ref,
      );
    });

/// Reassigns mesh [meshId] on [model] to use material [materialId] in-place.
void SetModelMeshMaterial(Model model, int meshId, int materialId) =>
    raylib.SetModelMeshMaterial(model.ptr, meshId, materialId);

// ── Model animations ─────────────────────────────────────────────────────

/// Returns all animations loaded from [fileName].
/// Each animation is independently managed by its own [Finalizer].
List<ModelAnimation> LoadModelAnimations(String fileName) {
  return ffi.using((arena) {
    final countPtr = arena<Int>();
    final ptr = raylib.LoadModelAnimations(
      fileName.toNativeUtf8(allocator: arena).cast(),
      countPtr,
    );
    final count = countPtr.value;
    final result = List.generate(count, (i) => (ptr + i).ref.toDart());
    ffi.malloc.free(ptr);
    return result;
  });
}

void UpdateModelAnimation(Model model, ModelAnimation anim, int frame) =>
    raylib.UpdateModelAnimation(model.ptr.ref, anim.ptr.ref, frame);

void UpdateModelAnimationBones(
  Model model,
  ModelAnimation anim,
  int frame,
) => raylib.UpdateModelAnimationBones(model.ptr.ref, anim.ptr.ref, frame);

void UnloadModelAnimation(ModelAnimation anim) => anim.dispose();

void UnloadModelAnimations(List<ModelAnimation> animations) {
  for (final anim in animations) {
    anim.dispose();
  }
}

bool IsModelAnimationValid(Model model, ModelAnimation anim) =>
    raylib.IsModelAnimationValid(model.ptr.ref, anim.ptr.ref);

// ── Collision detection ──────────────────────────────────────────────────

bool CheckCollisionSpheres(
  Vector3 center1,
  double radius1,
  Vector3 center2,
  double radius2,
) => ffi.using((arena) {
  return raylib.CheckCollisionSpheres(
    arena.vector3(center1).ref,
    radius1,
    arena.vector3(center2).ref,
    radius2,
  );
});

bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2) =>
    ffi.using((arena) => raylib.CheckCollisionBoxes(
      arena.boundingBox(box1).ref,
      arena.boundingBox(box2).ref,
    ));

bool CheckCollisionBoxSphere(
  BoundingBox box,
  Vector3 center,
  double radius,
) => ffi.using((arena) => raylib.CheckCollisionBoxSphere(
  arena.boundingBox(box).ref,
  arena.vector3(center).ref,
  radius,
));

RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, double radius) =>
    ffi.using((arena) => raylib.GetRayCollisionSphere(
      arena.ray(ray).ref,
      arena.vector3(center).ref,
      radius,
    ).toDart());

RayCollision GetRayCollisionBox(Ray ray, BoundingBox box) =>
    ffi.using((arena) => raylib.GetRayCollisionBox(
      arena.ray(ray).ref,
      arena.boundingBox(box).ref,
    ).toDart());

RayCollision GetRayCollisionMesh(
  Ray ray,
  Mesh mesh,
  Matrix4 transform,
) => ffi.using((arena) => raylib.GetRayCollisionMesh(
  arena.ray(ray).ref,
  mesh.ptr.ref,
  arena.matrix4(transform).ref,
).toDart());

RayCollision GetRayCollisionTriangle(
  Ray ray,
  Vector3 p1,
  Vector3 p2,
  Vector3 p3,
) => ffi.using((arena) => raylib.GetRayCollisionTriangle(
  arena.ray(ray).ref,
  arena.vector3(p1).ref,
  arena.vector3(p2).ref,
  arena.vector3(p3).ref,
).toDart());

RayCollision GetRayCollisionQuad(
  Ray ray,
  Vector3 p1,
  Vector3 p2,
  Vector3 p3,
  Vector3 p4,
) => ffi.using((arena) => raylib.GetRayCollisionQuad(
  arena.ray(ray).ref,
  arena.vector3(p1).ref,
  arena.vector3(p2).ref,
  arena.vector3(p3).ref,
  arena.vector3(p4).ref,
).toDart());
