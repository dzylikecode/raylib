/*******************************************************************************************
*
*   raylib [core] example - input gestures testbed
*
*   Example complexity rating: [★★★☆] 3/4
*
*   Example originally created with raylib 5.0, last time updated with raylib 5.6-dev
*
*   Example contributed by ubkp (@ubkp) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023-2025 ubkp (@ubkp)
*
********************************************************************************************/

import 'package:raylib_dart/raylib_dart.dart';

import 'dart:math' as math; // Required for the protractor angle graphic drawing

const GESTURE_LOG_SIZE = 20;
const MAX_TOUCH_COUNT = 32;

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
    "raylib [core] example - input gestures testbed",
  );

  Vector2 messagePosition = Vector2(160, 7);

  // Last gesture variables definitions
  Gesture lastGesture = .GESTURE_NONE;
  Vector2 lastGesturePosition = Vector2(165, 130);

  // Gesture log variables definitions
  // NOTE: The gesture log uses an array (as an inverted circular queue) to store the performed gestures
  List<String> gestureLog = .generate(GESTURE_LOG_SIZE, (_) => "");
  // NOTE: The index for the inverted circular queue (moving from last to first direction, then looping around)
  int gestureLogIndex = GESTURE_LOG_SIZE;
  Gesture previousGesture = .GESTURE_NONE;

  // Log mode values:
  // - 0 shows repeated events
  // - 1 hides repeated events
  // - 2 shows repeated events but hide hold events
  // - 3 hides repeated events and hide hold events
  int logMode = 1;

  Color gestureColor = .fromRGBA(0, 0, 0, 255);
  Rectangle logButton1 = .fromLTWH(53, 7, 48, 26);
  Rectangle logButton2 = .fromLTWH(108, 7, 36, 26);
  Vector2 gestureLogPosition = Vector2(10, 10);

  // Protractor variables definitions
  double angleLength = 90.0;
  double currentAngleDegrees = 0.0;
  Vector2 finalVector = Vector2(0.0, 0.0);
  Vector2 protractorPosition = Vector2(266.0, 315.0);

  SetTargetFPS(60); // Set our game to run at 60 frames-per-second
  //--------------------------------------------------------------------------------------

  // Main game loop
  while (!WindowShouldClose()) // Detect window close button or ESC key
  {
    // Update
    //--------------------------------------------------------------------------------------
    // Handle common gestures data
    int i, ii; // Iterators that will be reused by all for loops
    final currentGesture = GetGestureDetected();
    final currentDragDegrees = GetGestureDragAngle();
    final currentPitchDegrees = GetGesturePinchAngle();
    final touchCount = GetTouchPointCount();

    // Handle last gesture
    if ((currentGesture != .GESTURE_NONE) &&
        (currentGesture != .GESTURE_HOLD) &&
        (currentGesture != previousGesture))
      lastGesture =
          currentGesture; // Filter the meaningful gestures (1, 2, 8 to 512) for the display

    // Handle gesture log
    if (IsMouseButtonReleased(.MOUSE_BUTTON_LEFT)) {
      if (CheckCollisionPointRec(GetMousePosition(), logButton1)) {
        switch (logMode) {
          case 3:
            logMode = 2;
            break;
          case 2:
            logMode = 3;
            break;
          case 1:
            logMode = 0;
            break;
          default:
            logMode = 1;
            break;
        }
      } else if (CheckCollisionPointRec(GetMousePosition(), logButton2)) {
        switch (logMode) {
          case 3:
            logMode = 1;
            break;
          case 2:
            logMode = 0;
            break;
          case 1:
            logMode = 3;
            break;
          default:
            logMode = 2;
            break;
        }
      }
    }

    int fillLog =
        0; // Gate variable to be used to allow or not the gesture log to be filled
    if (currentGesture != .GESTURE_NONE) {
      if (logMode == 3) // 3 hides repeated events and hide hold events
      {
        if (((currentGesture != .GESTURE_HOLD) &&
                (currentGesture != previousGesture)) ||
            (currentGesture == .GESTURE_NONE ||
                currentGesture == .GESTURE_TAP ||
                currentGesture == .GESTURE_DOUBLETAP))
          fillLog = 1;
      } else if (logMode == 2) // 2 shows repeated events but hide hold events
      {
        if (currentGesture != .GESTURE_HOLD) fillLog = 1;
      } else if (logMode == 1) // 1 hides repeated events
      {
        if (currentGesture != previousGesture) fillLog = 1;
      } else // 0 shows repeated events
      {
        fillLog = 1;
      }
    }

    if (fillLog !=
        0) // If one of the conditions from logMode was met, fill the gesture log
    {
      previousGesture = currentGesture;
      gestureColor = GetGestureColor(currentGesture);
      if (gestureLogIndex <= 0) gestureLogIndex = GESTURE_LOG_SIZE;
      gestureLogIndex--;

      // Copy the gesture respective name to the gesture log array
      gestureLog[gestureLogIndex] = GetGestureName(currentGesture);
    }

    // Handle protractor
    if (currentGesture case .GESTURE_PINCH_IN || .GESTURE_PINCH_OUT)
      currentAngleDegrees = currentPitchDegrees; // Pinch In and Pinch Out
    else if (currentGesture
        case .GESTURE_SWIPE_RIGHT ||
            .GESTURE_SWIPE_LEFT ||
            .GESTURE_SWIPE_UP ||
            .GESTURE_SWIPE_DOWN)
      currentAngleDegrees =
          currentDragDegrees; // Swipe Right, Swipe Left, Swipe Up and Swipe Down
    else if (currentGesture != .GESTURE_NONE)
      currentAngleDegrees = 0.0; // Tap, Doubletap, Hold and Grab

    double currentAngleRadians =
        ((currentAngleDegrees + 90.0) *
        math.pi /
        180); // Convert the current angle to Radians
    // Calculate the final vector for display
    finalVector = Vector2(
      (angleLength * math.sin(currentAngleRadians)) + protractorPosition.x,
      (angleLength * math.cos(currentAngleRadians)) + protractorPosition.y,
    );

    // Handle touch and mouse pointer points
    List<Vector2> touchPosition = .filled(MAX_TOUCH_COUNT, .zero());
    Vector2 mousePosition = Vector2(0, 0);
    if (currentGesture != .GESTURE_NONE) {
      if (touchCount != 0) {
        for (i = 0; i < touchCount; i++)
          touchPosition[i] = GetTouchPosition(i); // Fill the touch positions
      } else
        mousePosition = GetMousePosition();
    }
    //--------------------------------------------------------------------------------------

    // Draw
    //--------------------------------------------------------------------------------------
    BeginDrawing();
    ClearBackground(.RAYWHITE);

    // Draw common elements
    DrawText(
      "*",
      (messagePosition.x + 5).toInt(),
      (messagePosition.y + 5).toInt(),
      10,
      .BLACK,
    );
    DrawText(
      "Example optimized for Web/HTML5\non Smartphones with Touch Screen.",
      (messagePosition.x + 15).toInt(),
      (messagePosition.y + 5).toInt(),
      10,
      .BLACK,
    );
    DrawText(
      "*",
      (messagePosition.x + 5).toInt(),
      (messagePosition.y + 35).toInt(),
      10,
      .BLACK,
    );
    DrawText(
      "While running on Desktop Web Browsers,\ninspect and turn on Touch Emulation.",
      (messagePosition.x + 15).toInt(),
      (messagePosition.y + 35).toInt(),
      10,
      .BLACK,
    );

    // Draw last gesture
    DrawText(
      "Last gesture",
      (lastGesturePosition.x + 33).toInt(),
      (lastGesturePosition.y - 47).toInt(),
      20,
      .BLACK,
    );
    DrawText(
      "Swipe         Tap       Pinch  Touch",
      (lastGesturePosition.x + 17).toInt(),
      (lastGesturePosition.y - 18).toInt(),
      10,
      .BLACK,
    );
    DrawRectangle(
      (lastGesturePosition.x + 20).toInt(),
      (lastGesturePosition.y).toInt(),
      20,
      20,
      lastGesture == .GESTURE_SWIPE_UP ? .RED : .LIGHTGRAY,
    );
    DrawRectangle(
      (lastGesturePosition.x).toInt(),
      (lastGesturePosition.y + 20).toInt(),
      20,
      20,
      lastGesture == .GESTURE_SWIPE_LEFT ? .RED : .LIGHTGRAY,
    );
    DrawRectangle(
      (lastGesturePosition.x + 40).toInt(),
      (lastGesturePosition.y + 20).toInt(),
      20,
      20,
      lastGesture == .GESTURE_SWIPE_RIGHT ? .RED : .LIGHTGRAY,
    );
    DrawRectangle(
      (lastGesturePosition.x + 20).toInt(),
      (lastGesturePosition.y + 40).toInt(),
      20,
      20,
      lastGesture == .GESTURE_SWIPE_DOWN ? .RED : .LIGHTGRAY,
    );
    DrawCircle(
      (lastGesturePosition.x + 80).toInt(),
      (lastGesturePosition.y + 16).toInt(),
      10,
      lastGesture == .GESTURE_TAP ? .BLUE : .LIGHTGRAY,
    );
    DrawRing(
      Vector2(lastGesturePosition.x + 103, lastGesturePosition.y + 16),
      6.0,
      11.0,
      0.0,
      360.0,
      0,
      lastGesture == .GESTURE_DRAG ? .LIME : .LIGHTGRAY,
    );
    DrawCircle(
      (lastGesturePosition.x + 80).toInt(),
      (lastGesturePosition.y + 43).toInt(),
      10,
      lastGesture == .GESTURE_DOUBLETAP ? .SKYBLUE : .LIGHTGRAY,
    );
    DrawCircle(
      (lastGesturePosition.x + 103).toInt(),
      (lastGesturePosition.y + 43).toInt(),
      10,
      lastGesture == .GESTURE_DOUBLETAP ? .SKYBLUE : .LIGHTGRAY,
    );
    DrawTriangle(
      Vector2(lastGesturePosition.x + 122, lastGesturePosition.y + 16),
      Vector2(lastGesturePosition.x + 137, lastGesturePosition.y + 26),
      Vector2(lastGesturePosition.x + 137, lastGesturePosition.y + 6),
      lastGesture == .GESTURE_PINCH_OUT ? .ORANGE : .LIGHTGRAY,
    );
    DrawTriangle(
      Vector2(lastGesturePosition.x + 147, lastGesturePosition.y + 6),
      Vector2(lastGesturePosition.x + 147, lastGesturePosition.y + 26),
      Vector2(lastGesturePosition.x + 162, lastGesturePosition.y + 16),
      lastGesture == .GESTURE_PINCH_OUT ? .ORANGE : .LIGHTGRAY,
    );
    DrawTriangle(
      Vector2(lastGesturePosition.x + 125, lastGesturePosition.y + 33),
      Vector2(lastGesturePosition.x + 125, lastGesturePosition.y + 53),
      Vector2(lastGesturePosition.x + 140, lastGesturePosition.y + 43),
      lastGesture == .GESTURE_PINCH_IN ? .VIOLET : .LIGHTGRAY,
    );
    DrawTriangle(
      Vector2(lastGesturePosition.x + 144, lastGesturePosition.y + 43),
      Vector2(lastGesturePosition.x + 159, lastGesturePosition.y + 53),
      Vector2(lastGesturePosition.x + 159, lastGesturePosition.y + 33),
      lastGesture == .GESTURE_PINCH_IN ? .VIOLET : .LIGHTGRAY,
    );
    for (i = 0; i < 4; i++)
      DrawCircle(
        (lastGesturePosition.x + 180).toInt(),
        (lastGesturePosition.y + 7 + i * 15).toInt(),
        5,
        touchCount <= i ? .LIGHTGRAY : gestureColor,
      );

    // Draw gesture log
    DrawText(
      "Log",
      gestureLogPosition.x.toInt(),
      gestureLogPosition.y.toInt(),
      20,
      .BLACK,
    );

    // Loop in both directions to print the gesture log array in the inverted order (and looping around if the index started somewhere in the middle)
    for (
      var (i, ii) = (0, gestureLogIndex);
      i < GESTURE_LOG_SIZE;
      i++, ii = (ii + 1) % GESTURE_LOG_SIZE
    )
      DrawText(
        gestureLog[ii % GESTURE_LOG_SIZE],
        gestureLogPosition.x.toInt(),
        gestureLogPosition.y.toInt() + 410 - i * 20,
        20,
        (i == 0 ? gestureColor : .LIGHTGRAY),
      );
    Color logButton1Color, logButton2Color;
    switch (logMode) {
      case 3:
        logButton1Color = .MAROON;
        logButton2Color = .MAROON;
        break;
      case 2:
        logButton1Color = .GRAY;
        logButton2Color = .MAROON;
        break;
      case 1:
        logButton1Color = .MAROON;
        logButton2Color = .GRAY;
        break;
      default:
        logButton1Color = .GRAY;
        logButton2Color = .GRAY;
        break;
    }
    DrawRectangleRec(logButton1, logButton1Color);
    DrawText(
      "Hide",
      (logButton1.x + 7).toInt(),
      (logButton1.y + 3).toInt(),
      10,
      .WHITE,
    );
    DrawText(
      "Repeat",
      (logButton1.x + 7).toInt(),
      (logButton1.y + 13).toInt(),
      10,
      .WHITE,
    );
    DrawRectangleRec(logButton2, logButton2Color);
    DrawText(
      "Hide",
      (logButton1.x + 62).toInt(),
      (logButton1.y + 3).toInt(),
      10,
      .WHITE,
    );
    DrawText(
      "Hold",
      (logButton1.x + 62).toInt(),
      (logButton1.y + 13).toInt(),
      10,
      .WHITE,
    );

    // Draw protractor
    DrawText(
      "Angle",
      (protractorPosition.x).toInt() + 55,
      (protractorPosition.y).toInt() + 76,
      10,
      .BLACK,
    );
    String angleString = currentAngleDegrees.toStringAsPrecision(3);
    DrawText(
      angleString,
      (protractorPosition.x).toInt() + 55,
      (protractorPosition.y).toInt() + 92,
      20,
      gestureColor,
    );
    DrawCircleV(protractorPosition, 80.0, .WHITE);
    DrawLineEx(
      Vector2(protractorPosition.x - 90, protractorPosition.y),
      Vector2(protractorPosition.x + 90, protractorPosition.y),
      3.0,
      .LIGHTGRAY,
    );
    DrawLineEx(
      Vector2(protractorPosition.x, protractorPosition.y - 90),
      Vector2(protractorPosition.x, protractorPosition.y + 90),
      3.0,
      .LIGHTGRAY,
    );
    DrawLineEx(
      Vector2(protractorPosition.x - 80, protractorPosition.y - 45),
      Vector2(protractorPosition.x + 80, protractorPosition.y + 45),
      3.0,
      .GREEN,
    );
    DrawLineEx(
      Vector2(protractorPosition.x - 80, protractorPosition.y + 45),
      Vector2(protractorPosition.x + 80, protractorPosition.y - 45),
      3.0,
      .GREEN,
    );
    DrawText(
      "0",
      (protractorPosition.x).toInt() + 96,
      (protractorPosition.y).toInt() - 9,
      20,
      .BLACK,
    );
    DrawText(
      "30",
      (protractorPosition.x).toInt() + 74,
      (protractorPosition.y).toInt() - 68,
      20,
      .BLACK,
    );
    DrawText(
      "90",
      (protractorPosition.x).toInt() - 11,
      (protractorPosition.y).toInt() - 110,
      20,
      .BLACK,
    );
    DrawText(
      "150",
      (protractorPosition.x).toInt() - 100,
      (protractorPosition.y).toInt() - 68,
      20,
      .BLACK,
    );
    DrawText(
      "180",
      (protractorPosition.x).toInt() - 124,
      (protractorPosition.y).toInt() - 9,
      20,
      .BLACK,
    );
    DrawText(
      "210",
      (protractorPosition.x).toInt() - 100,
      (protractorPosition.y).toInt() + 50,
      20,
      .BLACK,
    );
    DrawText(
      "270",
      (protractorPosition.x).toInt() - 18,
      (protractorPosition.y).toInt() + 92,
      20,
      .BLACK,
    );
    DrawText(
      "330",
      (protractorPosition.x).toInt() + 72,
      (protractorPosition.y).toInt() + 50,
      20,
      .BLACK,
    );
    if (currentAngleDegrees != 0.0)
      DrawLineEx(protractorPosition, finalVector, 3.0, gestureColor);

    // Draw touch and mouse pointer points
    if (currentGesture != .GESTURE_NONE) {
      if (touchCount != 0) {
        for (i = 0; i < touchCount; i++) {
          DrawCircleV(touchPosition[i], 50.0, Fade(gestureColor, 0.5));
          DrawCircleV(touchPosition[i], 5.0, gestureColor);
        }

        if (touchCount == 2)
          DrawLineEx(
            touchPosition[0],
            touchPosition[1],
            ((currentGesture == .GESTURE_PINCH_OUT) ? 8.0 : 12.0),
            gestureColor,
          );
      } else {
        DrawCircleV(mousePosition, 35.0, Fade(gestureColor, 0.5));
        DrawCircleV(mousePosition, 5.0, gestureColor);
      }
    }

    EndDrawing();
    //--------------------------------------------------------------------------------------
  }

  // De-Initialization
  //--------------------------------------------------------------------------------------
  CloseWindow(); // Close window and OpenGL context
  //--------------------------------------------------------------------------------------

  return 0;
}

//----------------------------------------------------------------------------------
// Module Functions Definition
//----------------------------------------------------------------------------------
// Get text string for gesture value
String GetGestureName(Gesture gesture) {
  return switch (gesture) {
    .GESTURE_NONE => "None",
    .GESTURE_TAP => "Tap",
    .GESTURE_DOUBLETAP => "Double Tap",
    .GESTURE_HOLD => "Hold",
    .GESTURE_DRAG => "Drag",
    .GESTURE_SWIPE_RIGHT => "Swipe Right",
    .GESTURE_SWIPE_LEFT => "Swipe Left",
    .GESTURE_SWIPE_UP => "Swipe Up",
    .GESTURE_SWIPE_DOWN => "Swipe Down",
    .GESTURE_PINCH_IN => "Pinch In",
    .GESTURE_PINCH_OUT => "Pinch Out",
  };
}

// Get color for gesture value
Color GetGestureColor(Gesture gesture) {
  return switch (gesture) {
    .GESTURE_NONE => .BLACK,
    .GESTURE_TAP => .BLUE,
    .GESTURE_DOUBLETAP => .SKYBLUE,
    .GESTURE_HOLD => .BLACK,
    .GESTURE_DRAG => .LIME,
    .GESTURE_SWIPE_RIGHT => .RED,
    .GESTURE_SWIPE_LEFT => .RED,
    .GESTURE_SWIPE_UP => .RED,
    .GESTURE_SWIPE_DOWN => .RED,
    .GESTURE_PINCH_IN => .VIOLET,
    .GESTURE_PINCH_OUT => .ORANGE,
  };
}
