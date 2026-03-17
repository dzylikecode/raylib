/*******************************************************************************************
*
*   raylib [core] example - 2d camera split screen
*
*   Addapted from the core_3d_camera_split_screen example: 
*       https://github.com/raysan5/raylib/blob/master/examples/core/core_3d_camera_split_screen.c
*
*   Example originally created with raylib 4.5, last time updated with raylib 4.5
*
*   Example contributed by Gabriel dos Santos Sanches (@gabrielssanches) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2023 Gabriel dos Santos Sanches (@gabrielssanches)
*
********************************************************************************************/

import "package:raylib_dart/raylib_dart.dart";

const PLAYER_SIZE = 40;

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 440;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera split screen");

    Rectangle player1 = .fromLTWH(200, 200, PLAYER_SIZE.toDouble(), PLAYER_SIZE.toDouble());
    Rectangle player2 = .fromLTWH(250, 200, PLAYER_SIZE.toDouble(), PLAYER_SIZE.toDouble());

    Camera2D camera1 = Camera2D();
    camera1.target = Vector2(player1.x, player1.y);
    camera1.offset = Vector2(200.0, 200.0);
    camera1.rotation = 0.0;
    camera1.zoom = 1.0;

    Camera2D camera2 = Camera2D();
    camera2.target = Vector2(player2.x, player2.y);
    camera2.offset = Vector2(200.0, 200.0);
    camera2.rotation = 0.0;
    camera2.zoom = 1.0;

    RenderTexture screenCamera1 = LoadRenderTexture(screenWidth~/2, screenHeight);
    RenderTexture screenCamera2 = LoadRenderTexture(screenWidth~/2, screenHeight);

    // Build a flipped rectangle the size of the split view to use for drawing later
    Rectangle splitScreenRect = .fromLTWH(0.0, 0.0, screenCamera1.texture.width.toDouble(), -screenCamera1.texture.height.toDouble());

    SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        if (IsKeyDown(KEY_S)) player1.y += 3.0.f;
        else if (IsKeyDown(KEY_W)) player1.y -= 3.0.f;
        if (IsKeyDown(KEY_D)) player1.x += 3.0.f;
        else if (IsKeyDown(KEY_A)) player1.x -= 3.0.f;

        if (IsKeyDown(KEY_UP)) player2.y -= 3.0.f;
        else if (IsKeyDown(KEY_DOWN)) player2.y += 3.0.f;
        if (IsKeyDown(KEY_RIGHT)) player2.x += 3.0.f;
        else if (IsKeyDown(KEY_LEFT)) player2.x -= 3.0.f;

        camera1.target = Vector2(player1.x, player1.y);
        camera2.target = Vector2(player2.x, player2.y);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginTextureMode(screenCamera1);
            ClearBackground(RAYWHITE);
            
            BeginMode2D(camera1);
            
                // Draw full scene with first camera
                for (int i = 0; i < screenWidth/PLAYER_SIZE + 1; i++)
                {
                    DrawLineV(Vector2(PLAYER_SIZE*i.toDouble(), 0), Vector2(PLAYER_SIZE*i.toDouble(), screenHeight.toDouble()), LIGHTGRAY);
                }

                for (int i = 0; i < screenHeight/PLAYER_SIZE + 1; i++)
                {
                    DrawLineV(Vector2(0, PLAYER_SIZE*i.toDouble()), Vector2(screenWidth.toDouble(), PLAYER_SIZE*i.toDouble()), LIGHTGRAY);
                }

                for (int i = 0; i < screenWidth/PLAYER_SIZE; i++)
                {
                    for (int j = 0; j < screenHeight/PLAYER_SIZE; j++)
                    {
                        DrawText(TextFormat("[%i,%i]", [i, j]), 10 + PLAYER_SIZE*i, 15 + PLAYER_SIZE*j, 10, LIGHTGRAY);
                    }
                }

                DrawRectangleRec(player1, RED);
                DrawRectangleRec(player2, BLUE);
            EndMode2D();
            
            DrawRectangle(0, 0, GetScreenWidth()~/2, 30, Fade(RAYWHITE, 0.6.f));
            DrawText("PLAYER1: W/S/A/D to move", 10, 10, 10, MAROON);
            
        EndTextureMode();

        BeginTextureMode(screenCamera2);
            ClearBackground(RAYWHITE);
            
            BeginMode2D(camera2);
            
                // Draw full scene with second camera
                for (int i = 0; i < screenWidth/PLAYER_SIZE + 1; i++)
                {
                    DrawLineV(Vector2(PLAYER_SIZE*i.toDouble(), 0), Vector2(PLAYER_SIZE*i.toDouble(), screenHeight.toDouble()), LIGHTGRAY);
                }

                for (int i = 0; i < screenHeight/PLAYER_SIZE + 1; i++)
                {
                    DrawLineV(Vector2(0, PLAYER_SIZE*i.toDouble()), Vector2(screenWidth.toDouble(), PLAYER_SIZE*i.toDouble()), LIGHTGRAY);
                }

                for (int i = 0; i < screenWidth/PLAYER_SIZE; i++)
                {
                    for (int j = 0; j < screenHeight/PLAYER_SIZE; j++)
                    {
                        DrawText(TextFormat("[%i,%i]", [i, j]), 10 + PLAYER_SIZE*i, 15 + PLAYER_SIZE*j, 10, LIGHTGRAY);
                    }
                }

                DrawRectangleRec(player1, RED);
                DrawRectangleRec(player2, BLUE);
                
            EndMode2D();
            
            DrawRectangle(0, 0, GetScreenWidth()~/2, 30, Fade(RAYWHITE, 0.6.f));
            DrawText("PLAYER2: UP/DOWN/LEFT/RIGHT to move", 10, 10, 10, DARKBLUE);
            
        EndTextureMode();

        // Draw both views render textures to the screen side by side
        BeginDrawing();
            ClearBackground(BLACK);
            
            DrawTextureRec(screenCamera1.texture, splitScreenRect, Vector2(0, 0), WHITE);
            DrawTextureRec(screenCamera2.texture, splitScreenRect, Vector2(screenWidth/2.0.f, 0), WHITE);
            
            DrawRectangle(GetScreenWidth()~/2 - 2, 0, 4, GetScreenHeight(), LIGHTGRAY);
        EndDrawing();
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    UnloadRenderTexture(screenCamera1); // Unload render texture
    UnloadRenderTexture(screenCamera2); // Unload render texture

    CloseWindow();                      // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
