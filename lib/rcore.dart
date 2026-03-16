// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'structs.dart';

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'src/raylib_const.g.dart' as consts;
import 'package:image/image.dart' as img;
import 'package:vector_math/vector_math.dart';

// export 'src/raylib.g.dart' show InitWindow;
// export 'src/raylib.g.dart' show CloseWindow;
export 'src/raylib.g.dart' show WindowShouldClose;
export 'src/raylib.g.dart' show IsWindowReady;
export 'src/raylib.g.dart' show IsWindowFullscreen;
export 'src/raylib.g.dart' show IsWindowHidden;
export 'src/raylib.g.dart' show IsWindowMinimized;
export 'src/raylib.g.dart' show IsWindowMaximized;
export 'src/raylib.g.dart' show IsWindowFocused;
export 'src/raylib.g.dart' show IsWindowResized;
// export 'src/raylib.g.dart' show IsWindowState;
// export 'src/raylib.g.dart' show SetWindowState;
// export 'src/raylib.g.dart' show ClearWindowState;
export 'src/raylib.g.dart' show ToggleFullscreen;
export 'src/raylib.g.dart' show ToggleBorderlessWindowed;
export 'src/raylib.g.dart' show MaximizeWindow;
export 'src/raylib.g.dart' show MinimizeWindow;
export 'src/raylib.g.dart' show RestoreWindow;
// export 'src/raylib.g.dart' show SetWindowIcon;
// export 'src/raylib.g.dart' show SetWindowIcons;
// export 'src/raylib.g.dart' show SetWindowTitle;
export 'src/raylib.g.dart' show SetWindowPosition;
export 'src/raylib.g.dart' show SetWindowMonitor;
export 'src/raylib.g.dart' show SetWindowMinSize;
export 'src/raylib.g.dart' show SetWindowMaxSize;
export 'src/raylib.g.dart' show SetWindowSize;
export 'src/raylib.g.dart' show SetWindowOpacity;
export 'src/raylib.g.dart' show SetWindowFocused;
export 'src/raylib.g.dart' show GetWindowHandle;
export 'src/raylib.g.dart' show GetScreenWidth;
export 'src/raylib.g.dart' show GetScreenHeight;
export 'src/raylib.g.dart' show GetRenderWidth;
export 'src/raylib.g.dart' show GetRenderHeight;
export 'src/raylib.g.dart' show GetMonitorCount;
export 'src/raylib.g.dart' show GetCurrentMonitor;
// export 'src/raylib.g.dart' show GetMonitorPosition;
export 'src/raylib.g.dart' show GetMonitorWidth;
export 'src/raylib.g.dart' show GetMonitorHeight;
export 'src/raylib.g.dart' show GetMonitorPhysicalWidth;
export 'src/raylib.g.dart' show GetMonitorPhysicalHeight;
export 'src/raylib.g.dart' show GetMonitorRefreshRate;
export 'src/raylib.g.dart' show GetWindowPosition;
export 'src/raylib.g.dart' show GetWindowScaleDPI;
// export 'src/raylib.g.dart' show GetMonitorName;
// export 'src/raylib.g.dart' show SetClipboardText;
// export 'src/raylib.g.dart' show GetClipboardText;
export 'src/raylib.g.dart' show GetClipboardImage;
export 'src/raylib.g.dart' show EnableEventWaiting;
export 'src/raylib.g.dart' show DisableEventWaiting;
export 'src/raylib.g.dart' show ShowCursor;
export 'src/raylib.g.dart' show HideCursor;
export 'src/raylib.g.dart' show IsCursorHidden;
export 'src/raylib.g.dart' show EnableCursor;
export 'src/raylib.g.dart' show DisableCursor;
export 'src/raylib.g.dart' show IsCursorOnScreen;
export 'src/raylib.g.dart' show ClearBackground;
export 'src/raylib.g.dart' show BeginDrawing;
export 'src/raylib.g.dart' show EndDrawing;
export 'src/raylib.g.dart' show BeginMode2D;
export 'src/raylib.g.dart' show EndMode2D;
export 'src/raylib.g.dart' show BeginMode3D;
export 'src/raylib.g.dart' show EndMode3D;
export 'src/raylib.g.dart' show BeginTextureMode;
export 'src/raylib.g.dart' show EndTextureMode;
export 'src/raylib.g.dart' show BeginShaderMode;
export 'src/raylib.g.dart' show EndShaderMode;
export 'src/raylib.g.dart' show BeginBlendMode;
export 'src/raylib.g.dart' show EndBlendMode;
export 'src/raylib.g.dart' show BeginScissorMode;
export 'src/raylib.g.dart' show EndScissorMode;
export 'src/raylib.g.dart' show BeginVrStereoMode;
export 'src/raylib.g.dart' show EndVrStereoMode;
export 'src/raylib.g.dart' show LoadVrStereoConfig;
export 'src/raylib.g.dart' show UnloadVrStereoConfig;
export 'src/raylib.g.dart' show LoadShader;
export 'src/raylib.g.dart' show LoadShaderFromMemory;
export 'src/raylib.g.dart' show IsShaderValid;
export 'src/raylib.g.dart' show GetShaderLocation;
export 'src/raylib.g.dart' show GetShaderLocationAttrib;
export 'src/raylib.g.dart' show SetShaderValue;
export 'src/raylib.g.dart' show SetShaderValueV;
export 'src/raylib.g.dart' show SetShaderValueMatrix;
export 'src/raylib.g.dart' show SetShaderValueTexture;
export 'src/raylib.g.dart' show UnloadShader;
export 'src/raylib.g.dart' show GetScreenToWorldRay;
export 'src/raylib.g.dart' show GetScreenToWorldRayEx;
export 'src/raylib.g.dart' show GetWorldToScreen;
export 'src/raylib.g.dart' show GetWorldToScreenEx;
export 'src/raylib.g.dart' show GetWorldToScreen2D;
export 'src/raylib.g.dart' show GetScreenToWorld2D;
export 'src/raylib.g.dart' show GetCameraMatrix;
export 'src/raylib.g.dart' show GetCameraMatrix2D;
export 'src/raylib.g.dart' show SetTargetFPS;
export 'src/raylib.g.dart' show GetFrameTime;
export 'src/raylib.g.dart' show GetTime;
export 'src/raylib.g.dart' show GetFPS;
export 'src/raylib.g.dart' show SwapScreenBuffer;
export 'src/raylib.g.dart' show PollInputEvents;
export 'src/raylib.g.dart' show WaitTime;
export 'src/raylib.g.dart' show SetRandomSeed;
export 'src/raylib.g.dart' show GetRandomValue;
export 'src/raylib.g.dart' show LoadRandomSequence;
export 'src/raylib.g.dart' show UnloadRandomSequence;
export 'src/raylib.g.dart' show TakeScreenshot;
export 'src/raylib.g.dart' show SetConfigFlags;
export 'src/raylib.g.dart' show OpenURL;
export 'src/raylib.g.dart' show TraceLog;
export 'src/raylib.g.dart' show SetTraceLogLevel;
export 'src/raylib.g.dart' show MemAlloc;
export 'src/raylib.g.dart' show MemRealloc;
export 'src/raylib.g.dart' show MemFree;
export 'src/raylib.g.dart' show SetTraceLogCallback;
export 'src/raylib.g.dart' show SetLoadFileDataCallback;
export 'src/raylib.g.dart' show SetSaveFileDataCallback;
export 'src/raylib.g.dart' show SetLoadFileTextCallback;
export 'src/raylib.g.dart' show SetSaveFileTextCallback;
export 'src/raylib.g.dart' show LoadFileData;
export 'src/raylib.g.dart' show UnloadFileData;
export 'src/raylib.g.dart' show SaveFileData;
export 'src/raylib.g.dart' show ExportDataAsCode;
export 'src/raylib.g.dart' show LoadFileText;
export 'src/raylib.g.dart' show UnloadFileText;
export 'src/raylib.g.dart' show SaveFileText;
export 'src/raylib.g.dart' show FileExists;
export 'src/raylib.g.dart' show DirectoryExists;
export 'src/raylib.g.dart' show IsFileExtension;
export 'src/raylib.g.dart' show GetFileLength;
export 'src/raylib.g.dart' show GetFileExtension;
export 'src/raylib.g.dart' show GetFileName;
export 'src/raylib.g.dart' show GetFileNameWithoutExt;
export 'src/raylib.g.dart' show GetDirectoryPath;
export 'src/raylib.g.dart' show GetPrevDirectoryPath;
export 'src/raylib.g.dart' show GetWorkingDirectory;
export 'src/raylib.g.dart' show GetApplicationDirectory;
export 'src/raylib.g.dart' show MakeDirectory;
export 'src/raylib.g.dart' show ChangeDirectory;
export 'src/raylib.g.dart' show IsPathFile;
export 'src/raylib.g.dart' show IsFileNameValid;
export 'src/raylib.g.dart' show LoadDirectoryFiles;
export 'src/raylib.g.dart' show LoadDirectoryFilesEx;
export 'src/raylib.g.dart' show UnloadDirectoryFiles;
export 'src/raylib.g.dart' show IsFileDropped;
export 'src/raylib.g.dart' show LoadDroppedFiles;
export 'src/raylib.g.dart' show UnloadDroppedFiles;
export 'src/raylib.g.dart' show GetFileModTime;
export 'src/raylib.g.dart' show CompressData;
export 'src/raylib.g.dart' show DecompressData;
export 'src/raylib.g.dart' show EncodeDataBase64;
export 'src/raylib.g.dart' show DecodeDataBase64;
export 'src/raylib.g.dart' show ComputeCRC32;
export 'src/raylib.g.dart' show ComputeMD5;
export 'src/raylib.g.dart' show ComputeSHA1;
export 'src/raylib.g.dart' show LoadAutomationEventList;
export 'src/raylib.g.dart' show UnloadAutomationEventList;
export 'src/raylib.g.dart' show ExportAutomationEventList;
export 'src/raylib.g.dart' show SetAutomationEventList;
export 'src/raylib.g.dart' show SetAutomationEventBaseFrame;
export 'src/raylib.g.dart' show StartAutomationEventRecording;
export 'src/raylib.g.dart' show StopAutomationEventRecording;
export 'src/raylib.g.dart' show PlayAutomationEvent;
export 'src/raylib.g.dart' show IsKeyPressed;
export 'src/raylib.g.dart' show IsKeyPressedRepeat;
export 'src/raylib.g.dart' show IsKeyDown;
export 'src/raylib.g.dart' show IsKeyReleased;
export 'src/raylib.g.dart' show IsKeyUp;
export 'src/raylib.g.dart' show GetKeyPressed;
export 'src/raylib.g.dart' show GetCharPressed;
export 'src/raylib.g.dart' show SetExitKey;
export 'src/raylib.g.dart' show IsGamepadAvailable;
export 'src/raylib.g.dart' show GetGamepadName;
export 'src/raylib.g.dart' show IsGamepadButtonPressed;
export 'src/raylib.g.dart' show IsGamepadButtonDown;
export 'src/raylib.g.dart' show IsGamepadButtonReleased;
export 'src/raylib.g.dart' show IsGamepadButtonUp;
export 'src/raylib.g.dart' show GetGamepadButtonPressed;
export 'src/raylib.g.dart' show GetGamepadAxisCount;
export 'src/raylib.g.dart' show GetGamepadAxisMovement;
export 'src/raylib.g.dart' show SetGamepadMappings;
export 'src/raylib.g.dart' show SetGamepadVibration;
export 'src/raylib.g.dart' show IsMouseButtonPressed;
export 'src/raylib.g.dart' show IsMouseButtonDown;
export 'src/raylib.g.dart' show IsMouseButtonReleased;
export 'src/raylib.g.dart' show IsMouseButtonUp;
export 'src/raylib.g.dart' show GetMouseX;
export 'src/raylib.g.dart' show GetMouseY;
export 'src/raylib.g.dart' show GetMousePosition;
export 'src/raylib.g.dart' show GetMouseDelta;
export 'src/raylib.g.dart' show SetMousePosition;
export 'src/raylib.g.dart' show SetMouseOffset;
export 'src/raylib.g.dart' show SetMouseScale;
export 'src/raylib.g.dart' show GetMouseWheelMove;
export 'src/raylib.g.dart' show GetMouseWheelMoveV;
export 'src/raylib.g.dart' show SetMouseCursor;
export 'src/raylib.g.dart' show GetTouchX;
export 'src/raylib.g.dart' show GetTouchY;
export 'src/raylib.g.dart' show GetTouchPosition;
export 'src/raylib.g.dart' show GetTouchPointId;
export 'src/raylib.g.dart' show GetTouchPointCount;
export 'src/raylib.g.dart' show SetGesturesEnabled;
export 'src/raylib.g.dart' show IsGestureDetected;
export 'src/raylib.g.dart' show GetGestureDetected;
export 'src/raylib.g.dart' show GetGestureHoldDuration;
export 'src/raylib.g.dart' show GetGestureDragVector;
export 'src/raylib.g.dart' show GetGestureDragAngle;
export 'src/raylib.g.dart' show GetGesturePinchVector;
export 'src/raylib.g.dart' show GetGesturePinchAngle;
export 'src/raylib.g.dart' show UpdateCamera;
export 'src/raylib.g.dart' show UpdateCameraPro;

/// Window-related functions
final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raylib.CloseWindow();
  if (_titleStack.isNotEmpty) ffi.malloc.free(_titleStack.removeLast());
}

extension type const ConfigFlags(int value) {
  static const vsyncHint = ConfigFlags(64);
  static const fullscreenMode = ConfigFlags(2);
  static const windowResizable = ConfigFlags(4);
  static const windowUndecorated = ConfigFlags(8);
  static const windowHidden = ConfigFlags(128);
  static const windowMinimized = ConfigFlags(512);
  static const windowMaximized = ConfigFlags(1024);
  static const windowUnfocused = ConfigFlags(2048);
  static const windowTopmost = ConfigFlags(4096);
  static const windowAlwaysRun = ConfigFlags(256);
  static const windowTransparent = ConfigFlags(16);
  static const windowHighdpi = ConfigFlags(8192);
  static const windowMousePassthrough = ConfigFlags(16384);
  static const borderlessWindowedMode = ConfigFlags(32768);
  static const msaa4xHint = ConfigFlags(32);
  static const interlacedHint = ConfigFlags(65536);

  ConfigFlags operator |(ConfigFlags other) => ConfigFlags(value | other.value);
  ConfigFlags operator &(ConfigFlags other) => ConfigFlags(value & other.value);
}

@Deprecated('Use .vsyncHint instead')
const ConfigFlags FLAG_VSYNC_HINT = .vsyncHint;

@Deprecated('Use .fullscreenMode instead')
const ConfigFlags FLAG_FULLSCREEN_MODE = .fullscreenMode;

@Deprecated('Use .windowResizable instead')
const ConfigFlags FLAG_WINDOW_RESIZABLE = .windowResizable;

@Deprecated('Use .windowUndecorated instead')
const ConfigFlags FLAG_WINDOW_UNDECORATED = .windowUndecorated;

@Deprecated('Use .windowHidden instead')
const ConfigFlags FLAG_WINDOW_HIDDEN = .windowHidden;

@Deprecated('Use .windowMinimized instead')
const ConfigFlags FLAG_WINDOW_MINIMIZED = .windowMinimized;

@Deprecated('Use .windowMaximized instead')
const ConfigFlags FLAG_WINDOW_MAXIMIZED = .windowMaximized;

@Deprecated('Use .windowUnfocused instead')
const ConfigFlags FLAG_WINDOW_UNFOCUSED = .windowUnfocused;

@Deprecated('Use .windowTopmost instead')
const ConfigFlags FLAG_WINDOW_TOPMOST = .windowTopmost;

@Deprecated('Use .windowAlwaysRun instead')
const ConfigFlags FLAG_WINDOW_ALWAYS_RUN = .windowAlwaysRun;

@Deprecated('Use .windowTransparent instead')
const ConfigFlags FLAG_WINDOW_TRANSPARENT = .windowTransparent;

@Deprecated('Use .windowHighdpi instead')
const ConfigFlags FLAG_WINDOW_HIGHDPI = .windowHighdpi;

@Deprecated('Use .windowMousePassthrough instead')
const ConfigFlags FLAG_WINDOW_MOUSE_PASSTHROUGH = .windowMousePassthrough;

@Deprecated('Use .borderlessWindowedMode instead')
const ConfigFlags FLAG_BORDERLESS_WINDOWED_MODE = .borderlessWindowedMode;

@Deprecated('Use .msaa4xHint instead')
const ConfigFlags FLAG_MSAA_4X_HINT = .msaa4xHint;

@Deprecated('Use .interlacedHint instead')
const ConfigFlags FLAG_INTERLACED_HINT = .interlacedHint;

bool IsWindowState(ConfigFlags flags) => raylib.IsWindowState(flags.value);
void SetWindowState(ConfigFlags flags) => raylib.SetWindowState(flags.value);
void ClearWindowState(ConfigFlags flags) =>
    raylib.ClearWindowState(flags.value);

void SetWindowIcon(img.Image image) {
  ffi.using((arena) {
    raylib.SetWindowIcon(arena.image(image).ref);
  });
}

void SetWindowIcons(List<img.Image> images, [int? count]) {
  count ??= images.length;
  ffi.using((arena) {
    final imageArray = arena<raylib.Image>(count!);
    for (var i = 0; i < count; i++) {
      final imgPtr = arena.image(images[i]);
      (imageArray + i).ref
        ..data = imgPtr.ref.data
        ..width = imgPtr.ref.width
        ..height = imgPtr.ref.height
        ..mipmaps = imgPtr.ref.mipmaps
        ..format = imgPtr.ref.format;
    }
    raylib.SetWindowIcons(imageArray, count);
  });
}

void SetWindowTitle(String title) {
  if (_titleStack.isNotEmpty) {
    ffi.malloc.free(_titleStack.removeLast());
  }
  _titleStack.add(title.toNativeUtf8().cast());
  raylib.SetWindowTitle(_titleStack.last);
}

Vector2 GetMonitorPosition(int monitor) =>
    raylib.GetMonitorPosition(monitor).toDart();

String GetMonitorName(int monitor) =>
    raylib.GetMonitorName(monitor).cast<ffi.Utf8>().toDartString();

void SetClipboardText(String text) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  try {
    raylib.SetClipboardText(textPtr);
  } finally {
    ffi.malloc.free(textPtr);
  }
}

String GetClipboardText() =>
    raylib.GetClipboardText().cast<ffi.Utf8>().toDartString();