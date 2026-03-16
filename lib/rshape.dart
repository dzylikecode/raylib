// ignore_for_file: non_constant_identifier_names
//
// Dart wrappers for rshapes.c — every C function that accepts or returns a
// C struct (Color, Rectangle, Vector2, Texture2D) is replaced with a Dart
// wrapper that accepts/returns the corresponding Dart type.  Functions whose
// signatures are already primitive-only (int / double / bool) could be
// exported directly, but are wrapped here for consistency and to keep the
// public API free of raw C types.

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';
import 'src/rectangle.dart';

// ── Exports ──────────────────────────────────────────────────────────────
//
// All original re-exports are commented out because they expose C struct
// types at the API boundary.  Dart wrappers are provided below instead.

// export 'src/raylib.g.dart' show SetShapesTexture;           // → Dart wrapper
// export 'src/raylib.g.dart' show GetShapesTexture;           // → Dart wrapper
// export 'src/raylib.g.dart' show GetShapesTextureRectangle;  // → Dart wrapper
// export 'src/raylib.g.dart' show DrawPixel;                  // → Dart wrapper
// export 'src/raylib.g.dart' show DrawPixelV;                 // → Dart wrapper
// export 'src/raylib.g.dart' show DrawLine;                   // → Dart wrapper
// export 'src/raylib.g.dart' show DrawLineV;                  // → Dart wrapper
// export 'src/raylib.g.dart' show DrawLineEx;                 // → Dart wrapper
// export 'src/raylib.g.dart' show DrawLineStrip;              // → Dart wrapper
// export 'src/raylib.g.dart' show DrawLineBezier;             // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircle;                 // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleSector;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleSectorLines;      // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleGradient;         // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleV;                // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleLines;            // → Dart wrapper
// export 'src/raylib.g.dart' show DrawCircleLinesV;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawEllipse;                // → Dart wrapper
// export 'src/raylib.g.dart' show DrawEllipseLines;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRing;                   // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRingLines;              // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangle;              // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleV;             // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleRec;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectanglePro;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleGradientV;     // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleGradientH;     // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleGradientEx;    // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleLines;         // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleLinesEx;       // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleRounded;       // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleRoundedLines;  // → Dart wrapper
// export 'src/raylib.g.dart' show DrawRectangleRoundedLinesEx;// → Dart wrapper
// export 'src/raylib.g.dart' show DrawTriangle;               // → Dart wrapper
// export 'src/raylib.g.dart' show DrawTriangleLines;          // → Dart wrapper
// export 'src/raylib.g.dart' show DrawTriangleFan;            // → Dart wrapper
// export 'src/raylib.g.dart' show DrawTriangleStrip;          // → Dart wrapper
// export 'src/raylib.g.dart' show DrawPoly;                   // → Dart wrapper
// export 'src/raylib.g.dart' show DrawPolyLines;              // → Dart wrapper
// export 'src/raylib.g.dart' show DrawPolyLinesEx;            // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineLinear;           // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineBasis;            // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineCatmullRom;       // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineBezierQuadratic;  // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineBezierCubic;      // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineSegmentLinear;    // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineSegmentBasis;     // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineSegmentCatmullRom;// → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineSegmentBezierQuadratic; // → Dart wrapper
// export 'src/raylib.g.dart' show DrawSplineSegmentBezierCubic;     // → Dart wrapper
// export 'src/raylib.g.dart' show GetSplinePointLinear;       // → Dart wrapper
// export 'src/raylib.g.dart' show GetSplinePointBasis;        // → Dart wrapper
// export 'src/raylib.g.dart' show GetSplinePointCatmullRom;   // → Dart wrapper
// export 'src/raylib.g.dart' show GetSplinePointBezierQuad;   // → Dart wrapper
// export 'src/raylib.g.dart' show GetSplinePointBezierCubic;  // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionRecs;         // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionCircles;      // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionCircleRec;    // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionCircleLine;   // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionPointRec;     // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionPointCircle;  // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionPointTriangle;// → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionPointLine;    // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionPointPoly;    // → Dart wrapper
// export 'src/raylib.g.dart' show CheckCollisionLines;        // → Dart wrapper
// export 'src/raylib.g.dart' show GetCollisionRec;            // → Dart wrapper

// ── Shapes texture ──────────────────────────────────────────────────────

void SetShapesTexture(Texture texture, Rectangle source) =>
    ffi.using((arena) {
      raylib.SetShapesTexture(arena.texture(texture).ref, source.ptr.ref);
    });

Texture GetShapesTexture() => raylib.GetShapesTexture().toDart();

Rectangle GetShapesTextureRectangle() =>
    raylib.GetShapesTextureRectangle().toDart();

// ── Basic shapes ────────────────────────────────────────────────────────

void DrawPixel(int posX, int posY, Color color) =>
    raylib.DrawPixel(posX, posY, color.ptr.ref);

void DrawPixelV(Vector2 position, Color color) =>
    ffi.using((arena) {
      raylib.DrawPixelV(arena.vector2(position).ref, color.ptr.ref);
    });

void DrawLine(
  int startPosX,
  int startPosY,
  int endPosX,
  int endPosY,
  Color color,
) => raylib.DrawLine(startPosX, startPosY, endPosX, endPosY, color.ptr.ref);

void DrawLineV(Vector2 startPos, Vector2 endPos, Color color) =>
    ffi.using((arena) {
      raylib.DrawLineV(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        color.ptr.ref,
      );
    });

void DrawLineEx(Vector2 startPos, Vector2 endPos, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawLineEx(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        thick,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawLineStrip(List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raylib.DrawLineStrip(arena.vector2s(points), points.length, color.ptr.ref);
    });

void DrawLineBezier(
  Vector2 startPos,
  Vector2 endPos,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawLineBezier(
    arena.vector2(startPos).ref,
    arena.vector2(endPos).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawCircle(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircle(centerX, centerY, radius, color.ptr.ref);

void DrawCircleSector(
  Vector2 center,
  double radius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raylib.DrawCircleSector(
    arena.vector2(center).ref,
    radius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawCircleSectorLines(
  Vector2 center,
  double radius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raylib.DrawCircleSectorLines(
    arena.vector2(center).ref,
    radius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawCircleGradient(
  int centerX,
  int centerY,
  double radius,
  Color inner,
  Color outer,
) => raylib.DrawCircleGradient(
  centerX,
  centerY,
  radius,
  inner.ptr.ref,
  outer.ptr.ref,
);

void DrawCircleV(Vector2 center, double radius, Color color) =>
    ffi.using((arena) {
      raylib.DrawCircleV(arena.vector2(center).ref, radius, color.ptr.ref);
    });

void DrawCircleLines(int centerX, int centerY, double radius, Color color) =>
    raylib.DrawCircleLines(centerX, centerY, radius, color.ptr.ref);

void DrawCircleLinesV(Vector2 center, double radius, Color color) =>
    ffi.using((arena) {
      raylib.DrawCircleLinesV(arena.vector2(center).ref, radius, color.ptr.ref);
    });

void DrawEllipse(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raylib.DrawEllipse(centerX, centerY, radiusH, radiusV, color.ptr.ref);

void DrawEllipseLines(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raylib.DrawEllipseLines(centerX, centerY, radiusH, radiusV, color.ptr.ref);

void DrawRing(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raylib.DrawRing(
    arena.vector2(center).ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawRingLines(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raylib.DrawRingLines(
    arena.vector2(center).ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawRectangle(
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raylib.DrawRectangle(posX, posY, width, height, color.ptr.ref);

void DrawRectangleV(Vector2 position, Vector2 size, Color color) =>
    ffi.using((arena) {
      raylib.DrawRectangleV(
        arena.vector2(position).ref,
        arena.vector2(size).ref,
        color.ptr.ref,
      );
    });

void DrawRectangleRec(Rectangle rec, Color color) =>
    raylib.DrawRectangleRec(rec.ptr.ref, color.ptr.ref);

void DrawRectanglePro(
  Rectangle rec,
  Vector2 origin,
  double rotation,
  Color color,
) => ffi.using((arena) {
  raylib.DrawRectanglePro(
    rec.ptr.ref,
    arena.vector2(origin).ref,
    rotation,
    color.ptr.ref,
  );
});

void DrawRectangleGradientV(
  int posX,
  int posY,
  int width,
  int height,
  Color top,
  Color bottom,
) => raylib.DrawRectangleGradientV(
  posX,
  posY,
  width,
  height,
  top.ptr.ref,
  bottom.ptr.ref,
);

void DrawRectangleGradientH(
  int posX,
  int posY,
  int width,
  int height,
  Color left,
  Color right,
) => raylib.DrawRectangleGradientH(
  posX,
  posY,
  width,
  height,
  left.ptr.ref,
  right.ptr.ref,
);

void DrawRectangleGradientEx(
  Rectangle rec,
  Color topLeft,
  Color bottomLeft,
  Color topRight,
  Color bottomRight,
) => raylib.DrawRectangleGradientEx(
  rec.ptr.ref,
  topLeft.ptr.ref,
  bottomLeft.ptr.ref,
  topRight.ptr.ref,
  bottomRight.ptr.ref,
);

void DrawRectangleLines(
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raylib.DrawRectangleLines(posX, posY, width, height, color.ptr.ref);

void DrawRectangleLinesEx(Rectangle rec, double lineThick, Color color) =>
    raylib.DrawRectangleLinesEx(rec.ptr.ref, lineThick, color.ptr.ref);

void DrawRectangleRounded(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raylib.DrawRectangleRounded(rec.ptr.ref, roundness, segments, color.ptr.ref);

void DrawRectangleRoundedLines(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raylib.DrawRectangleRoundedLines(
  rec.ptr.ref,
  roundness,
  segments,
  color.ptr.ref,
);

void DrawRectangleRoundedLinesEx(
  Rectangle rec,
  double roundness,
  int segments,
  double lineThick,
  Color color,
) => raylib.DrawRectangleRoundedLinesEx(
  rec.ptr.ref,
  roundness,
  segments,
  lineThick,
  color.ptr.ref,
);

void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangle(
        arena.vector2(v1).ref,
        arena.vector2(v2).ref,
        arena.vector2(v3).ref,
        color.ptr.ref,
      );
    });

void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangleLines(
        arena.vector2(v1).ref,
        arena.vector2(v2).ref,
        arena.vector2(v3).ref,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawTriangleFan(List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangleFan(arena.vector2s(points), points.length, color.ptr.ref);
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawTriangleStrip(List<Vector2> points, Color color) =>
    ffi.using((arena) {
      raylib.DrawTriangleStrip(
        arena.vector2s(points),
        points.length,
        color.ptr.ref,
      );
    });

void DrawPoly(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  Color color,
) => ffi.using((arena) {
  raylib.DrawPoly(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    color.ptr.ref,
  );
});

void DrawPolyLines(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  Color color,
) => ffi.using((arena) {
  raylib.DrawPolyLines(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    color.ptr.ref,
  );
});

void DrawPolyLinesEx(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  double lineThick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawPolyLinesEx(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    lineThick,
    color.ptr.ref,
  );
});

// ── Splines ─────────────────────────────────────────────────────────────

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawSplineLinear(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawSplineLinear(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawSplineBasis(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawSplineBasis(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawSplineCatmullRom(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawSplineCatmullRom(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawSplineBezierQuadratic(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawSplineBezierQuadratic(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
void DrawSplineBezierCubic(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raylib.DrawSplineBezierCubic(
        arena.vector2s(points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

void DrawSplineSegmentLinear(
  Vector2 p1,
  Vector2 p2,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSplineSegmentLinear(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawSplineSegmentBasis(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSplineSegmentBasis(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawSplineSegmentCatmullRom(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSplineSegmentCatmullRom(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawSplineSegmentBezierQuadratic(
  Vector2 p1,
  Vector2 c2,
  Vector2 p3,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSplineSegmentBezierQuadratic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(p3).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawSplineSegmentBezierCubic(
  Vector2 p1,
  Vector2 c2,
  Vector2 c3,
  Vector2 p4,
  double thick,
  Color color,
) => ffi.using((arena) {
  raylib.DrawSplineSegmentBezierCubic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(c3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  );
});

Vector2 GetSplinePointLinear(Vector2 startPos, Vector2 endPos, double t) =>
    ffi.using((arena) => raylib.GetSplinePointLinear(
      arena.vector2(startPos).ref,
      arena.vector2(endPos).ref,
      t,
    ).toDart());

Vector2 GetSplinePointBasis(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using((arena) => raylib.GetSplinePointBasis(
  arena.vector2(p1).ref,
  arena.vector2(p2).ref,
  arena.vector2(p3).ref,
  arena.vector2(p4).ref,
  t,
).toDart());

Vector2 GetSplinePointCatmullRom(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using((arena) => raylib.GetSplinePointCatmullRom(
  arena.vector2(p1).ref,
  arena.vector2(p2).ref,
  arena.vector2(p3).ref,
  arena.vector2(p4).ref,
  t,
).toDart());

Vector2 GetSplinePointBezierQuad(
  Vector2 p1,
  Vector2 c2,
  Vector2 p3,
  double t,
) => ffi.using((arena) => raylib.GetSplinePointBezierQuad(
  arena.vector2(p1).ref,
  arena.vector2(c2).ref,
  arena.vector2(p3).ref,
  t,
).toDart());

Vector2 GetSplinePointBezierCubic(
  Vector2 p1,
  Vector2 c2,
  Vector2 c3,
  Vector2 p4,
  double t,
) => ffi.using((arena) => raylib.GetSplinePointBezierCubic(
  arena.vector2(p1).ref,
  arena.vector2(c2).ref,
  arena.vector2(c3).ref,
  arena.vector2(p4).ref,
  t,
).toDart());

// ── Collision detection ─────────────────────────────────────────────────

bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2) =>
    raylib.CheckCollisionRecs(rec1.ptr.ref, rec2.ptr.ref);

bool CheckCollisionCircles(
  Vector2 center1,
  double radius1,
  Vector2 center2,
  double radius2,
) => ffi.using((arena) => raylib.CheckCollisionCircles(
  arena.vector2(center1).ref,
  radius1,
  arena.vector2(center2).ref,
  radius2,
));

bool CheckCollisionCircleRec(Vector2 center, double radius, Rectangle rec) =>
    ffi.using((arena) => raylib.CheckCollisionCircleRec(
      arena.vector2(center).ref,
      radius,
      rec.ptr.ref,
    ));

bool CheckCollisionCircleLine(
  Vector2 center,
  double radius,
  Vector2 p1,
  Vector2 p2,
) => ffi.using((arena) => raylib.CheckCollisionCircleLine(
  arena.vector2(center).ref,
  radius,
  arena.vector2(p1).ref,
  arena.vector2(p2).ref,
));

bool CheckCollisionPointRec(Vector2 point, Rectangle rec) =>
    ffi.using((arena) => raylib.CheckCollisionPointRec(
      arena.vector2(point).ref,
      rec.ptr.ref,
    ));

bool CheckCollisionPointCircle(Vector2 point, Vector2 center, double radius) =>
    ffi.using((arena) => raylib.CheckCollisionPointCircle(
      arena.vector2(point).ref,
      arena.vector2(center).ref,
      radius,
    ));

bool CheckCollisionPointTriangle(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
) => ffi.using((arena) => raylib.CheckCollisionPointTriangle(
  arena.vector2(point).ref,
  arena.vector2(p1).ref,
  arena.vector2(p2).ref,
  arena.vector2(p3).ref,
));

bool CheckCollisionPointLine(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  int threshold,
) => ffi.using((arena) => raylib.CheckCollisionPointLine(
  arena.vector2(point).ref,
  arena.vector2(p1).ref,
  arena.vector2(p2).ref,
  threshold,
));

/// [points] replaces the C `Pointer<Vector2> points, int pointCount` pair.
bool CheckCollisionPointPoly(Vector2 point, List<Vector2> points) =>
    ffi.using((arena) => raylib.CheckCollisionPointPoly(
      arena.vector2(point).ref,
      arena.vector2s(points),
      points.length,
    ));

/// Returns `(hit, collisionPoint)`.
/// [collisionPoint] is non-null only when the lines intersect.
(bool, Vector2?) CheckCollisionLines(
  Vector2 s1,
  Vector2 e1,
  Vector2 s2,
  Vector2 e2,
) => ffi.using((arena) {
  final cp = arena<raylib.Vector2>();
  final hit = raylib.CheckCollisionLines(
    arena.vector2(s1).ref,
    arena.vector2(e1).ref,
    arena.vector2(s2).ref,
    arena.vector2(e2).ref,
    cp,
  );
  return (hit, hit ? cp.ref.toDart() : null);
});

Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2) =>
    raylib.GetCollisionRec(rec1.ptr.ref, rec2.ptr.ref).toDart();
