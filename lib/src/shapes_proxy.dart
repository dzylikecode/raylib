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
