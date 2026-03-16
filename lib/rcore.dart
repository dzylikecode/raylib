// ignore_for_file: non_constant_identifier_names
// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'src/raylib_const.g.dart' as consts;
import 'package:image/image.dart' as img;
import 'package:vector_math/vector_math.dart';
import 'colors.dart';
import 'structs.dart';

// ── Window ─────────────────────────────────────────────────────────────
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
// ── Monitor ────────────────────────────────────────────────────────────
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
// export 'src/raylib.g.dart' show GetWindowPosition;
// export 'src/raylib.g.dart' show GetWindowScaleDPI;
// export 'src/raylib.g.dart' show GetMonitorName;
// ── Clipboard ──────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show SetClipboardText;
// export 'src/raylib.g.dart' show GetClipboardText;
// export 'src/raylib.g.dart' show GetClipboardImage;
// ── Cursor ─────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show EnableEventWaiting;
export 'src/raylib.g.dart' show DisableEventWaiting;
export 'src/raylib.g.dart' show ShowCursor;
export 'src/raylib.g.dart' show HideCursor;
export 'src/raylib.g.dart' show IsCursorHidden;
export 'src/raylib.g.dart' show EnableCursor;
export 'src/raylib.g.dart' show DisableCursor;
export 'src/raylib.g.dart' show IsCursorOnScreen;
// ── Drawing ────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show ClearBackground;
export 'src/raylib.g.dart' show BeginDrawing;
export 'src/raylib.g.dart' show EndDrawing;
// export 'src/raylib.g.dart' show BeginMode2D;
export 'src/raylib.g.dart' show EndMode2D;
// export 'src/raylib.g.dart' show BeginMode3D;
export 'src/raylib.g.dart' show EndMode3D;
// export 'src/raylib.g.dart' show BeginTextureMode;
export 'src/raylib.g.dart' show EndTextureMode;
// export 'src/raylib.g.dart' show BeginShaderMode;
export 'src/raylib.g.dart' show EndShaderMode;
// export 'src/raylib.g.dart' show BeginBlendMode;
export 'src/raylib.g.dart' show EndBlendMode;
export 'src/raylib.g.dart' show BeginScissorMode;
export 'src/raylib.g.dart' show EndScissorMode;
// ── VR ─────────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show BeginVrStereoMode;
export 'src/raylib.g.dart' show EndVrStereoMode;
// export 'src/raylib.g.dart' show LoadVrStereoConfig;
// export 'src/raylib.g.dart' show UnloadVrStereoConfig;
// ── Shader ─────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadShader;
// export 'src/raylib.g.dart' show LoadShaderFromMemory;
// export 'src/raylib.g.dart' show IsShaderValid;
// export 'src/raylib.g.dart' show GetShaderLocation;
// export 'src/raylib.g.dart' show GetShaderLocationAttrib;
// export 'src/raylib.g.dart' show SetShaderValue;
// export 'src/raylib.g.dart' show SetShaderValueV;
// export 'src/raylib.g.dart' show SetShaderValueMatrix;
// export 'src/raylib.g.dart' show SetShaderValueTexture;
// export 'src/raylib.g.dart' show UnloadShader;
// ── Camera/world projections ────────────────────────────────────────────
// export 'src/raylib.g.dart' show GetScreenToWorldRay;
// export 'src/raylib.g.dart' show GetScreenToWorldRayEx;
// export 'src/raylib.g.dart' show GetWorldToScreen;
// export 'src/raylib.g.dart' show GetWorldToScreenEx;
// export 'src/raylib.g.dart' show GetWorldToScreen2D;
// export 'src/raylib.g.dart' show GetScreenToWorld2D;
// export 'src/raylib.g.dart' show GetCameraMatrix;
// export 'src/raylib.g.dart' show GetCameraMatrix2D;
// ── Timing ─────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show SetTargetFPS;
export 'src/raylib.g.dart' show GetFrameTime;
export 'src/raylib.g.dart' show GetTime;
export 'src/raylib.g.dart' show GetFPS;
export 'src/raylib.g.dart' show SwapScreenBuffer;
export 'src/raylib.g.dart' show PollInputEvents;
export 'src/raylib.g.dart' show WaitTime;
// ── Random ─────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show SetRandomSeed;
export 'src/raylib.g.dart' show GetRandomValue;
// export 'src/raylib.g.dart' show LoadRandomSequence;
// export 'src/raylib.g.dart' show UnloadRandomSequence;
// ── Misc ───────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show TakeScreenshot;
export 'src/raylib.g.dart' show SetConfigFlags;
// export 'src/raylib.g.dart' show OpenURL;
// export 'src/raylib.g.dart' show TraceLog;
export 'src/raylib.g.dart' show SetTraceLogLevel;
// export 'src/raylib.g.dart' show MemAlloc;
// export 'src/raylib.g.dart' show MemRealloc;
// export 'src/raylib.g.dart' show MemFree;
// export 'src/raylib.g.dart' show SetTraceLogCallback;
// export 'src/raylib.g.dart' show SetLoadFileDataCallback;
// export 'src/raylib.g.dart' show SetSaveFileDataCallback;
// export 'src/raylib.g.dart' show SetLoadFileTextCallback;
// export 'src/raylib.g.dart' show SetSaveFileTextCallback;
export 'src/callback.dart' show SetLoadFileDataCallback;
export 'src/callback.dart' show SetSaveFileDataCallback;
export 'src/callback.dart' show SetLoadFileTextCallback;
export 'src/callback.dart' show SetSaveFileTextCallback;
// ── File I/O ───────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadFileData;
// export 'src/raylib.g.dart' show UnloadFileData;
// export 'src/raylib.g.dart' show SaveFileData;
// export 'src/raylib.g.dart' show ExportDataAsCode;
// export 'src/raylib.g.dart' show LoadFileText;
// export 'src/raylib.g.dart' show UnloadFileText;
// export 'src/raylib.g.dart' show SaveFileText;
// export 'src/raylib.g.dart' show FileExists;
// export 'src/raylib.g.dart' show DirectoryExists;
// export 'src/raylib.g.dart' show IsFileExtension;
// export 'src/raylib.g.dart' show GetFileLength;
// export 'src/raylib.g.dart' show GetFileExtension;
// export 'src/raylib.g.dart' show GetFileName;
// export 'src/raylib.g.dart' show GetFileNameWithoutExt;
// export 'src/raylib.g.dart' show GetDirectoryPath;
// export 'src/raylib.g.dart' show GetPrevDirectoryPath;
// export 'src/raylib.g.dart' show GetWorkingDirectory;
// export 'src/raylib.g.dart' show GetApplicationDirectory;
// export 'src/raylib.g.dart' show MakeDirectory;
// export 'src/raylib.g.dart' show ChangeDirectory;
// export 'src/raylib.g.dart' show IsPathFile;
// export 'src/raylib.g.dart' show IsFileNameValid;
// export 'src/raylib.g.dart' show LoadDirectoryFiles;
// export 'src/raylib.g.dart' show LoadDirectoryFilesEx;
// export 'src/raylib.g.dart' show UnloadDirectoryFiles;
export 'src/raylib.g.dart' show IsFileDropped;
// export 'src/raylib.g.dart' show LoadDroppedFiles;
// export 'src/raylib.g.dart' show UnloadDroppedFiles;
// export 'src/raylib.g.dart' show GetFileModTime;
// export 'src/raylib.g.dart' show CompressData;
// export 'src/raylib.g.dart' show DecompressData;
// export 'src/raylib.g.dart' show EncodeDataBase64;
// export 'src/raylib.g.dart' show DecodeDataBase64;
// export 'src/raylib.g.dart' show ComputeCRC32;
// export 'src/raylib.g.dart' show ComputeMD5;
// export 'src/raylib.g.dart' show ComputeSHA1;
// ── Automation ─────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadAutomationEventList;
// export 'src/raylib.g.dart' show UnloadAutomationEventList;
// export 'src/raylib.g.dart' show ExportAutomationEventList;
// export 'src/raylib.g.dart' show SetAutomationEventList;
export 'src/raylib.g.dart' show SetAutomationEventBaseFrame;
export 'src/raylib.g.dart' show StartAutomationEventRecording;
export 'src/raylib.g.dart' show StopAutomationEventRecording;
// export 'src/raylib.g.dart' show PlayAutomationEvent;
// ── Keyboard ───────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show IsKeyPressed;
export 'src/raylib.g.dart' show IsKeyPressedRepeat;
export 'src/raylib.g.dart' show IsKeyDown;
export 'src/raylib.g.dart' show IsKeyReleased;
export 'src/raylib.g.dart' show IsKeyUp;
export 'src/raylib.g.dart' show GetKeyPressed;
export 'src/raylib.g.dart' show GetCharPressed;
export 'src/raylib.g.dart' show SetExitKey;
// ── Gamepad ────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show IsGamepadAvailable;
// export 'src/raylib.g.dart' show GetGamepadName;
export 'src/raylib.g.dart' show IsGamepadButtonPressed;
export 'src/raylib.g.dart' show IsGamepadButtonDown;
export 'src/raylib.g.dart' show IsGamepadButtonReleased;
export 'src/raylib.g.dart' show IsGamepadButtonUp;
export 'src/raylib.g.dart' show GetGamepadButtonPressed;
export 'src/raylib.g.dart' show GetGamepadAxisCount;
export 'src/raylib.g.dart' show GetGamepadAxisMovement;
// export 'src/raylib.g.dart' show SetGamepadMappings;
export 'src/raylib.g.dart' show SetGamepadVibration;
// ── Mouse ──────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show IsMouseButtonPressed;
export 'src/raylib.g.dart' show IsMouseButtonDown;
export 'src/raylib.g.dart' show IsMouseButtonReleased;
export 'src/raylib.g.dart' show IsMouseButtonUp;
export 'src/raylib.g.dart' show GetMouseX;
export 'src/raylib.g.dart' show GetMouseY;
// export 'src/raylib.g.dart' show GetMousePosition;
// export 'src/raylib.g.dart' show GetMouseDelta;
export 'src/raylib.g.dart' show SetMousePosition;
export 'src/raylib.g.dart' show SetMouseOffset;
export 'src/raylib.g.dart' show SetMouseScale;
export 'src/raylib.g.dart' show GetMouseWheelMove;
// export 'src/raylib.g.dart' show GetMouseWheelMoveV;
export 'src/raylib.g.dart' show SetMouseCursor;
// ── Touch ──────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show GetTouchX;
export 'src/raylib.g.dart' show GetTouchY;
// export 'src/raylib.g.dart' show GetTouchPosition;
export 'src/raylib.g.dart' show GetTouchPointId;
export 'src/raylib.g.dart' show GetTouchPointCount;
// ── Gestures ───────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show SetGesturesEnabled;
export 'src/raylib.g.dart' show IsGestureDetected;
export 'src/raylib.g.dart' show GetGestureDetected;
export 'src/raylib.g.dart' show GetGestureHoldDuration;
// export 'src/raylib.g.dart' show GetGestureDragVector;
export 'src/raylib.g.dart' show GetGestureDragAngle;
// export 'src/raylib.g.dart' show GetGesturePinchVector;
export 'src/raylib.g.dart' show GetGesturePinchAngle;
// ── Camera update ──────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show UpdateCamera;
// export 'src/raylib.g.dart' show UpdateCameraPro;

// ── Window ─────────────────────────────────────────────────────────────

final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  return raylib.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raylib.CloseWindow();
  if (_titleStack.isNotEmpty) ffi.malloc.free(_titleStack.removeLast());
}

bool IsWindowState(consts.ConfigFlags flags) =>
    raylib.IsWindowState(flags.value);
void SetWindowState(consts.ConfigFlags flags) =>
    raylib.SetWindowState(flags.value);
void ClearWindowState(consts.ConfigFlags flags) =>
    raylib.ClearWindowState(flags.value);

void SetWindowIcon(img.Image image) => ffi.using((arena) {
  return raylib.SetWindowIcon(arena.image(image).ref);
});

void SetWindowIcons(List<img.Image> images, [int? count]) {
  count ??= images.length;
  return ffi.using((arena) {
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
    return raylib.SetWindowIcons(imageArray, count);
  });
}

void SetWindowTitle(String title) {
  if (_titleStack.isNotEmpty) {
    ffi.malloc.free(_titleStack.removeLast());
  }
  _titleStack.add(title.toNativeUtf8().cast());
  return raylib.SetWindowTitle(_titleStack.last);
}

// ── Monitor ────────────────────────────────────────────────────────────

Vector2 GetMonitorPosition(int monitor) =>
    raylib.GetMonitorPosition(monitor).toDart();

Vector2 GetWindowPosition() => raylib.GetWindowPosition().toDart();
Vector2 GetWindowScaleDPI() => raylib.GetWindowScaleDPI().toDart();

String GetMonitorName(int monitor) =>
    raylib.GetMonitorName(monitor).cast<ffi.Utf8>().toDartString();

// ── Clipboard ──────────────────────────────────────────────────────────

void SetClipboardText(String text) {
  final textPtr = text.toNativeUtf8().cast<Char>();
  try {
    return raylib.SetClipboardText(textPtr);
  } finally {
    ffi.malloc.free(textPtr);
  }
}

String GetClipboardText() =>
    raylib.GetClipboardText().cast<ffi.Utf8>().toDartString();

img.Image GetClipboardImage() => raylib.GetClipboardImage().toDart();

// ── Drawing ────────────────────────────────────────────────────────────

void ClearBackground(Color color) => raylib.ClearBackground(color.ptr.ref);

void BeginMode2D(Camera2D camera) => raylib.BeginMode2D(camera.ptr.ref);
void BeginMode3D(Camera3D camera) => raylib.BeginMode3D(camera.ptr.ref);
void BeginTextureMode(RenderTexture2D target) => ffi.using((arena) {
  return raylib.BeginTextureMode(arena.renderTexture(target).ref);
});
void BeginShaderMode(Shader shader) => raylib.BeginShaderMode(shader.ptr.ref);
void BeginBlendMode(consts.BlendMode mode) =>
    raylib.BeginBlendMode(mode.value);

// ── VR ─────────────────────────────────────────────────────────────────

VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device) => ffi.using((arena) {
  return raylib.LoadVrStereoConfig(arena.vrDeviceInfo(device).ref).toDart();
});

void UnloadVrStereoConfig(VrStereoConfig config) => config.dispose();

void BeginVrStereoMode(VrStereoConfig config) =>
    raylib.BeginVrStereoMode(config.ptr.ref);

// ── Shader ─────────────────────────────────────────────────────────────

Shader LoadShader(String? vsFileName, String? fsFileName) {
  return ffi.using((arena) {
    final vs = vsFileName?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    final fs = fsFileName?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    return raylib.LoadShader(vs, fs).toDart();
  });
}

Shader LoadShaderFromMemory(String? vsCode, String? fsCode) {
  return ffi.using((arena) {
    final vs = vsCode?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    final fs = fsCode?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    return raylib.LoadShaderFromMemory(vs, fs).toDart();
  });
}

bool IsShaderValid(Shader shader) => raylib.IsShaderValid(shader.ptr.ref);

int GetShaderLocation(Shader shader, String uniformName) => ffi.using((arena) {
  return raylib.GetShaderLocation(
    shader.ptr.ref,
    uniformName.toNativeUtf8(allocator: arena).cast(),
  );
});

int GetShaderLocationAttrib(Shader shader, String attribName) => ffi.using((arena) {
  return raylib.GetShaderLocationAttrib(
    shader.ptr.ref,
    attribName.toNativeUtf8(allocator: arena).cast(),
  );
});

void SetShaderValue(
  Shader shader,
  int locIndex,
  TypedData value,
  consts.ShaderUniformDataType uniformType,
) => ffi.using((arena) {
  final bytes = value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raylib.SetShaderValue(shader.ptr.ref, locIndex, ptr.cast(), uniformType.value);
});

void SetShaderValueV(
  Shader shader,
  int locIndex,
  TypedData value,
  consts.ShaderUniformDataType uniformType,
  int count,
) => ffi.using((arena) {
  final bytes = value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raylib.SetShaderValueV(shader.ptr.ref, locIndex, ptr.cast(), uniformType.value, count);
});

void SetShaderValueMatrix(Shader shader, int locIndex, Matrix4 mat) =>
    ffi.using((arena) {
      final m = arena<raylib.Matrix>();
      m.ref
        ..m0  = mat[0]  ..m1  = mat[1]  ..m2  = mat[2]  ..m3  = mat[3]
        ..m4  = mat[4]  ..m5  = mat[5]  ..m6  = mat[6]  ..m7  = mat[7]
        ..m8  = mat[8]  ..m9  = mat[9]  ..m10 = mat[10] ..m11 = mat[11]
        ..m12 = mat[12] ..m13 = mat[13] ..m14 = mat[14] ..m15 = mat[15];
      raylib.SetShaderValueMatrix(shader.ptr.ref, locIndex, m.ref);
    });

void SetShaderValueTexture(Shader shader, int locIndex, Texture texture) =>
    ffi.using((arena) {
      raylib.SetShaderValueTexture(shader.ptr.ref, locIndex, arena.texture(texture).ref);
    });

void UnloadShader(Shader shader) => shader.dispose();

// ── Camera/world projections ────────────────────────────────────────────

Ray GetScreenToWorldRay(Vector2 position, Camera3D camera) => ffi.using((arena) {
  return raylib.GetScreenToWorldRay(arena.vector2(position).ref, camera.ptr.ref).toDart();
});

Ray GetScreenToWorldRayEx(
  Vector2 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using((arena) {
  return raylib.GetScreenToWorldRayEx(
    arena.vector2(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart();
});

Vector2 GetWorldToScreen(Vector3 position, Camera3D camera) => ffi.using((arena) {
  return raylib.GetWorldToScreen(arena.vector3(position).ref, camera.ptr.ref).toDart();
});

Vector2 GetWorldToScreenEx(
  Vector3 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using((arena) {
  return raylib.GetWorldToScreenEx(
    arena.vector3(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart();
});

Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera) => ffi.using((arena) {
  return raylib.GetWorldToScreen2D(arena.vector2(position).ref, camera.ptr.ref).toDart();
});

Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera) => ffi.using((arena) {
  return raylib.GetScreenToWorld2D(arena.vector2(position).ref, camera.ptr.ref).toDart();
});

Matrix4 GetCameraMatrix(Camera3D camera) =>
    raylib.GetCameraMatrix(camera.ptr.ref).toDart();

Matrix4 GetCameraMatrix2D(Camera2D camera) =>
    raylib.GetCameraMatrix2D(camera.ptr.ref).toDart();

// ── Random ─────────────────────────────────────────────────────────────

List<int> LoadRandomSequence(int count, int min, int max) {
  final ptr = raylib.LoadRandomSequence(count, min, max);
  final result = List<int>.generate(count, (i) => (ptr + i).value);
  raylib.UnloadRandomSequence(ptr);
  return result;
}

@Deprecated('Memory is managed automatically by LoadRandomSequence. This is a no-op.')
void UnloadRandomSequence(List<int> sequence) {}

// ── Misc ───────────────────────────────────────────────────────────────



void TakeScreenshot(String fileName) => ffi.using((arena) {
  raylib.TakeScreenshot(fileName.toNativeUtf8(allocator: arena).cast());
});

void OpenURL(String url) => ffi.using((arena) {
  raylib.OpenURL(url.toNativeUtf8(allocator: arena).cast());
});

void TraceLog(int logLevel, String text) => ffi.using((arena) {
  raylib.TraceLog(logLevel, text.toNativeUtf8(allocator: arena).cast());
});

// ── File I/O ───────────────────────────────────────────────────────────

Uint8List LoadFileData(String fileName) {
  return ffi.using((arena) {
    final sizePtr = arena<Int>();
    final result = raylib.LoadFileData(
      fileName.toNativeUtf8(allocator: arena).cast(),
      sizePtr,
    );
    final bytes = Uint8List.fromList(result.cast<Uint8>().asTypedList(sizePtr.value));
    raylib.UnloadFileData(result);
    return bytes;
  });
}

bool SaveFileData(String fileName, Uint8List data) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    return raylib.SaveFileData(
      fileName.toNativeUtf8(allocator: arena).cast(),
      ptr.cast(),
      data.length,
    );
  });
}

bool ExportDataAsCode(Uint8List data, String fileName) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    return raylib.ExportDataAsCode(
      ptr.cast(),
      data.length,
      fileName.toNativeUtf8(allocator: arena).cast(),
    );
  });
}

String LoadFileText(String fileName) {
  return ffi.using((arena) {
    final result = raylib.LoadFileText(fileName.toNativeUtf8(allocator: arena).cast());
    final text = result.cast<ffi.Utf8>().toDartString();
    raylib.UnloadFileText(result);
    return text;
  });
}

bool SaveFileText(String fileName, String text) {
  return ffi.using((arena) {
    return raylib.SaveFileText(
      fileName.toNativeUtf8(allocator: arena).cast(),
      text.toNativeUtf8(allocator: arena).cast(),
    );
  });
}

bool FileExists(String fileName) => ffi.using((arena) {
  return raylib.FileExists(fileName.toNativeUtf8(allocator: arena).cast());
});

bool DirectoryExists(String dirPath) => ffi.using((arena) {
  return raylib.DirectoryExists(dirPath.toNativeUtf8(allocator: arena).cast());
});

bool IsFileExtension(String fileName, String ext) => ffi.using((arena) {
  return raylib.IsFileExtension(
    fileName.toNativeUtf8(allocator: arena).cast(),
    ext.toNativeUtf8(allocator: arena).cast(),
  );
});

int GetFileLength(String fileName) => ffi.using((arena) {
  return raylib.GetFileLength(fileName.toNativeUtf8(allocator: arena).cast());
});

String GetFileExtension(String fileName) => ffi.using((arena) {
  return raylib.GetFileExtension(fileName.toNativeUtf8(allocator: arena).cast())
      .cast<ffi.Utf8>().toDartString();
});

String GetFileName(String filePath) => ffi.using((arena) {
  return raylib.GetFileName(filePath.toNativeUtf8(allocator: arena).cast())
      .cast<ffi.Utf8>().toDartString();
});

String GetFileNameWithoutExt(String filePath) => ffi.using((arena) {
  return raylib.GetFileNameWithoutExt(filePath.toNativeUtf8(allocator: arena).cast())
      .cast<ffi.Utf8>().toDartString();
});

String GetDirectoryPath(String filePath) => ffi.using((arena) {
  return raylib.GetDirectoryPath(filePath.toNativeUtf8(allocator: arena).cast())
      .cast<ffi.Utf8>().toDartString();
});

String GetPrevDirectoryPath(String dirPath) => ffi.using((arena) {
  return raylib.GetPrevDirectoryPath(dirPath.toNativeUtf8(allocator: arena).cast())
      .cast<ffi.Utf8>().toDartString();
});

String GetWorkingDirectory() =>
    raylib.GetWorkingDirectory().cast<ffi.Utf8>().toDartString();

String GetApplicationDirectory() =>
    raylib.GetApplicationDirectory().cast<ffi.Utf8>().toDartString();

int MakeDirectory(String dirPath) => ffi.using((arena) {
  return raylib.MakeDirectory(dirPath.toNativeUtf8(allocator: arena).cast());
});

bool ChangeDirectory(String dir) => ffi.using((arena) {
  return raylib.ChangeDirectory(dir.toNativeUtf8(allocator: arena).cast());
});

bool IsPathFile(String path) => ffi.using((arena) {
  return raylib.IsPathFile(path.toNativeUtf8(allocator: arena).cast());
});

bool IsFileNameValid(String fileName) => ffi.using((arena) {
  return raylib.IsFileNameValid(fileName.toNativeUtf8(allocator: arena).cast());
});

List<String> LoadDirectoryFiles(String dirPath) {
  return ffi.using((arena) {
    final list = raylib.LoadDirectoryFiles(dirPath.toNativeUtf8(allocator: arena).cast());
    final result = List<String>.generate(
      list.count,
      (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
    );
    raylib.UnloadDirectoryFiles(list);
    return result;
  });
}

List<String> LoadDirectoryFilesEx(String basePath, String filter, bool scanSubdirs) {
  return ffi.using((arena) {
    final list = raylib.LoadDirectoryFilesEx(
      basePath.toNativeUtf8(allocator: arena).cast(),
      filter.toNativeUtf8(allocator: arena).cast(),
      scanSubdirs,
    );
    final result = List<String>.generate(
      list.count,
      (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
    );
    raylib.UnloadDirectoryFiles(list);
    return result;
  });
}

List<String> LoadDroppedFiles() {
  final list = raylib.LoadDroppedFiles();
  final result = List<String>.generate(
    list.count,
    (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
  );
  raylib.UnloadDroppedFiles(list);
  return result;
}

int GetFileModTime(String fileName) => ffi.using((arena) {
  return raylib.GetFileModTime(fileName.toNativeUtf8(allocator: arena).cast());
});

Uint8List CompressData(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raylib.CompressData(dataPtr.cast(), data.length, sizePtr);
    final bytes = Uint8List.fromList(result.cast<Uint8>().asTypedList(sizePtr.value));
    raylib.MemFree(result.cast());
    return bytes;
  });
}

Uint8List DecompressData(Uint8List compData) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(compData.length);
    dataPtr.asTypedList(compData.length).setAll(0, compData);
    final sizePtr = arena<Int>();
    final result = raylib.DecompressData(dataPtr.cast(), compData.length, sizePtr);
    final bytes = Uint8List.fromList(result.cast<Uint8>().asTypedList(sizePtr.value));
    raylib.MemFree(result.cast());
    return bytes;
  });
}

String EncodeDataBase64(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raylib.EncodeDataBase64(dataPtr.cast(), data.length, sizePtr);
    final str = result.cast<ffi.Utf8>().toDartString();
    raylib.MemFree(result.cast());
    return str;
  });
}

Uint8List DecodeDataBase64(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raylib.DecodeDataBase64(dataPtr.cast(), sizePtr);
    final bytes = Uint8List.fromList(result.cast<Uint8>().asTypedList(sizePtr.value));
    raylib.MemFree(result.cast());
    return bytes;
  });
}

int ComputeCRC32(Uint8List data) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    return raylib.ComputeCRC32(ptr.cast(), data.length);
  });
}

Uint8List ComputeMD5(Uint8List data) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    final result = raylib.ComputeMD5(ptr.cast(), data.length);
    return Uint8List.fromList(result.cast<Uint8>().asTypedList(16));
  });
}

Uint8List ComputeSHA1(Uint8List data) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    final result = raylib.ComputeSHA1(ptr.cast(), data.length);
    return Uint8List.fromList(result.cast<Uint8>().asTypedList(20));
  });
}

// ── Gamepad ─────────────────────────────────────────────────────────────

String GetGamepadName(int gamepad) =>
    raylib.GetGamepadName(gamepad).cast<ffi.Utf8>().toDartString();

int SetGamepadMappings(String mappings) => ffi.using((arena) {
  return raylib.SetGamepadMappings(mappings.toNativeUtf8(allocator: arena).cast());
});

// ── Mouse ──────────────────────────────────────────────────────────────

Vector2 GetMousePosition() => raylib.GetMousePosition().toDart();
Vector2 GetMouseDelta() => raylib.GetMouseDelta().toDart();
Vector2 GetMouseWheelMoveV() => raylib.GetMouseWheelMoveV().toDart();

// ── Touch ──────────────────────────────────────────────────────────────

Vector2 GetTouchPosition(int index) => raylib.GetTouchPosition(index).toDart();

// ── Gestures ───────────────────────────────────────────────────────────

Vector2 GetGestureDragVector() => raylib.GetGestureDragVector().toDart();
Vector2 GetGesturePinchVector() => raylib.GetGesturePinchVector().toDart();

// ── Camera update ──────────────────────────────────────────────────────

void UpdateCamera(Camera3D camera, int mode) => raylib.UpdateCamera(camera.ptr, mode);

void UpdateCameraPro(
  Camera3D camera,
  Vector3 movement,
  Vector3 rotation,
  double zoom,
) => ffi.using((arena) {
  raylib.UpdateCameraPro(
    camera.ptr,
    arena.vector3(movement).ref,
    arena.vector3(rotation).ref,
    zoom,
  );
});
