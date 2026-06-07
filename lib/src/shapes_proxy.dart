// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'raylib.g.dart' as raw;
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;

import 'structs.dart';

void SetShapesTexture(Texture texture, Rectangle source) => ffi.using((arena) {
  raw.SetShapesTexture(arena.texture(texture).ref, source.ptr.ref);
});

Texture GetShapesTexture() => raw.GetShapesTexture().toDart();

Rectangle GetShapesTextureRectangle() =>
    raw.GetShapesTextureRectangle().toDart();

void DrawPixel(int posX, int posY, Color color) =>
    raw.DrawPixel(posX, posY, color.ptr.ref);

void DrawPixelV(Vector2 position, Color color) => ffi.using((arena) {
  raw.DrawPixelV(arena.vector2(position).ref, color.ptr.ref);
});

void DrawLine(
  int startPosX,
  int startPosY,
  int endPosX,
  int endPosY,
  Color color,
) => raw.DrawLine(startPosX, startPosY, endPosX, endPosY, color.ptr.ref);

// TODO: 完全是 c 遗留的问题，想想怎么 modern 的同时又不破坏 API 的一致性
Pointer<raw.Vector2> _vector2s(ffi.Arena arena, List<Vector2> points) {
  final count = points.length;
  final ptr = arena<raw.Vector2>(count);
  for (var i = 0; i < count; i++) {
    ptr[i]
      ..x = points[i].x
      ..y = points[i].y;
  }
  return ptr;
}

void DrawLineV(Vector2 startPos, Vector2 endPos, Color color) =>
    ffi.using((arena) {
      raw.DrawLineV(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        color.ptr.ref,
      );
    });

void DrawLineEx(Vector2 startPos, Vector2 endPos, double thick, Color color) =>
    ffi.using((arena) {
      raw.DrawLineEx(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        thick,
        color.ptr.ref,
      );
    });

void DrawLineStrip(List<Vector2> points, Color color) => ffi.using((arena) {
  raw.DrawLineStrip(_vector2s(arena, points), points.length, color.ptr.ref);
});

void DrawLineBezier(
  Vector2 startPos,
  Vector2 endPos,
  double thick,
  Color color,
) => ffi.using((arena) {
  raw.DrawLineBezier(
    arena.vector2(startPos).ref,
    arena.vector2(endPos).ref,
    thick,
    color.ptr.ref,
  );
});

void DrawLineDashed(
  Vector2 startPos,
  Vector2 endPos,
  int dashSize,
  int spaceSize,
  Color color,
) => ffi.using((arena) {
  raw.DrawLineDashed(
    arena.vector2(startPos).ref,
    arena.vector2(endPos).ref,
    dashSize,
    spaceSize,
    color.ptr.ref,
  );
});

void DrawCircle(int centerX, int centerY, double radius, Color color) =>
    raw.DrawCircle(centerX, centerY, radius, color.ptr.ref);

void DrawCircleV(Vector2 center, double radius, Color color) =>
    ffi.using((arena) {
      raw.DrawCircleV(arena.vector2(center).ref, radius, color.ptr.ref);
    });

void DrawCircleGradient(
  Vector2 center,
  double radius,
  Color inner,
  Color outer,
) => ffi.using((arena) {
  raw.DrawCircleGradient(
    arena.vector2(center).ref,
    radius,
    inner.ptr.ref,
    outer.ptr.ref,
  );
});

void DrawCircleSector(
  Vector2 center,
  double radius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raw.DrawCircleSector(
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
  raw.DrawCircleSectorLines(
    arena.vector2(center).ref,
    radius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawCircleLines(int centerX, int centerY, double radius, Color color) =>
    raw.DrawCircleLines(centerX, centerY, radius, color.ptr.ref);

void DrawCircleLinesV(Vector2 center, double radius, Color color) =>
    ffi.using((arena) {
      raw.DrawCircleLinesV(arena.vector2(center).ref, radius, color.ptr.ref);
    });

void DrawEllipse(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raw.DrawEllipse(centerX, centerY, radiusH, radiusV, color.ptr.ref);

void DrawEllipseV(
  Vector2 center,
  double radiusH,
  double radiusV,
  Color color,
) => ffi.using((arena) {
  raw.DrawEllipseV(arena.vector2(center).ref, radiusH, radiusV, color.ptr.ref);
});

void DrawEllipseLines(
  int centerX,
  int centerY,
  double radiusH,
  double radiusV,
  Color color,
) => raw.DrawEllipseLines(centerX, centerY, radiusH, radiusV, color.ptr.ref);

void DrawEllipseLinesV(
  Vector2 center,
  double radiusH,
  double radiusV,
  Color color,
) => ffi.using((arena) {
  raw.DrawEllipseLinesV(
    arena.vector2(center).ref,
    radiusH,
    radiusV,
    color.ptr.ref,
  );
});

void DrawRing(
  Vector2 center,
  double innerRadius,
  double outerRadius,
  double startAngle,
  double endAngle,
  int segments,
  Color color,
) => ffi.using((arena) {
  raw.DrawRing(
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
  raw.DrawRingLines(
    arena.vector2(center).ref,
    innerRadius,
    outerRadius,
    startAngle,
    endAngle,
    segments,
    color.ptr.ref,
  );
});

void DrawRectangle(int posX, int posY, int width, int height, Color color) =>
    raw.DrawRectangle(posX, posY, width, height, color.ptr.ref);

void DrawRectangleV(Vector2 position, Vector2 size, Color color) =>
    ffi.using((arena) {
      raw.DrawRectangleV(
        arena.vector2(position).ref,
        arena.vector2(size).ref,
        color.ptr.ref,
      );
    });

void DrawRectangleRec(Rectangle rec, Color color) =>
    raw.DrawRectangleRec(rec.ptr.ref, color.ptr.ref);

void DrawRectanglePro(
  Rectangle rec,
  Vector2 origin,
  double rotation,
  Color color,
) => ffi.using((arena) {
  raw.DrawRectanglePro(
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
) => raw.DrawRectangleGradientV(
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
) => raw.DrawRectangleGradientH(
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
  Color bottomRight,
  Color topRight,
) => raw.DrawRectangleGradientEx(
  rec.ptr.ref,
  topLeft.ptr.ref,
  bottomLeft.ptr.ref,
  bottomRight.ptr.ref,
  topRight.ptr.ref,
);

void DrawRectangleLines(
  int posX,
  int posY,
  int width,
  int height,
  Color color,
) => raw.DrawRectangleLines(posX, posY, width, height, color.ptr.ref);

void DrawRectangleLinesEx(Rectangle rec, double lineThick, Color color) =>
    raw.DrawRectangleLinesEx(rec.ptr.ref, lineThick, color.ptr.ref);

void DrawRectangleRounded(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raw.DrawRectangleRounded(rec.ptr.ref, roundness, segments, color.ptr.ref);

void DrawRectangleRoundedLines(
  Rectangle rec,
  double roundness,
  int segments,
  Color color,
) => raw.DrawRectangleRoundedLines(
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
) => raw.DrawRectangleRoundedLinesEx(
  rec.ptr.ref,
  roundness,
  segments,
  lineThick,
  color.ptr.ref,
);

void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    ffi.using((arena) {
      raw.DrawTriangle(
        arena.vector2(v1).ref,
        arena.vector2(v2).ref,
        arena.vector2(v3).ref,
        color.ptr.ref,
      );
    });

void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color) =>
    ffi.using((arena) {
      raw.DrawTriangleLines(
        arena.vector2(v1).ref,
        arena.vector2(v2).ref,
        arena.vector2(v3).ref,
        color.ptr.ref,
      );
    });

void DrawTriangleFan(List<Vector2> points, Color color) => ffi.using((arena) {
  raw.DrawTriangleFan(_vector2s(arena, points), points.length, color.ptr.ref);
});

void DrawTriangleStrip(List<Vector2> points, Color color) => ffi.using((arena) {
  raw.DrawTriangleStrip(_vector2s(arena, points), points.length, color.ptr.ref);
});

void DrawPoly(
  Vector2 center,
  int sides,
  double radius,
  double rotation,
  Color color,
) => ffi.using((arena) {
  raw.DrawPoly(
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
  raw.DrawPolyLines(
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
  raw.DrawPolyLinesEx(
    arena.vector2(center).ref,
    sides,
    radius,
    rotation,
    lineThick,
    color.ptr.ref,
  );
});

void DrawSplineLinear(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raw.DrawSplineLinear(
        _vector2s(arena, points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

void DrawSplineBasis(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raw.DrawSplineBasis(
        _vector2s(arena, points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

void DrawSplineCatmullRom(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raw.DrawSplineCatmullRom(
        _vector2s(arena, points),
        points.length,
        thick,
        color.ptr.ref,
      );
    });

void DrawSplineBezierQuadratic(
  List<Vector2> points,
  double thick,
  Color color,
) => ffi.using((arena) {
  raw.DrawSplineBezierQuadratic(
    _vector2s(arena, points),
    points.length,
    thick,
    color.ptr.ref,
  );
});

void DrawSplineBezierCubic(List<Vector2> points, double thick, Color color) =>
    ffi.using((arena) {
      raw.DrawSplineBezierCubic(
        _vector2s(arena, points),
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
  raw.DrawSplineSegmentLinear(
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
  raw.DrawSplineSegmentBasis(
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
  raw.DrawSplineSegmentCatmullRom(
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
  raw.DrawSplineSegmentBezierQuadratic(
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
  raw.DrawSplineSegmentBezierCubic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(c3).ref,
    arena.vector2(p4).ref,
    thick,
    color.ptr.ref,
  );
});

Vector2 GetSplinePointLinear(Vector2 startPos, Vector2 endPos, double t) =>
    ffi.using((arena) {
      return raw.GetSplinePointLinear(
        arena.vector2(startPos).ref,
        arena.vector2(endPos).ref,
        t,
      ).toDart();
    });

Vector2 GetSplinePointBasis(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using((arena) {
  return raw.GetSplinePointBasis(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart();
});

Vector2 GetSplinePointCatmullRom(
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
  Vector2 p4,
  double t,
) => ffi.using((arena) {
  return raw.GetSplinePointCatmullRom(
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart();
});

Vector2 GetSplinePointBezierQuad(
  Vector2 p1,
  Vector2 c2,
  Vector2 p3,
  double t,
) => ffi.using((arena) {
  return raw.GetSplinePointBezierQuad(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(p3).ref,
    t,
  ).toDart();
});

Vector2 GetSplinePointBezierCubic(
  Vector2 p1,
  Vector2 c2,
  Vector2 c3,
  Vector2 p4,
  double t,
) => ffi.using((arena) {
  return raw.GetSplinePointBezierCubic(
    arena.vector2(p1).ref,
    arena.vector2(c2).ref,
    arena.vector2(c3).ref,
    arena.vector2(p4).ref,
    t,
  ).toDart();
});

bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2) =>
    raw.CheckCollisionRecs(rec1.ptr.ref, rec2.ptr.ref);

bool CheckCollisionCircles(
  Vector2 center1,
  double radius1,
  Vector2 center2,
  double radius2,
) => ffi.using((arena) {
  return raw.CheckCollisionCircles(
    arena.vector2(center1).ref,
    radius1,
    arena.vector2(center2).ref,
    radius2,
  );
});

bool CheckCollisionCircleRec(Vector2 center, double radius, Rectangle rec) =>
    ffi.using((arena) {
      return raw.CheckCollisionCircleRec(
        arena.vector2(center).ref,
        radius,
        rec.ptr.ref,
      );
    });

bool CheckCollisionCircleLine(
  Vector2 center,
  double radius,
  Vector2 p1,
  Vector2 p2,
) => ffi.using((arena) {
  return raw.CheckCollisionCircleLine(
    arena.vector2(center).ref,
    radius,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
  );
});

bool CheckCollisionPointRec(Vector2 point, Rectangle rec) => ffi.using((arena) {
  return raw.CheckCollisionPointRec(arena.vector2(point).ref, rec.ptr.ref);
});

bool CheckCollisionPointCircle(Vector2 point, Vector2 center, double radius) =>
    ffi.using((arena) {
      return raw.CheckCollisionPointCircle(
        arena.vector2(point).ref,
        arena.vector2(center).ref,
        radius,
      );
    });

bool CheckCollisionPointTriangle(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  Vector2 p3,
) => ffi.using((arena) {
  return raw.CheckCollisionPointTriangle(
    arena.vector2(point).ref,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    arena.vector2(p3).ref,
  );
});

bool CheckCollisionPointLine(
  Vector2 point,
  Vector2 p1,
  Vector2 p2,
  int threshold,
) => ffi.using((arena) {
  return raw.CheckCollisionPointLine(
    arena.vector2(point).ref,
    arena.vector2(p1).ref,
    arena.vector2(p2).ref,
    threshold,
  );
});

bool CheckCollisionPointPoly(Vector2 point, List<Vector2> points) =>
    ffi.using((arena) {
      return raw.CheckCollisionPointPoly(
        arena.vector2(point).ref,
        _vector2s(arena, points),
        points.length,
      );
    });

bool CheckCollisionLines(
  Vector2 startPos1,
  Vector2 endPos1,
  Vector2 startPos2,
  Vector2 endPos2,
  List<Vector2> collisionPoint,
) => ffi.using((arena) {
  final output = arena<raw.Vector2>();
  final collided = raw.CheckCollisionLines(
    arena.vector2(startPos1).ref,
    arena.vector2(endPos1).ref,
    arena.vector2(startPos2).ref,
    arena.vector2(endPos2).ref,
    output,
  );
  if (collided) {
    final point = output.ref.toDart();
    if (collisionPoint.isEmpty) {
      collisionPoint.add(point);
    } else {
      collisionPoint[0] = point;
    }
  }
  return collided;
});

Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2) =>
    raw.GetCollisionRec(rec1.ptr.ref, rec2.ptr.ref).toDart();
