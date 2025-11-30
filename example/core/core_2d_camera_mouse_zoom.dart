/*******************************************************************************************
*
*   raylib [core] example - 2d camera mouse zoom
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 4.2, last time updated with raylib 4.2
*
*   Example contributed by Jeffery Myers (@JeffM2501) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2022-2025 Jeffery Myers (@JeffM2501)
*
********************************************************************************************/

import 'package:raylib_dart/raylib_dart.dart';

import 'dart:math' as math;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main() {
  // Initialization
  //--------------------------------------------------------------------------------------
  const int screenWidth = 800;
  const int screenHeight = 450;

  InitWindow(
    screenWidth,
    screenHeight,
    "raylib [core] example - 2d camera mouse zoom",
  );

  final camera = Camera2D();
  camera.zoom = 1.0;

  int zoomMode = 0; // 0-Mouse Wheel, 1-Mouse Move

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //--------------------------------------------------------------------------------------

  // Main game loop
  while (!WindowShouldClose()) // Detect window close button or ESC key
  {
    // Update
    //----------------------------------------------------------------------------------
    if (IsKeyPressed(.KEY_ONE))
      zoomMode = 0;
    else if (IsKeyPressed(.KEY_TWO))
      zoomMode = 1;

    // Translate based on mouse right click
    if (IsMouseButtonDown(.MOUSE_BUTTON_LEFT)) {
      Vector2 delta = GetMouseDelta();
      delta = delta * -1.0 / camera.zoom;
      camera.target = camera.target + delta;
    }

    if (zoomMode == 0) {
      // Zoom based on mouse wheel
      double wheel = GetMouseWheelMove();
      if (wheel != 0) {
        // Get the world point that is under the mouse
        Vector2 mouseWorldPos = GetScreenToWorld2D(GetMousePosition(), camera);

        // Set the offset to where the mouse is
        camera.offset = GetMousePosition();

        // Set the target to match, so that the camera maps the world space point
        // under the cursor to the screen space point under the cursor at any zoom
        camera.target = mouseWorldPos;

        // Zoom increment
        // Uses log scaling to provide consistent zoom speed
        double scale = 0.2 * wheel;
        camera.zoom = math
            .exp(math.log(camera.zoom) + scale)
            .clamp(0.125, 64.0);
      }
    } else {
      // Zoom based on mouse right click
      if (IsMouseButtonPressed(.MOUSE_BUTTON_RIGHT)) {
        // Get the world point that is under the mouse
        Vector2 mouseWorldPos = GetScreenToWorld2D(GetMousePosition(), camera);

        // Set the offset to where the mouse is
        camera.offset = GetMousePosition();

        // Set the target to match, so that the camera maps the world space point
        // under the cursor to the screen space point under the cursor at any zoom
        camera.target = mouseWorldPos;
      }

      if (IsMouseButtonDown(.MOUSE_BUTTON_RIGHT)) {
        // Zoom increment
        // Uses log scaling to provide consistent zoom speed
        double deltaX = GetMouseDelta().x;
        double scale = 0.005 * deltaX;
        camera.zoom = math
            .exp(math.log(camera.zoom) + scale)
            .clamp(0.125, 64.0);
      }
    }
    //----------------------------------------------------------------------------------

    // Draw
    //----------------------------------------------------------------------------------
    BeginDrawing();
    ClearBackground(RAYWHITE);

    BeginMode2D(camera);
    // Draw the 3d grid, rotated 90 degrees and centered around 0,0
    // just so we have something in the XY plane
    rlPushMatrix();
    rlTranslatef(0, 25 * 50, 0);
    rlRotatef(90, 1, 0, 0);
    DrawGrid(100, 50);
    rlPopMatrix();

    // Draw a reference circle
    DrawCircle(GetScreenWidth() ~/ 2, GetScreenHeight() ~/ 2, 50, MAROON);
    EndMode2D();

    // Draw mouse reference
    //Vector2 mousePos = GetWorldToScreen2D(GetMousePosition(), camera)
    DrawCircleV(GetMousePosition(), 4, DARKGRAY);
    DrawTextEx(
      GetFontDefault(),
      "[${GetMouseX()}, ${GetMouseY()}]",
      GetMousePosition() + Vector2(-44, -24),
      20,
      2,
      BLACK,
    );

    DrawText(
      "[1][2] Select mouse zoom mode (Wheel or Move)",
      20,
      20,
      20,
      DARKGRAY,
    );
    if (zoomMode == 0)
      DrawText(
        "Mouse left button drag to move, mouse wheel to zoom",
        20,
        50,
        20,
        DARKGRAY,
      );
    else
      DrawText(
        "Mouse left button drag to move, mouse press and move to zoom",
        20,
        50,
        20,
        DARKGRAY,
      );

    EndDrawing();
    //----------------------------------------------------------------------------------
  }

  // De-Initialization
  //--------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //--------------------------------------------------------------------------------------

  return 0;
}
