export 'src/raylib.dart';
export 'src/raylib_const.dart';
export 'src/raylib.g.dart'
    hide
        ///
        Camera,
        Camera2D,
        Camera3D,
        Vector2,
        Vector3,
        Vector4,
        Matrix,
        Ray,
        Color,
        Rectangle,
        Quaternion,
        ///: rcore
        /// Window-related functions
        InitWindow,
        CloseWindow,
        IsWindowState,
        SetWindowState,
        ClearWindowState,
        SetWindowIcon, // TODO:
        SetWindowIcons, // TODO:
        SetWindowTitle,
        GetWindowHandle, // TODO:
        GetMonitorName,
        SetClipboardText,
        GetClipboardText,
        /// Drawing-related functions
        ClearBackground,
        BeginMode2D,
        BeginMode3D,
        /// Shader management functions
        LoadShader,
        LoadShaderFromMemory,
        GetShaderLocation, // TODO:
        GetShaderLocationAttrib, // TODO:
        SetShaderValue, // TODO:
        SetShaderValueV, // TODO:
        SetShaderValueMatrix, // TODO:
        SetShaderValueTexture, // TODO:
        UnloadShader, // TODO:
        /// Screen-space-related functions
        GetScreenToWorldRay,
        GetScreenToWorldRayEx,
        GetWorldToScreen,
        GetWorldToScreenEx,
        GetWorldToScreen2D,
        GetScreenToWorld2D,
        GetCameraMatrix,
        GetCameraMatrix2D,
        /// Random values generation functions
        LoadRandomSequence, // merge
        UnloadRandomSequence, // merge
        /// Misc. functions
        TakeScreenshot,
        SetConfigFlags,
        OpenURL,
        /// utils
        TraceLog, // delete
        SetTraceLogLevel,
        MemAlloc, // delete
        MemRealloc, // delete
        MemFree, // delete
        /// Set custom callbacks
        SetTraceLogCallback, // TODO:
        SetLoadFileDataCallback,
        SetSaveFileDataCallback,
        SetLoadFileTextCallback,
        SetSaveFileTextCallback,
        /// Files management functions
        LoadFileData, // delete
        UnloadFileData, // delete
        SaveFileData, // delete
        ExportDataAsCode, // delete
        LoadFileText, // delete
        UnloadFileText, // delete
        SaveFileText, // delete
        /// File system functions
        FileExists, // TODO
        DirectoryExists, // TODO
        IsFileExtension, // TODO
        GetFileLength, // TODO
        GetFileExtension, // TODO
        GetFileName, // TODO
        GetFileNameWithoutExt, // TODO
        GetDirectoryPath, // TODO
        GetPrevDirectoryPath, // TODO
        GetWorkingDirectory, // TODO
        GetApplicationDirectory, // TODO
        MakeDirectory, // TODO
        ChangeDirectory, // TODO
        IsPathFile, // TODO
        IsFileNameValid, // TODO
        LoadDirectoryFiles, // TODO
        LoadDirectoryFilesEx, // TODO
        UnloadDirectoryFiles, // TODO
        IsFileDropped, // TODO
        LoadDroppedFiles, // TODO
        UnloadDroppedFiles, // TODO
        GetFileModTime, // TODO
        /// Compression/Encoding functionality
        CompressData, // TODO
        DecompressData, // TODO
        EncodeDataBase64, // TODO
        DecodeDataBase64, // TODO
        ComputeCRC32, // TODO
        ComputeMD5, // TODO
        ComputeSHA1, // TODO
        /// Automation events functionality
        LoadAutomationEventList, // TODO
        UnloadAutomationEventList, // TODO
        ExportAutomationEventList, // TODO
        SetAutomationEventList, // TODO
        SetAutomationEventBaseFrame, // TODO
        StartAutomationEventRecording, // TODO
        StopAutomationEventRecording, // TODO
        PlayAutomationEvent, // TODO
        /// Input-related functions: keyboard
        IsKeyPressed,
        IsKeyPressedRepeat,
        IsKeyDown,
        IsKeyReleased,
        IsKeyUp,
        GetKeyPressed,
        GetCharPressed,
        SetExitKey,
        /// Input-related functions: gamepads
        GetGamepadName,
        IsGamepadButtonPressed,
        IsGamepadButtonDown,
        IsGamepadButtonReleased,
        IsGamepadButtonUp,
        GetGamepadButtonPressed,
        GetGamepadAxisMovement,
        SetGamepadMappings, // delete
        /// Input-related functions: mouse
        IsMouseButtonPressed,
        IsMouseButtonDown,
        IsMouseButtonReleased,
        IsMouseButtonUp,
        GetMousePosition,
        GetMouseDelta,
        GetMouseWheelMoveV,
        SetMouseCursor,
        /// Input-related functions: touch
        GetTouchPosition,
        /// Gestures and Touch Handling Functions
        SetGesturesEnabled, // TODO
        IsGestureDetected,
        GetGestureDetected,
        GetGestureDragVector,
        GetGesturePinchVector,
        /// Camera System Functions
        UpdateCamera,
        UpdateCameraPro,
        ///: rshapes
        /// Set texture and rectangle to be used on shapes drawing
        SetShapesTexture, // TODO
        GetShapesTexture, // TODO
        GetShapesTextureRectangle, // TODO
        /// Basic shapes drawing functions
        DrawPixel,
        DrawPixelV,
        DrawLine,
        DrawLineV,
        DrawLineEx,
        DrawLineStrip,
        DrawLineBezier,
        DrawCircle,
        DrawCircleSector,
        DrawCircleSectorLines,
        DrawCircleGradient,
        DrawCircleV,
        DrawCircleLines,
        DrawCircleLinesV,
        DrawEllipse,
        DrawEllipseLines,
        DrawRing,
        DrawRingLines,
        DrawRectangle,
        DrawRectangleV,
        DrawRectangleRec,
        DrawRectanglePro,
        DrawRectangleGradientV,
        DrawRectangleGradientH,
        DrawRectangleGradientEx,
        DrawRectangleLines,
        DrawRectangleLinesEx,
        DrawRectangleRounded,
        DrawRectangleRoundedLines,
        DrawRectangleRoundedLinesEx,
        DrawTriangle,
        DrawTriangleLines,
        DrawTriangleFan,
        DrawTriangleStrip,
        DrawPoly,
        DrawPolyLines,
        DrawPolyLinesEx,
        /// Splines drawing functions
        DrawSplineLinear,
        DrawSplineBasis,
        DrawSplineCatmullRom,
        DrawSplineBezierQuadratic,
        DrawSplineBezierCubic,
        DrawSplineSegmentLinear,
        DrawSplineSegmentBasis,
        DrawSplineSegmentCatmullRom,
        DrawSplineSegmentBezierQuadratic,
        DrawSplineSegmentBezierCubic,
        /// Spline segment point evaluation functions
        GetSplinePointLinear,
        GetSplinePointBasis,
        GetSplinePointCatmullRom,
        GetSplinePointBezierQuad,
        GetSplinePointBezierCubic,
        /// Basic shapes collision detection functions
        CheckCollisionRecs,
        CheckCollisionCircles,
        CheckCollisionCircleRec,
        CheckCollisionPointRec,
        CheckCollisionCircleLine,
        CheckCollisionPointCircle,
        CheckCollisionPointTriangle,
        CheckCollisionPointLine,
        CheckCollisionPointPoly,
        CheckCollisionLines,
        GetCollisionRec,
        /// Texture loading functions
        LoadTexture,
        /// Texture drawing functions
        DrawTexture,
        /// Text strings management functions
        TextToLower,
        TextFindIndex,
        TextFormat,
        /// Color/pixel related functions
        Fade,
        /// Text drawing functions
        DrawText,
        DrawTextEx;
export 'src/color.dart';
export 'package:vector_math/vector_math.dart';
export 'src/rectangle.dart';
export 'src/camera.dart';
export 'src/callback.dart';
export 'src/math.dart';
export 'src/text.dart';
export 'src/c.dart';
