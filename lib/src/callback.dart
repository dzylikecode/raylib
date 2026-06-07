// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;
import 'package:logging/logging.dart';

import 'raylib.g.dart' as raw;

final _logger = Logger('callback');

typedef LoadFileDataCallback = Uint8List Function(String);
typedef SaveFileDataCallback = bool Function(String, Uint8List);
typedef LoadFileTextCallback = String Function(String);
typedef SaveFileTextCallback = bool Function(String, String);

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
