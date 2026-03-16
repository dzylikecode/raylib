// ignore_for_file: non_constant_identifier_names
//
// 本文件封装 raylib 3D 模型模块。
//
// 尚未代理（需要先实现对应的 struct 包装）：
//   Model, Mesh, Material, ModelAnimation — 3D 数据结构体
//   BoundingBox — 包围盒（含 Vector3 min/max）
//   RayCollision — 射线碰撞结果

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';

// ── 3D primitives ────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawLine3D;
// export 'src/raylib.g.dart' show DrawPoint3D;
// export 'src/raylib.g.dart' show DrawCircle3D;
// export 'src/raylib.g.dart' show DrawTriangle3D;
// export 'src/raylib.g.dart' show DrawTriangleStrip3D;
// ── 3D solids ────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawCube;
// export 'src/raylib.g.dart' show DrawCubeV;
// export 'src/raylib.g.dart' show DrawCubeWires;
// export 'src/raylib.g.dart' show DrawCubeWiresV;
// export 'src/raylib.g.dart' show DrawSphere;
// export 'src/raylib.g.dart' show DrawSphereEx;
// export 'src/raylib.g.dart' show DrawSphereWires;
// export 'src/raylib.g.dart' show DrawCylinder;
// export 'src/raylib.g.dart' show DrawCylinderEx;
// export 'src/raylib.g.dart' show DrawCylinderWires;
// export 'src/raylib.g.dart' show DrawCylinderWiresEx;
// export 'src/raylib.g.dart' show DrawCapsule;
// export 'src/raylib.g.dart' show DrawCapsuleWires;
// export 'src/raylib.g.dart' show DrawPlane;
// export 'src/raylib.g.dart' show DrawRay;
export 'src/raylib.g.dart' show DrawGrid;
// ── Billboards ───────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show DrawBillboard;
// export 'src/raylib.g.dart' show DrawBillboardRec;
// export 'src/raylib.g.dart' show DrawBillboardPro;
// ── Model ────────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadModel;
// export 'src/raylib.g.dart' show LoadModelFromMesh;
// export 'src/raylib.g.dart' show IsModelValid;
// export 'src/raylib.g.dart' show UnloadModel;
// export 'src/raylib.g.dart' show GetModelBoundingBox;
// export 'src/raylib.g.dart' show DrawModel;
// export 'src/raylib.g.dart' show DrawModelEx;
// export 'src/raylib.g.dart' show DrawModelWires;
// export 'src/raylib.g.dart' show DrawModelWiresEx;
// export 'src/raylib.g.dart' show DrawModelPoints;
// export 'src/raylib.g.dart' show DrawModelPointsEx;
// export 'src/raylib.g.dart' show DrawBoundingBox;
// ── Mesh ─────────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show UploadMesh;
// export 'src/raylib.g.dart' show UpdateMeshBuffer;
// export 'src/raylib.g.dart' show UnloadMesh;
// export 'src/raylib.g.dart' show DrawMesh;
// export 'src/raylib.g.dart' show DrawMeshInstanced;
// export 'src/raylib.g.dart' show GetMeshBoundingBox;
// export 'src/raylib.g.dart' show GenMeshTangents;
// export 'src/raylib.g.dart' show ExportMesh;
// export 'src/raylib.g.dart' show ExportMeshAsCode;
// export 'src/raylib.g.dart' show GenMeshPoly;
// export 'src/raylib.g.dart' show GenMeshPlane;
// export 'src/raylib.g.dart' show GenMeshCube;
// export 'src/raylib.g.dart' show GenMeshSphere;
// export 'src/raylib.g.dart' show GenMeshHemiSphere;
// export 'src/raylib.g.dart' show GenMeshCylinder;
// export 'src/raylib.g.dart' show GenMeshCone;
// export 'src/raylib.g.dart' show GenMeshTorus;
// export 'src/raylib.g.dart' show GenMeshKnot;
// export 'src/raylib.g.dart' show GenMeshHeightmap;
// export 'src/raylib.g.dart' show GenMeshCubicmap;
// ── Material ─────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadMaterials;
// export 'src/raylib.g.dart' show LoadMaterialDefault;
// export 'src/raylib.g.dart' show IsMaterialValid;
// export 'src/raylib.g.dart' show UnloadMaterial;
// export 'src/raylib.g.dart' show SetMaterialTexture;
// export 'src/raylib.g.dart' show SetModelMeshMaterial;
// ── Animation ────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadModelAnimations;
// export 'src/raylib.g.dart' show UpdateModelAnimation;
// export 'src/raylib.g.dart' show UpdateModelAnimationBones;
// export 'src/raylib.g.dart' show UnloadModelAnimation;
// export 'src/raylib.g.dart' show UnloadModelAnimations;
// export 'src/raylib.g.dart' show IsModelAnimationValid;
// ── Collision ────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show CheckCollisionSpheres;
// export 'src/raylib.g.dart' show CheckCollisionBoxes;
// export 'src/raylib.g.dart' show CheckCollisionBoxSphere;
// export 'src/raylib.g.dart' show GetRayCollisionSphere;
// export 'src/raylib.g.dart' show GetRayCollisionBox;
// export 'src/raylib.g.dart' show GetRayCollisionMesh;
// export 'src/raylib.g.dart' show GetRayCollisionTriangle;
// export 'src/raylib.g.dart' show GetRayCollisionQuad;

// ── 3D primitives ────────────────────────────────────────────────────────

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

// ── 3D solids ────────────────────────────────────────────────────────────

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

// ── Billboards ───────────────────────────────────────────────────────────

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

// ── Collision ────────────────────────────────────────────────────────────

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
