// ignore_for_file: non_constant_identifier_names
//
// 本文件封装 raylib 音频模块。
//
// 尚未代理：
//   LoadSoundAlias — alias 与原始 Sound 共享音频缓冲区，Finalizer 语义不兼容
//   SetAudioStreamCallback / AttachAudioStreamProcessor 等 — 需要 NativeCallable

import 'src/raylib.g.dart' as raylib;
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';
import 'dart:typed_data';
import 'structs.dart';

// ── Device ─────────────────────────────────────────────────────────────
export 'src/raylib.g.dart' show InitAudioDevice;
export 'src/raylib.g.dart' show CloseAudioDevice;
export 'src/raylib.g.dart' show IsAudioDeviceReady;
export 'src/raylib.g.dart' show SetMasterVolume;
export 'src/raylib.g.dart' show GetMasterVolume;

// ── Wave/Sound loading/unloading ───────────────────────────────────────
// export 'src/raylib.g.dart' show LoadWave;              // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadWaveFromMemory;    // → Dart wrapper below
// export 'src/raylib.g.dart' show IsWaveValid;           // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadSound;             // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadSoundFromWave;     // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadSoundAlias;        // alias 语义不兼容 Finalizer
// export 'src/raylib.g.dart' show IsSoundValid;          // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateSound;           // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadWave;            // → wave.dispose()
// export 'src/raylib.g.dart' show UnloadSound;           // → sound.dispose()
// export 'src/raylib.g.dart' show UnloadSoundAlias;      // alias 语义不兼容 Finalizer
// export 'src/raylib.g.dart' show ExportWave;            // → Dart wrapper below
// export 'src/raylib.g.dart' show ExportWaveAsCode;      // → Dart wrapper below

// ── Wave/Sound management ──────────────────────────────────────────────
// export 'src/raylib.g.dart' show PlaySound;             // → Dart wrapper below
// export 'src/raylib.g.dart' show StopSound;             // → Dart wrapper below
// export 'src/raylib.g.dart' show PauseSound;            // → Dart wrapper below
// export 'src/raylib.g.dart' show ResumeSound;           // → Dart wrapper below
// export 'src/raylib.g.dart' show IsSoundPlaying;        // → Dart wrapper below
// export 'src/raylib.g.dart' show SetSoundVolume;        // → Dart wrapper below
// export 'src/raylib.g.dart' show SetSoundPitch;         // → Dart wrapper below
// export 'src/raylib.g.dart' show SetSoundPan;           // → Dart wrapper below
// export 'src/raylib.g.dart' show WaveCopy;              // → Dart wrapper below
// export 'src/raylib.g.dart' show WaveCrop;              // → Dart wrapper below
// export 'src/raylib.g.dart' show WaveFormat;            // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadWaveSamples;       // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadWaveSamples;     // consumed by LoadWaveSamples

// ── Music ──────────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadMusicStream;           // → Dart wrapper below
// export 'src/raylib.g.dart' show LoadMusicStreamFromMemory; // → Dart wrapper below
// export 'src/raylib.g.dart' show IsMusicValid;              // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadMusicStream;         // → music.dispose()
// export 'src/raylib.g.dart' show PlayMusicStream;           // → Dart wrapper below
// export 'src/raylib.g.dart' show IsMusicStreamPlaying;      // → Dart wrapper below
// export 'src/raylib.g.dart' show UpdateMusicStream;         // → Dart wrapper below
// export 'src/raylib.g.dart' show StopMusicStream;           // → Dart wrapper below
// export 'src/raylib.g.dart' show PauseMusicStream;          // → Dart wrapper below
// export 'src/raylib.g.dart' show ResumeMusicStream;         // → Dart wrapper below
// export 'src/raylib.g.dart' show SeekMusicStream;           // → Dart wrapper below
// export 'src/raylib.g.dart' show SetMusicVolume;            // → Dart wrapper below
// export 'src/raylib.g.dart' show SetMusicPitch;             // → Dart wrapper below
// export 'src/raylib.g.dart' show SetMusicPan;               // → Dart wrapper below
// export 'src/raylib.g.dart' show GetMusicTimeLength;        // → Dart wrapper below
// export 'src/raylib.g.dart' show GetMusicTimePlayed;        // → Dart wrapper below

// ── AudioStream ────────────────────────────────────────────────────────
// export 'src/raylib.g.dart' show LoadAudioStream;              // → Dart wrapper below
// export 'src/raylib.g.dart' show IsAudioStreamValid;           // → Dart wrapper below
// export 'src/raylib.g.dart' show UnloadAudioStream;            // → stream.dispose()
// export 'src/raylib.g.dart' show UpdateAudioStream;            // → Dart wrapper below
// export 'src/raylib.g.dart' show IsAudioStreamProcessed;       // → Dart wrapper below
// export 'src/raylib.g.dart' show PlayAudioStream;              // → Dart wrapper below
// export 'src/raylib.g.dart' show PauseAudioStream;             // → Dart wrapper below
// export 'src/raylib.g.dart' show ResumeAudioStream;            // → Dart wrapper below
// export 'src/raylib.g.dart' show IsAudioStreamPlaying;         // → Dart wrapper below
// export 'src/raylib.g.dart' show StopAudioStream;              // → Dart wrapper below
// export 'src/raylib.g.dart' show SetAudioStreamVolume;         // → Dart wrapper below
// export 'src/raylib.g.dart' show SetAudioStreamPitch;          // → Dart wrapper below
// export 'src/raylib.g.dart' show SetAudioStreamPan;            // → Dart wrapper below
export 'src/raylib.g.dart' show SetAudioStreamBufferSizeDefault;
// export 'src/raylib.g.dart' show SetAudioStreamCallback;       // 需要 NativeCallable
// export 'src/raylib.g.dart' show AttachAudioStreamProcessor;   // 需要 NativeCallable
// export 'src/raylib.g.dart' show DetachAudioStreamProcessor;   // 需要 NativeCallable
// export 'src/raylib.g.dart' show AttachAudioMixedProcessor;    // 需要 NativeCallable
// export 'src/raylib.g.dart' show DetachAudioMixedProcessor;    // 需要 NativeCallable

// ── Wave/Sound loading/unloading ───────────────────────────────────────

Wave LoadWave(String fileName) => ffi.using((arena) {
  return raylib.LoadWave(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Wave LoadWaveFromMemory(String fileType, Uint8List fileData) =>
    ffi.using((arena) {
      final ptr = arena<Uint8>(fileData.length);
      ptr.asTypedList(fileData.length).setAll(0, fileData);
      return raylib.LoadWaveFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        ptr.cast(),
        fileData.length,
      ).toDart();
    });

bool IsWaveValid(Wave wave) => raylib.IsWaveValid(wave.ptr.ref);

Sound LoadSound(String fileName) => ffi.using((arena) {
  return raylib.LoadSound(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Sound LoadSoundFromWave(Wave wave) =>
    raylib.LoadSoundFromWave(wave.ptr.ref).toDart();

bool IsSoundValid(Sound sound) => raylib.IsSoundValid(sound.ptr.ref);

/// Streams [sampleCount] samples from [data] into [sound].
void UpdateSound(Sound sound, Uint8List data, int sampleCount) =>
    ffi.using((arena) {
      final ptr = arena<Uint8>(data.length);
      ptr.asTypedList(data.length).setAll(0, data);
      raylib.UpdateSound(sound.ptr.ref, ptr.cast(), sampleCount);
    });

void UnloadWave(Wave wave) => wave.dispose();

void UnloadSound(Sound sound) => sound.dispose();

bool ExportWave(Wave wave, String fileName) => ffi.using((arena) {
  return raylib.ExportWave(
    wave.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

bool ExportWaveAsCode(Wave wave, String fileName) => ffi.using((arena) {
  return raylib.ExportWaveAsCode(
    wave.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

// ── Wave/Sound management ──────────────────────────────────────────────

void PlaySound(Sound sound) => raylib.PlaySound(sound.ptr.ref);

void StopSound(Sound sound) => raylib.StopSound(sound.ptr.ref);

void PauseSound(Sound sound) => raylib.PauseSound(sound.ptr.ref);

void ResumeSound(Sound sound) => raylib.ResumeSound(sound.ptr.ref);

bool IsSoundPlaying(Sound sound) => raylib.IsSoundPlaying(sound.ptr.ref);

void SetSoundVolume(Sound sound, double volume) =>
    raylib.SetSoundVolume(sound.ptr.ref, volume);

void SetSoundPitch(Sound sound, double pitch) =>
    raylib.SetSoundPitch(sound.ptr.ref, pitch);

void SetSoundPan(Sound sound, double pan) =>
    raylib.SetSoundPan(sound.ptr.ref, pan);

Wave WaveCopy(Wave wave) => raylib.WaveCopy(wave.ptr.ref).toDart();

/// Crops [wave] in-place to frames [initFrame]..[finalFrame].
void WaveCrop(Wave wave, int initFrame, int finalFrame) =>
    raylib.WaveCrop(wave.ptr, initFrame, finalFrame);

/// Reformats [wave] in-place to the given sample rate, size, and channels.
void WaveFormat(Wave wave, int sampleRate, int sampleSize, int channels) =>
    raylib.WaveFormat(wave.ptr, sampleRate, sampleSize, channels);

/// Returns a normalized Float32 PCM sample list and immediately releases
/// the C-allocated buffer.
Float32List LoadWaveSamples(Wave wave) {
  final ptr = raylib.LoadWaveSamples(wave.ptr.ref);
  final count = wave.frameCount * wave.channels;
  final result = Float32List.fromList(ptr.asTypedList(count));
  raylib.UnloadWaveSamples(ptr);
  return result;
}

// ── Music ──────────────────────────────────────────────────────────────

Music LoadMusicStream(String fileName) => ffi.using((arena) {
  return raylib.LoadMusicStream(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Music LoadMusicStreamFromMemory(String fileType, Uint8List fileData) =>
    ffi.using((arena) {
      final ptr = arena<Uint8>(fileData.length);
      ptr.asTypedList(fileData.length).setAll(0, fileData);
      return raylib.LoadMusicStreamFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        ptr.cast(),
        fileData.length,
      ).toDart();
    });

bool IsMusicValid(Music music) => raylib.IsMusicValid(music.ptr.ref);

void UnloadMusicStream(Music music) => music.dispose();

void PlayMusicStream(Music music) => raylib.PlayMusicStream(music.ptr.ref);

bool IsMusicStreamPlaying(Music music) =>
    raylib.IsMusicStreamPlaying(music.ptr.ref);

void UpdateMusicStream(Music music) => raylib.UpdateMusicStream(music.ptr.ref);

void StopMusicStream(Music music) => raylib.StopMusicStream(music.ptr.ref);

void PauseMusicStream(Music music) => raylib.PauseMusicStream(music.ptr.ref);

void ResumeMusicStream(Music music) => raylib.ResumeMusicStream(music.ptr.ref);

void SeekMusicStream(Music music, double position) =>
    raylib.SeekMusicStream(music.ptr.ref, position);

void SetMusicVolume(Music music, double volume) =>
    raylib.SetMusicVolume(music.ptr.ref, volume);

void SetMusicPitch(Music music, double pitch) =>
    raylib.SetMusicPitch(music.ptr.ref, pitch);

void SetMusicPan(Music music, double pan) =>
    raylib.SetMusicPan(music.ptr.ref, pan);

double GetMusicTimeLength(Music music) =>
    raylib.GetMusicTimeLength(music.ptr.ref);

double GetMusicTimePlayed(Music music) =>
    raylib.GetMusicTimePlayed(music.ptr.ref);

// ── AudioStream ────────────────────────────────────────────────────────

AudioStream LoadAudioStream(int sampleRate, int sampleSize, int channels) =>
    raylib.LoadAudioStream(sampleRate, sampleSize, channels).toDart();

bool IsAudioStreamValid(AudioStream stream) =>
    raylib.IsAudioStreamValid(stream.ptr.ref);

void UnloadAudioStream(AudioStream stream) => stream.dispose();

/// Feeds [frameCount] frames of PCM data to [stream].
void UpdateAudioStream(
  AudioStream stream,
  Uint8List data,
  int frameCount,
) => ffi.using((arena) {
  final ptr = arena<Uint8>(data.length);
  ptr.asTypedList(data.length).setAll(0, data);
  raylib.UpdateAudioStream(stream.ptr.ref, ptr.cast(), frameCount);
});

bool IsAudioStreamProcessed(AudioStream stream) =>
    raylib.IsAudioStreamProcessed(stream.ptr.ref);

void PlayAudioStream(AudioStream stream) =>
    raylib.PlayAudioStream(stream.ptr.ref);

void PauseAudioStream(AudioStream stream) =>
    raylib.PauseAudioStream(stream.ptr.ref);

void ResumeAudioStream(AudioStream stream) =>
    raylib.ResumeAudioStream(stream.ptr.ref);

bool IsAudioStreamPlaying(AudioStream stream) =>
    raylib.IsAudioStreamPlaying(stream.ptr.ref);

void StopAudioStream(AudioStream stream) =>
    raylib.StopAudioStream(stream.ptr.ref);

void SetAudioStreamVolume(AudioStream stream, double volume) =>
    raylib.SetAudioStreamVolume(stream.ptr.ref, volume);

void SetAudioStreamPitch(AudioStream stream, double pitch) =>
    raylib.SetAudioStreamPitch(stream.ptr.ref, pitch);

void SetAudioStreamPan(AudioStream stream, double pan) =>
    raylib.SetAudioStreamPan(stream.ptr.ref, pan);
