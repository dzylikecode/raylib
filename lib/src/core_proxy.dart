// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:async';
import 'dart:typed_data';

import 'raylib.g.dart' as raw;
import 'dart:ffi';
import 'package:ffi/ffi.dart' as ffi;
import 'package:cdart/cdart.dart';
import 'package:logging/logging.dart';

import 'raylib_const.dart';
import 'structs.dart';

final _titleStack = <Pointer<Char>>[];

void InitWindow(int width, int height, String title) {
  _titleStack.add(title.toNativeUtf8().cast());
  return raw.InitWindow(width, height, _titleStack.last);
}

void CloseWindow() {
  raw.CloseWindow();
  if (_titleStack.isNotEmpty) ffi.malloc.free(_titleStack.removeLast());
}

void SetWindowTitle(String title) {
  if (_titleStack.isNotEmpty) {
    ffi.malloc.free(_titleStack.removeLast());
  }
  _titleStack.add(title.toNativeUtf8().cast());
  return raw.SetWindowTitle(_titleStack.last);
}

bool IsWindowState(ConfigFlags flags) => raw.IsWindowState(flags.value);
void SetWindowState(ConfigFlags flags) => raw.SetWindowState(flags.value);
void ClearWindowState(ConfigFlags flags) => raw.ClearWindowState(flags.value);

void SetWindowIcon(Image image) => ffi.using((arena) {
  return raw.SetWindowIcon(arena.image(image).ref);
});

void SetWindowIcons(List<Image> images, [int? count]) {
  count ??= images.length;
  return ffi.using((arena) {
    final imageArray = arena<raw.Image>(count!);
    for (var i = 0; i < count; i++) {
      final imgPtr = arena.image(images[i]);
      (imageArray + i).ref
        ..data = imgPtr.ref.data
        ..width = imgPtr.ref.width
        ..height = imgPtr.ref.height
        ..mipmaps = imgPtr.ref.mipmaps
        ..format = imgPtr.ref.format;
    }
    return raw.SetWindowIcons(imageArray, count);
  });
}

int GetWindowHandle() => raw.GetWindowHandle().address;

Vector2 GetMonitorPosition(int monitor) =>
    raw.GetMonitorPosition(monitor).toDart();

Vector2 GetWindowPosition() => raw.GetWindowPosition().toDart();
Vector2 GetWindowScaleDPI() => raw.GetWindowScaleDPI().toDart();

String GetMonitorName(int monitor) =>
    raw.GetMonitorName(monitor).cast<ffi.Utf8>().toDartString();

void SetClipboardText(String text) => ffi.using(
  (arena) =>
      raw.SetClipboardText(text.toNativeUtf8(allocator: arena).cast<Char>()),
);

String GetClipboardText() =>
    raw.GetClipboardText().cast<ffi.Utf8>().toDartString();

Image GetClipboardImage() => raw.GetClipboardImage().toDart();

void ClearBackground(Color color) => raw.ClearBackground(color.ptr.ref);

void BeginMode2D(Camera2D camera) => raw.BeginMode2D(camera.ptr.ref);
void BeginMode3D(Camera3D camera) => raw.BeginMode3D(camera.ptr.ref);
void BeginTextureMode(RenderTexture2D target) => ffi.using((arena) {
  return raw.BeginTextureMode(arena.renderTexture(target).ref);
});
void BeginShaderMode(Shader shader) => raw.BeginShaderMode(shader.ptr.ref);
void BeginBlendMode(BlendMode mode) => raw.BeginBlendMode(mode.value);

// ── VR ─────────────────────────────────────────────────────────────────

VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device) => ffi.using((arena) {
  return raw.LoadVrStereoConfig(arena.vrDeviceInfo(device).ref).toDart();
});

void UnloadVrStereoConfig(VrStereoConfig config) => config.dispose();

void BeginVrStereoMode(VrStereoConfig config) =>
    raw.BeginVrStereoMode(config.ptr.ref);

// ── Shader ─────────────────────────────────────────────────────────────

Shader LoadShader(String? vsFileName, String? fsFileName) {
  return ffi.using((arena) {
    final vs =
        vsFileName?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    final fs =
        fsFileName?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    return raw.LoadShader(vs, fs).toDart();
  });
}

Shader LoadShaderFromMemory(String? vsCode, String? fsCode) {
  return ffi.using((arena) {
    final vs = vsCode?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    final fs = fsCode?.toNativeUtf8(allocator: arena).cast<Char>() ?? nullptr;
    return raw.LoadShaderFromMemory(vs, fs).toDart();
  });
}

bool IsShaderValid(Shader shader) => raw.IsShaderValid(shader.ptr.ref);

int GetShaderLocation(Shader shader, String uniformName) => ffi.using((arena) {
  return raw.GetShaderLocation(
    shader.ptr.ref,
    uniformName.toNativeUtf8(allocator: arena).cast(),
  );
});

int GetShaderLocationAttrib(Shader shader, String attribName) =>
    ffi.using((arena) {
      return raw.GetShaderLocationAttrib(
        shader.ptr.ref,
        attribName.toNativeUtf8(allocator: arena).cast(),
      );
    });

void SetShaderValue(
  Shader shader,
  int locIndex,
  TypedData value,
  ShaderUniformDataType uniformType,
) => ffi.using((arena) {
  final bytes = value.buffer.asUint8List(
    value.offsetInBytes,
    value.lengthInBytes,
  );
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raw.SetShaderValue(shader.ptr.ref, locIndex, ptr.cast(), uniformType.value);
});

void SetShaderValueV(
  Shader shader,
  int locIndex,
  TypedData value,
  ShaderUniformDataType uniformType,
  int count,
) => ffi.using((arena) {
  final bytes = value.buffer.asUint8List(
    value.offsetInBytes,
    value.lengthInBytes,
  );
  final ptr = arena<Uint8>(bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  raw.SetShaderValueV(
    shader.ptr.ref,
    locIndex,
    ptr.cast(),
    uniformType.value,
    count,
  );
});

void SetShaderValueMatrix(Shader shader, int locIndex, Matrix4 mat) =>
    ffi.using((arena) {
      final m = arena<raw.Matrix>();
      m.ref
        ..m0 = mat[0]
        ..m1 = mat[1]
        ..m2 = mat[2]
        ..m3 = mat[3]
        ..m4 = mat[4]
        ..m5 = mat[5]
        ..m6 = mat[6]
        ..m7 = mat[7]
        ..m8 = mat[8]
        ..m9 = mat[9]
        ..m10 = mat[10]
        ..m11 = mat[11]
        ..m12 = mat[12]
        ..m13 = mat[13]
        ..m14 = mat[14]
        ..m15 = mat[15];
      raw.SetShaderValueMatrix(shader.ptr.ref, locIndex, m.ref);
    });

void SetShaderValueTexture(Shader shader, int locIndex, Texture texture) =>
    ffi.using((arena) {
      raw.SetShaderValueTexture(
        shader.ptr.ref,
        locIndex,
        arena.texture(texture).ref,
      );
    });

void UnloadShader(Shader shader) => shader.dispose();

// ── Camera/world projections ────────────────────────────────────────────

Ray GetScreenToWorldRay(Vector2 position, Camera3D camera) =>
    ffi.using((arena) {
      return raw.GetScreenToWorldRay(
        arena.vector2(position).ref,
        camera.ptr.ref,
      ).toDart();
    });

Ray GetScreenToWorldRayEx(
  Vector2 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using((arena) {
  return raw.GetScreenToWorldRayEx(
    arena.vector2(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart();
});

Vector2 GetWorldToScreen(Vector3 position, Camera3D camera) =>
    ffi.using((arena) {
      return raw.GetWorldToScreen(
        arena.vector3(position).ref,
        camera.ptr.ref,
      ).toDart();
    });

Vector2 GetWorldToScreenEx(
  Vector3 position,
  Camera3D camera,
  int width,
  int height,
) => ffi.using((arena) {
  return raw.GetWorldToScreenEx(
    arena.vector3(position).ref,
    camera.ptr.ref,
    width,
    height,
  ).toDart();
});

Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera) =>
    ffi.using((arena) {
      return raw.GetWorldToScreen2D(
        arena.vector2(position).ref,
        camera.ptr.ref,
      ).toDart();
    });

Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera) =>
    ffi.using((arena) {
      return raw.GetScreenToWorld2D(
        arena.vector2(position).ref,
        camera.ptr.ref,
      ).toDart();
    });

Matrix4 GetCameraMatrix(Camera3D camera) =>
    raw.GetCameraMatrix(camera.ptr.ref).toDart();

Matrix4 GetCameraMatrix2D(Camera2D camera) =>
    raw.GetCameraMatrix2D(camera.ptr.ref).toDart();

// ── Random ─────────────────────────────────────────────────────────────

List<int> LoadRandomSequence(int count, int min, int max) {
  final ptr = raw.LoadRandomSequence(count, min, max);
  final result = List<int>.generate(count, (i) => (ptr + i).value);
  raw.UnloadRandomSequence(ptr);
  return result;
}

@Deprecated(
  'Memory is managed automatically by LoadRandomSequence. This is a no-op.',
)
void UnloadRandomSequence(List<int> sequence) {}

// ── Misc ───────────────────────────────────────────────────────────────

void SetConfigFlags(ConfigFlags flags) => raw.SetConfigFlags(flags.value);

void TakeScreenshot(String fileName) => ffi.using((arena) {
  raw.TakeScreenshot(fileName.toNativeUtf8(allocator: arena).cast());
});

void OpenURL(String url) => ffi.using((arena) {
  raw.OpenURL(url.toNativeUtf8(allocator: arena).cast());
});

final _logger = Logger('raylib');

Level _toLevel(int raylibLevel) => switch (raylibLevel) {
  1 => .FINEST,
  2 => .FINE,
  3 => .INFO,
  4 => .WARNING,
  5 => .SEVERE,
  6 => .SHOUT,
  _ => .INFO,
};

void SetTraceLogLevel(TraceLogLevel level) => raw.SetTraceLogLevel(level.value);

StreamSubscription<LogRecord>? _subscription;

void SetTraceLogCallback(TraceLogCallback? handler) {
  _subscription?.cancel();
  _subscription = handler != null ? _logger.onRecord.listen(handler) : null;
}

// dart format off
void TraceLog(TraceLogLevel level, String text, List<Object> args) => ffi.using((arena) {
  final str = sprintf(text, args)!;
  return raw.TraceLog(level.value, str.toNativeUtf8(allocator: arena).cast<Char>());
});
// dart format on

int MemAlloc(int size) => 0;
int MemRealloc(int ptr, int size) => 0;
void MemFree(int ptr) => 0;

// ── File I/O ───────────────────────────────────────────────────────────

Uint8List LoadFileData(String fileName) {
  return ffi.using((arena) {
    final sizePtr = arena<Int>();
    final result = raw.LoadFileData(
      fileName.toNativeUtf8(allocator: arena).cast(),
      sizePtr,
    );
    final bytes = Uint8List.fromList(
      result.cast<Uint8>().asTypedList(sizePtr.value),
    );
    raw.UnloadFileData(result);
    return bytes;
  });
}

bool SaveFileData(String fileName, Uint8List data) {
  return ffi.using((arena) {
    final ptr = arena<Uint8>(data.length);
    ptr.asTypedList(data.length).setAll(0, data);
    return raw.SaveFileData(
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
    return raw.ExportDataAsCode(
      ptr.cast(),
      data.length,
      fileName.toNativeUtf8(allocator: arena).cast(),
    );
  });
}

String LoadFileText(String fileName) {
  return ffi.using((arena) {
    final result = raw.LoadFileText(
      fileName.toNativeUtf8(allocator: arena).cast(),
    );
    final text = result.cast<ffi.Utf8>().toDartString();
    raw.UnloadFileText(result);
    return text;
  });
}

void UnloadFileText(String text) => 0;

bool SaveFileText(String fileName, String text) {
  return ffi.using((arena) {
    return raw.SaveFileText(
      fileName.toNativeUtf8(allocator: arena).cast(),
      text.toNativeUtf8(allocator: arena).cast(),
    );
  });
}

LoadFileDataCallback? _currentLoadFileDataCb;
SaveFileDataCallback? _currentSaveFileDataCb;
LoadFileTextCallback? _currentLoadFileTextCb;
SaveFileTextCallback? _currentSaveFileTextCb;

final _nativeLoadFileDataCallback =
    NativeCallable<raw.LoadFileDataCallbackFunction>.isolateLocal(
      _ffiLoadFileData,
    );

Pointer<UnsignedChar> _ffiLoadFileData(
  Pointer<Char> fileName,
  Pointer<Int> dataSize,
) {
  final name = fileName.cast<ffi.Utf8>().toDartString();
  final loader = _currentLoadFileDataCb;
  if (loader == null) {
    dataSize.value = 0;
    return nullptr;
  }

  final bytes = loader(name);
  final size = bytes.length;

  // ⭐ 关键：用 raylib 的 MemAlloc（内部是 RL_MALLOC）
  // 因为 unload 会用 raylib 的 free，所以拷贝到 c 的内存中
  final rawPtr = raw.MemAlloc(size);
  final u8Ptr = rawPtr.cast<Uint8>();
  u8Ptr.asTypedList(size).setAll(0, bytes);
  return rawPtr.cast();
}

bool _useDartLoadFileDataCallback = false;
void SetLoadFileDataCallback([LoadFileDataCallback? callback]) {
  _currentLoadFileDataCb = callback;
  if (callback == null) {
    _logger.info('Use C load file data callback');
    _useDartLoadFileDataCallback = false;
    raw.SetLoadFileDataCallback(nullptr);
  } else {
    if (_useDartLoadFileDataCallback == true) {
      _logger.info('Update Dart load file data callback');
      return;
    }
    _logger.info('Switch from C to Dart load file data callback');
    raw.SetLoadFileDataCallback(_nativeLoadFileDataCallback.nativeFunction);
    _useDartLoadFileDataCallback = true;
  }
}

final _nativeSaveFileDataCallback =
    NativeCallable<raw.SaveFileDataCallbackFunction>.isolateLocal(
      _ffiSaveFileData,
      exceptionalReturn: false,
    );

bool _ffiSaveFileData(
  Pointer<Char> fileName,
  Pointer<Void> data,
  int dataSize,
) {
  final name = fileName.cast<ffi.Utf8>().toDartString();
  final saver = _currentSaveFileDataCb;
  if (saver == null) {
    return false;
  }

  final bytes = data.cast<Uint8>().asTypedList(dataSize);
  return saver(name, bytes);
}

bool _useDartSaveFileDataCallback = false;
void SetSaveFileDataCallback([SaveFileDataCallback? callback]) {
  _currentSaveFileDataCb = callback;
  if (callback == null) {
    _logger.info('Use C save file data callback');
    _useDartSaveFileDataCallback = false;
    raw.SetSaveFileDataCallback(nullptr);
  } else {
    if (_useDartSaveFileDataCallback == true) {
      _logger.info('Update Dart save file data callback');
      return;
    }
    _logger.info('Switch from C to Dart save file data callback');
    raw.SetSaveFileDataCallback(_nativeSaveFileDataCallback.nativeFunction);
    _useDartSaveFileDataCallback = true;
  }
}

final _nativeLoadFileTextCallback =
    NativeCallable<raw.LoadFileTextCallbackFunction>.isolateLocal(
      _ffiLoadFileText,
    );

Pointer<Char> _ffiLoadFileText(Pointer<Char> fileName) {
  final name = fileName.cast<ffi.Utf8>().toDartString();
  final loader = _currentLoadFileTextCb;
  if (loader == null) {
    return nullptr;
  }

  final text = loader(name);
  final utf8Ptr = text.toNativeUtf8();
  final size = utf8Ptr.length;

  // ⭐ 关键：用 raylib 的 MemAlloc（内部是 RL_MALLOC）
  // 因为 unload 会用 raylib 的 free，所以拷贝到 c 的内存中
  final rawPtr = raw.MemAlloc(size);
  final u8Ptr = rawPtr.cast<Uint8>();
  u8Ptr.asTypedList(size).setAll(0, utf8Ptr.cast<Uint8>().asTypedList(size));
  ffi.malloc.free(utf8Ptr);
  return rawPtr.cast<Char>();
}

bool _useDartLoadFileTextCallback = false;
void SetLoadFileTextCallback([LoadFileTextCallback? callback]) {
  _currentLoadFileTextCb = callback;
  if (callback == null) {
    _logger.info('Use C load file text callback');
    _useDartLoadFileTextCallback = false;
    raw.SetLoadFileTextCallback(nullptr);
  } else {
    if (_useDartLoadFileTextCallback == true) {
      _logger.info('Update Dart load file text callback');
      return;
    }
    _logger.info('Switch from C to Dart load file text callback');
    raw.SetLoadFileTextCallback(_nativeLoadFileTextCallback.nativeFunction);
    _useDartLoadFileTextCallback = true;
  }
}

final _nativeSaveFileTextCallback =
    NativeCallable<raw.SaveFileTextCallbackFunction>.isolateLocal(
      _ffiSaveFileText,
      exceptionalReturn: false,
    );

bool _ffiSaveFileText(Pointer<Char> fileName, Pointer<Char> text) {
  final name = fileName.cast<ffi.Utf8>().toDartString();
  final content = text.cast<ffi.Utf8>().toDartString();
  final saver = _currentSaveFileTextCb;
  if (saver == null) {
    return false;
  }

  return saver(name, content);
}

bool _useDartSaveFileTextCallback = false;
void SetSaveFileTextCallback([SaveFileTextCallback? callback]) {
  _currentSaveFileTextCb = callback;
  if (callback == null) {
    _logger.info('Use C save file text callback');
    _useDartSaveFileTextCallback = false;
    raw.SetSaveFileTextCallback(nullptr);
  } else {
    if (_useDartSaveFileTextCallback == true) {
      _logger.info('Update Dart save file text callback');
      return;
    }
    _logger.info('Switch from C to Dart save file text callback');
    raw.SetSaveFileTextCallback(_nativeSaveFileTextCallback.nativeFunction);
    _useDartSaveFileTextCallback = true;
  }
}


bool FileExists(String fileName) => ffi.using((arena) {
  return raw.FileExists(fileName.toNativeUtf8(allocator: arena).cast());
});

bool DirectoryExists(String dirPath) => ffi.using((arena) {
  return raw.DirectoryExists(dirPath.toNativeUtf8(allocator: arena).cast());
});

bool IsFileExtension(String fileName, String ext) => ffi.using((arena) {
  return raw.IsFileExtension(
    fileName.toNativeUtf8(allocator: arena).cast(),
    ext.toNativeUtf8(allocator: arena).cast(),
  );
});

int GetFileLength(String fileName) => ffi.using((arena) {
  return raw.GetFileLength(fileName.toNativeUtf8(allocator: arena).cast());
});

String GetFileExtension(String fileName) => ffi.using((arena) {
  return raw.GetFileExtension(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).cast<ffi.Utf8>().toDartString();
});

String GetFileName(String filePath) => ffi.using((arena) {
  return raw.GetFileName(
    filePath.toNativeUtf8(allocator: arena).cast(),
  ).cast<ffi.Utf8>().toDartString();
});

String GetFileNameWithoutExt(String filePath) => ffi.using((arena) {
  return raw.GetFileNameWithoutExt(
    filePath.toNativeUtf8(allocator: arena).cast(),
  ).cast<ffi.Utf8>().toDartString();
});

String GetDirectoryPath(String filePath) => ffi.using((arena) {
  return raw.GetDirectoryPath(
    filePath.toNativeUtf8(allocator: arena).cast(),
  ).cast<ffi.Utf8>().toDartString();
});

String GetPrevDirectoryPath(String dirPath) => ffi.using((arena) {
  return raw.GetPrevDirectoryPath(
    dirPath.toNativeUtf8(allocator: arena).cast(),
  ).cast<ffi.Utf8>().toDartString();
});

String GetWorkingDirectory() =>
    raw.GetWorkingDirectory().cast<ffi.Utf8>().toDartString();

String GetApplicationDirectory() =>
    raw.GetApplicationDirectory().cast<ffi.Utf8>().toDartString();

int MakeDirectory(String dirPath) => ffi.using((arena) {
  return raw.MakeDirectory(dirPath.toNativeUtf8(allocator: arena).cast());
});

bool ChangeDirectory(String dir) => ffi.using((arena) {
  return raw.ChangeDirectory(dir.toNativeUtf8(allocator: arena).cast());
});

bool IsPathFile(String path) => ffi.using((arena) {
  return raw.IsPathFile(path.toNativeUtf8(allocator: arena).cast());
});

bool IsFileNameValid(String fileName) => ffi.using((arena) {
  return raw.IsFileNameValid(fileName.toNativeUtf8(allocator: arena).cast());
});

List<String> LoadDirectoryFiles(String dirPath) => ffi.using((arena) {
  final list = raw.LoadDirectoryFiles(
    dirPath.toNativeUtf8(allocator: arena).cast(),
  );
  final result = List<String>.generate(
    list.count,
    (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
  );
  raw.UnloadDirectoryFiles(list);
  return result;
});

List<String> LoadDirectoryFilesEx(
  String basePath,
  String filter,
  bool scanSubdirs,
) => ffi.using((arena) {
  final list = raw.LoadDirectoryFilesEx(
    basePath.toNativeUtf8(allocator: arena).cast(),
    filter.toNativeUtf8(allocator: arena).cast(),
    scanSubdirs,
  );
  final result = List<String>.generate(
    list.count,
    (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
  );
  raw.UnloadDirectoryFiles(list);
  return result;
});

List<String> LoadDroppedFiles() {
  final list = raw.LoadDroppedFiles();
  final result = List<String>.generate(
    list.count,
    (i) => list.paths[i].cast<ffi.Utf8>().toDartString(),
  );
  raw.UnloadDroppedFiles(list);
  return result;
}

int GetFileModTime(String fileName) => ffi.using((arena) {
  return raw.GetFileModTime(fileName.toNativeUtf8(allocator: arena).cast());
});

Uint8List CompressData(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raw.CompressData(dataPtr.cast(), data.length, sizePtr);
    final bytes = Uint8List.fromList(
      result.cast<Uint8>().asTypedList(sizePtr.value),
    );
    raw.MemFree(result.cast());
    return bytes;
  });
}

Uint8List DecompressData(Uint8List compData) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(compData.length);
    dataPtr.asTypedList(compData.length).setAll(0, compData);
    final sizePtr = arena<Int>();
    final result = raw.DecompressData(dataPtr.cast(), compData.length, sizePtr);
    final bytes = Uint8List.fromList(
      result.cast<Uint8>().asTypedList(sizePtr.value),
    );
    raw.MemFree(result.cast());
    return bytes;
  });
}

String EncodeDataBase64(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raw.EncodeDataBase64(dataPtr.cast(), data.length, sizePtr);
    final str = result.cast<ffi.Utf8>().toDartString();
    raw.MemFree(result.cast());
    return str;
  });
}

Uint8List DecodeDataBase64(Uint8List data) {
  return ffi.using((arena) {
    final dataPtr = arena<Uint8>(data.length);
    dataPtr.asTypedList(data.length).setAll(0, data);
    final sizePtr = arena<Int>();
    final result = raw.DecodeDataBase64(dataPtr.cast(), sizePtr);
    final bytes = Uint8List.fromList(
      result.cast<Uint8>().asTypedList(sizePtr.value),
    );
    raw.MemFree(result.cast());
    return bytes;
  });
}

int ComputeCRC32(Uint8List data) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return raw.ComputeCRC32(ptr.cast(), data.length);
});

Uint8List ComputeMD5(Uint8List data) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  final result = raw.ComputeMD5(ptr.cast(), data.length);
  return .fromList(result.cast<Uint8>().asTypedList(16));
});

Uint8List ComputeSHA1(Uint8List data) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  final result = raw.ComputeSHA1(ptr.cast(), data.length);
  return .fromList(result.cast<Uint8>().asTypedList(20));
});

// ── Automation ─────────────────────────────────────────────────────────

/// Pass [null] to create an empty in-memory list.
AutomationEventList LoadAutomationEventList(String? fileName) =>
    ffi.using((arena) {
      final namePtr = fileName != null
          ? fileName.toNativeUtf8(allocator: arena).cast<Char>()
          : nullptr;
      return raw.LoadAutomationEventList(namePtr).toDart();
    });

void UnloadAutomationEventList(AutomationEventList list) => list.dispose();

bool ExportAutomationEventList(AutomationEventList list, String fileName) =>
    ffi.using((arena) {
      return raw.ExportAutomationEventList(
        list.ptr.ref,
        fileName.toNativeUtf8(allocator: arena).cast(),
      );
    });

void SetAutomationEventList(AutomationEventList list) =>
    raw.SetAutomationEventList(list.ptr);

void PlayAutomationEvent(AutomationEvent event) => ffi.using((arena) {
  raw.PlayAutomationEvent(arena.automationEvent(event).ref);
});

// ── Keyboard ───────────────────────────────────────────────────────────

bool IsKeyPressed(KeyboardKey key) => raw.IsKeyPressed(key.value);
bool IsKeyPressedRepeat(KeyboardKey key) => raw.IsKeyPressedRepeat(key.value);
bool IsKeyDown(KeyboardKey key) => raw.IsKeyDown(key.value);
bool IsKeyReleased(KeyboardKey key) => raw.IsKeyReleased(key.value);
bool IsKeyUp(KeyboardKey key) => raw.IsKeyUp(key.value);
KeyboardKey GetKeyPressed() => .fromValue(raw.GetKeyPressed());
void SetExitKey(KeyboardKey key) => raw.SetExitKey(key.value);

// ── Gamepad ─────────────────────────────────────────────────────────────

String GetGamepadName(int gamepad) =>
    raw.GetGamepadName(gamepad).cast<ffi.Utf8>().toDartString();

int SetGamepadMappings(String mappings) => ffi.using((arena) {
  return raw.SetGamepadMappings(mappings.toNativeUtf8(allocator: arena).cast());
});

bool IsGamepadButtonPressed(int gamepad, GamepadButton button) =>
    raw.IsGamepadButtonPressed(gamepad, button.value);
bool IsGamepadButtonDown(int gamepad, GamepadButton button) =>
    raw.IsGamepadButtonDown(gamepad, button.value);
bool IsGamepadButtonReleased(int gamepad, GamepadButton button) =>
    raw.IsGamepadButtonReleased(gamepad, button.value);
bool IsGamepadButtonUp(int gamepad, GamepadButton button) =>
    raw.IsGamepadButtonUp(gamepad, button.value);
GamepadButton GetGamepadButtonPressed() =>
    .fromValue(raw.GetGamepadButtonPressed());
double GetGamepadAxisMovement(int gamepad, GamepadAxis axis) =>
    raw.GetGamepadAxisMovement(gamepad, axis.value);

// ── Mouse ──────────────────────────────────────────────────────────────

Vector2 GetMousePosition() => raw.GetMousePosition().toDart();
Vector2 GetMouseDelta() => raw.GetMouseDelta().toDart();
Vector2 GetMouseWheelMoveV() => raw.GetMouseWheelMoveV().toDart();

bool IsMouseButtonPressed(MouseButton button) =>
    raw.IsMouseButtonPressed(button.value);
bool IsMouseButtonDown(MouseButton button) =>
    raw.IsMouseButtonDown(button.value);
bool IsMouseButtonReleased(MouseButton button) =>
    raw.IsMouseButtonReleased(button.value);
bool IsMouseButtonUp(MouseButton button) => raw.IsMouseButtonUp(button.value);
void SetMouseCursor(MouseCursor cursor) => raw.SetMouseCursor(cursor.value);

// ── Touch ──────────────────────────────────────────────────────────────

Vector2 GetTouchPosition(int index) => raw.GetTouchPosition(index).toDart();

// ── Gestures ───────────────────────────────────────────────────────────

void SetGesturesEnabled(Gesture gesture) =>
    raw.SetGesturesEnabled(gesture.value);

bool IsGestureDetected(Gesture gesture) => raw.IsGestureDetected(gesture.value);

Gesture GetGestureDetected() => .fromValue(raw.GetGestureDetected());

Vector2 GetGestureDragVector() => raw.GetGestureDragVector().toDart();
Vector2 GetGesturePinchVector() => raw.GetGesturePinchVector().toDart();

// ── Camera update ──────────────────────────────────────────────────────

void UpdateCamera(Camera3D camera, CameraMode mode) =>
    raw.UpdateCamera(camera.ptr, mode.value);

void UpdateCameraPro(
  Camera3D camera,
  Vector3 movement,
  Vector3 rotation,
  double zoom,
) => ffi.using((arena) {
  return raw.UpdateCameraPro(
    camera.ptr,
    arena.vector3(movement).ref,
    arena.vector3(rotation).ref,
    zoom,
  );
});
