/*******************************************************************************************
*
*   raylib [core] example - 2D Camera platformer
*
*   Example originally created with raylib 2.5, last time updated with raylib 3.0
*
*   Example contributed by arvyy (@arvyy) and reviewed by Ramon Santamaria (@raysan5)
*
*   Example licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software
*
*   Copyright (c) 2019-2024 arvyy (@arvyy)
*
********************************************************************************************/

import "package:raylib_dart/raylib_dart.dart";

import "package:raylib_dart/raymath.dart";

const G = 400;
const PLAYER_JUMP_SPD = 350.0;
const PLAYER_HOR_SPD = 200.0;

class Player {
    Vector2 position;
    float speed;
    bool canJump;
    Player(this.position, this.speed, this.canJump);
}

class EnvItem {
    Rectangle rect;
    bool blocking;
    Color color;

    EnvItem(this.rect, this.blocking, this.color);
}

//----------------------------------------------------------------------------------
// Module functions declaration
//----------------------------------------------------------------------------------
// void UpdatePlayer(Player *player, List<EnvItem> envItems, int envItemsLength, float delta);
// void UpdateCameraCenter(Camera2D *camera, Player *player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height);
// void UpdateCameraCenterInsideMap(Camera2D *camera, Player *player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height);
// void UpdateCameraCenterSmoothFollow(Camera2D *camera, Player *player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height);
// void UpdateCameraEvenOutOnLanding(Camera2D *camera, Player *player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height);
// void UpdateCameraPlayerBoundsPush(Camera2D *camera, Player *player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height);

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main()
{
    // Initialization
    //--------------------------------------------------------------------------------------
    const int screenWidth = 800;
    const int screenHeight = 450;

    InitWindow(screenWidth, screenHeight, "raylib [core] example - 2d camera");

    Player player = Player(.zero(), 0, false);
    player.position = Vector2(400, 280);
    player.speed = 0;
    player.canJump = false;
    List<EnvItem> envItems = [
        EnvItem(.fromLTWH(0, 0, 1000, 400), false, LIGHTGRAY),
        EnvItem(.fromLTWH(0, 400, 1000, 200), true, GRAY),
        EnvItem(.fromLTWH(300, 200, 400, 10), true, GRAY),
        EnvItem(.fromLTWH(250, 300, 100, 10), true, GRAY),
        EnvItem(.fromLTWH(650, 300, 100, 10), true, GRAY)
    ];

    int envItemsLength = envItems.length;

    Camera2D camera = Camera2D();
    camera.target = player.position;
    camera.offset = Vector2(screenWidth/2.0.f, screenHeight/2.0.f);
    camera.rotation = 0.0.f;
    camera.zoom = 1.0.f;

    // Store pointers to the multiple update camera functions
    List<void Function(Camera2D, Player, List<EnvItem>, int, float, int, int)> cameraUpdaters = [
        UpdateCameraCenter,
        UpdateCameraCenterInsideMap,
        UpdateCameraCenterSmoothFollow,
        UpdateCameraEvenOutOnLanding,
        UpdateCameraPlayerBoundsPush
    ];

    int cameraOption = 0;
    int cameraUpdatersLength = cameraUpdaters.length;

    List<String> cameraDescriptions = [
        "Follow player center",
        "Follow player center, but clamp to map edges",
        "Follow player center; smoothed",
        "Follow player center horizontally; update player center vertically after landing",
        "Player push camera on getting too close to screen edge"
    ];

    SetTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!WindowShouldClose())
    {
        // Update
        //----------------------------------------------------------------------------------
        float deltaTime = GetFrameTime();

        UpdatePlayer(player, envItems, envItemsLength, deltaTime);

        camera.zoom += (GetMouseWheelMove()*0.05.f);

        if (camera.zoom > 3.0.f) camera.zoom = 3.0.f;
        else if (camera.zoom < 0.25.f) camera.zoom = 0.25.f;

        if (IsKeyPressed(KEY_R))
        {
            camera.zoom = 1.0.f;
            player.position = Vector2(400, 280);
        }

        if (IsKeyPressed(KEY_C)) cameraOption = (cameraOption + 1)%cameraUpdatersLength;

        // Call update camera function by its pointer
        cameraUpdaters[cameraOption](camera, player, envItems, envItemsLength, deltaTime, screenWidth, screenHeight);
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(LIGHTGRAY);

            BeginMode2D(camera);

                for (int i = 0; i < envItemsLength; i++) DrawRectangleRec(envItems[i].rect, envItems[i].color);

                Rectangle playerRect = .fromLTWH(player.position.x - 20, player.position.y - 40, 40.0.f, 40.0.f);
                DrawRectangleRec(playerRect, RED);
                
                DrawCircleV(player.position, 5.0.f, GOLD);

            EndMode2D();

            DrawText("Controls:", 20, 20, 10, BLACK);
            DrawText("- Right/Left to move", 40, 40, 10, DARKGRAY);
            DrawText("- Space to jump", 40, 60, 10, DARKGRAY);
            DrawText("- Mouse Wheel to Zoom in-out, R to reset zoom", 40, 80, 10, DARKGRAY);
            DrawText("- C to change camera mode", 40, 100, 10, DARKGRAY);
            DrawText("Current camera mode:", 20, 120, 10, BLACK);
            DrawText(cameraDescriptions[cameraOption], 40, 140, 10, DARKGRAY);

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}

void UpdatePlayer(Player player, List<EnvItem> envItems, int envItemsLength, float delta)
{
    if (IsKeyDown(KEY_LEFT)) player.position.x -= PLAYER_HOR_SPD*delta;
    if (IsKeyDown(KEY_RIGHT)) player.position.x += PLAYER_HOR_SPD*delta;
    if (IsKeyDown(KEY_SPACE) && player.canJump)
    {
        player.speed = -PLAYER_JUMP_SPD;
        player.canJump = false;
    }

    bool hitObstacle = false;
    for (int i = 0; i < envItemsLength; i++)
    {
        EnvItem ei = envItems[i];
        Vector2 p = (player.position);
        if (ei.blocking &&
            ei.rect.x <= p.x &&
            ei.rect.x + ei.rect.width >= p.x &&
            ei.rect.y >= p.y &&
            ei.rect.y <= p.y + player.speed*delta)
        {
            hitObstacle = true;
            player.speed = 0.0.f;
            player.position.y = ei.rect.y;
            break;
        }
    }

    if (!hitObstacle)
    {
        player.position.y += player.speed*delta;
        player.speed += G*delta;
        player.canJump = false;
    }
    else player.canJump = true;
}

void UpdateCameraCenter(Camera2D camera, Player player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height)
{
    camera.offset = Vector2(width/2.0.f, height/2.0.f);
    camera.target = player.position;
}

void UpdateCameraCenterInsideMap(Camera2D camera, Player player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height)
{
    camera.target = player.position;
    camera.offset = Vector2(width/2.0.f, height/2.0.f);
    float minX = 1000, minY = 1000, maxX = -1000, maxY = -1000;

    for (int i = 0; i < envItemsLength; i++)
    {
        EnvItem ei = envItems[i];
        minX = fminf(ei.rect.x, minX);
        maxX = fmaxf(ei.rect.x + ei.rect.width, maxX);
        minY = fminf(ei.rect.y, minY);
        maxY = fmaxf(ei.rect.y + ei.rect.height, maxY);
    }

    Vector2 max = GetWorldToScreen2D(Vector2(maxX, maxY), camera);
    Vector2 min = GetWorldToScreen2D(Vector2(minX, minY), camera);

    if (max.x < width) camera.offset.x = width - (max.x - width/2);
    if (max.y < height) camera.offset.y = height - (max.y - height/2);
    if (min.x > 0) camera.offset.x = width/2 - min.x;
    if (min.y > 0) camera.offset.y = height/2 - min.y;
}

float minSpeed = 30;
float minEffectLength = 10;
float fractionSpeed = 0.8.f;
void UpdateCameraCenterSmoothFollow(Camera2D camera, Player player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height)
{

    camera.offset = Vector2(width/2.0.f, height/2.0.f);
    Vector2 diff = Vector2Subtract(player.position, camera.target);
    float length = Vector2Length(diff);

    if (length > minEffectLength)
    {
        float speed = fmaxf(fractionSpeed*length, minSpeed);
        camera.target = Vector2Add(camera.target, Vector2Scale(diff, speed*delta/length));
    }
}

float evenOutSpeed = 700;
bool eveningOut = false;
float evenOutTarget = 0.0;
void UpdateCameraEvenOutOnLanding(Camera2D camera, Player player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height)
{

    camera.offset = Vector2(width/2.0.f, height/2.0.f);
    camera.target.x = player.position.x;

    if (eveningOut)
    {
        if (evenOutTarget > camera.target.y)
        {
            camera.target.y += evenOutSpeed*delta;

            if (camera.target.y > evenOutTarget)
            {
                camera.target.y = evenOutTarget;
                eveningOut = false;
            }
        }
        else
        {
            camera.target.y -= evenOutSpeed*delta;

            if (camera.target.y < evenOutTarget)
            {
                camera.target.y = evenOutTarget;
                eveningOut = false;
            }
        }
    }
    else
    {
        if (player.canJump && (player.speed == 0) && (player.position.y != camera.target.y))
        {
            eveningOut = true;
            evenOutTarget = player.position.y;
        }
    }
}

Vector2 bbox = Vector2(0.2.f, 0.2.f);
void UpdateCameraPlayerBoundsPush(Camera2D camera, Player player, List<EnvItem> envItems, int envItemsLength, float delta, int width, int height)
{

    Vector2 bboxWorldMin = GetScreenToWorld2D(Vector2((1 - bbox.x)*0.5.f*width, (1 - bbox.y)*0.5.f*height), camera);
    Vector2 bboxWorldMax = GetScreenToWorld2D(Vector2((1 + bbox.x)*0.5.f*width, (1 + bbox.y)*0.5.f*height), camera);
    camera.offset = Vector2((1 - bbox.x)*0.5.f * width, (1 - bbox.y)*0.5.f*height);

    if (player.position.x < bboxWorldMin.x) camera.target.x = player.position.x;
    if (player.position.y < bboxWorldMin.y) camera.target.y = player.position.y;
    if (player.position.x > bboxWorldMax.x) camera.target.x = bboxWorldMin.x + (player.position.x - bboxWorldMax.x);
    if (player.position.y > bboxWorldMax.y) camera.target.y = bboxWorldMin.y + (player.position.y - bboxWorldMax.y);
}
