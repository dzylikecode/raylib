/*******************************************************************************************
*
*   raylib [core] example - input virtual controls
*
*   Example complexity rating: [★★☆☆] 2/4
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.0
*
*   Example contributed by GreenSnakeLinux (@GreenSnakeLinux),
*   reviewed by Ramon Santamaria (@raysan5), oblerion (@oblerion) and danilwhale (@danilwhale)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2024-2025 GreenSnakeLinux (@GreenSnakeLinux) and Ramon Santamaria (@raysan5)
*
********************************************************************************************/

import 'package:raylib_dart/raylib_dart.dart';

const int BUTTON_MAX = 4;

enum PadButton {
  BUTTON_NONE(-1),
  BUTTON_UP(0),
  BUTTON_LEFT(1),
  BUTTON_RIGHT(2),
  BUTTON_DOWN(3);

  final int value;
  const PadButton(this.value);

  static PadButton fromValue(int value) =>
      values.firstWhere((e) => e.value == value, orElse: () => BUTTON_NONE);
}

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
    "raylib [core] example - input virtual controls",
  );

  final padPosition = Vector2(100, 350);
  double buttonRadius = 30;

  final buttonPositions = [
    Vector2(padPosition.x, padPosition.y - buttonRadius * 1.5), // Up
    Vector2(padPosition.x - buttonRadius * 1.5, padPosition.y), // Left
    Vector2(padPosition.x + buttonRadius * 1.5, padPosition.y), // Right
    Vector2(padPosition.x, padPosition.y + buttonRadius * 1.5), // Down
  ];

  final buttonLabels = [
    "Y", // Up
    "X", // Left
    "B", // Right
    "A", // Down
  ];

  final buttonLabelColors = <Color>[
    .YELLOW, // Up
    .BLUE, // Left
    .RED, // Right
    .GREEN, // Down
  ];

  PadButton pressedButton = .BUTTON_NONE;
  Vector2 inputPosition = .zero();

  Vector2 playerPosition = Vector2(screenWidth / 2, screenHeight / 2);
  double playerSpeed = 75;

  SetTargetFPS(60);
  //--------------------------------------------------------------------------------------

  // Main game loop
  while (!WindowShouldClose()) // Detect window close button or ESC key
  {
    // Update
    //--------------------------------------------------------------------------
    if ((GetTouchPointCount() > 0))
      inputPosition = GetTouchPosition(0); // Use touch position
    else
      inputPosition = GetMousePosition(); // Use mouse position

    // Reset pressed button to none
    pressedButton = .BUTTON_NONE;

    // Make sure user is pressing left mouse button if they're from desktop
    if ((GetTouchPointCount() > 0) ||
        ((GetTouchPointCount() == 0) &&
            IsMouseButtonDown(.MOUSE_BUTTON_LEFT))) {
      // Find nearest D-Pad button to the input position
      for (int i = 0; i < BUTTON_MAX; i++) {
        double distX = (buttonPositions[i].x - inputPosition.x).abs();
        double distY = (buttonPositions[i].y - inputPosition.y).abs();

        if ((distX + distY < buttonRadius)) {
          pressedButton = .fromValue(i);
          break;
        }
      }
    }

    // Move player according to pressed button
    switch (pressedButton) {
      case .BUTTON_UP:
        playerPosition.y -= playerSpeed * GetFrameTime();
        break;
      case .BUTTON_LEFT:
        playerPosition.x -= playerSpeed * GetFrameTime();
        break;
      case .BUTTON_RIGHT:
        playerPosition.x += playerSpeed * GetFrameTime();
        break;
      case .BUTTON_DOWN:
        playerPosition.y += playerSpeed * GetFrameTime();
        break;
      default:
        break;
    }
    //--------------------------------------------------------------------------

    // Draw
    //--------------------------------------------------------------------------
    BeginDrawing();

    ClearBackground(.RAYWHITE);

    // Draw world
    DrawCircleV(playerPosition, 50, .MAROON);

    // Draw GUI
    for (int i = 0; i < BUTTON_MAX; i++) {
      DrawCircleV(
        buttonPositions[i],
        buttonRadius,
        (i == pressedButton.value) ? .DARKGRAY : .BLACK,
      );

      DrawText(
        buttonLabels[i],
        buttonPositions[i].x.toInt() - 7,
        buttonPositions[i].y.toInt() - 8,
        20,
        buttonLabelColors[i],
      );
    }

    DrawText("move the player with D-Pad buttons", 10, 10, 20, .DARKGRAY);

    EndDrawing();
    //--------------------------------------------------------------------------
  }

  // De-Initialization
  //--------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //--------------------------------------------------------------------------------------

  return 0;
}
