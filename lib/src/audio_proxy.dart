// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'structs.dart';

Pointer<Uint8> _bytes(ffi.Arena arena, Uint8List data) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  return ptr;
}

Wave LoadWaveFromMemory(String fileType, Uint8List fileData) =>
    ffi.using((arena) {
      return raw.LoadWaveFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        _bytes(arena, fileData).cast<UnsignedChar>(),
        fileData.length,
      ).toDart();
    });

void UpdateSound(Sound sound, Uint8List data, int sampleCount) =>
    ffi.using((arena) {
      raw.UpdateSound(sound.ptr.ref, _bytes(arena, data).cast(), sampleCount);
    });

void WaveCrop(Wave wave, int initFrame, int finalFrame) =>
    raw.WaveCrop(wave.ptr, initFrame, finalFrame);

void WaveFormat(Wave wave, int sampleRate, int sampleSize, int channels) =>
    raw.WaveFormat(wave.ptr, sampleRate, sampleSize, channels);

Float32List LoadWaveSamples(Wave wave) {
  final ptr = raw.LoadWaveSamples(wave.ptr.ref);
  final result = Float32List.fromList(
    ptr.asTypedList(wave.frameCount * wave.channels),
  );
  raw.UnloadWaveSamples(ptr);
  return result;
}

Music LoadMusicStreamFromMemory(String fileType, Uint8List data) =>
    ffi.using((arena) {
      return raw.LoadMusicStreamFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        _bytes(arena, data).cast<UnsignedChar>(),
        data.length,
      ).toDart();
    });

void UpdateAudioStream(AudioStream stream, Uint8List data, int frameCount) =>
    ffi.using((arena) {
      raw.UpdateAudioStream(
        stream.ptr.ref,
        _bytes(arena, data).cast(),
        frameCount,
      );
    });
