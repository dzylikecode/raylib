// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;

import 'raylib.g.dart' as raw;
import 'structs.dart';

Wave LoadWave(String fileName) => ffi.using((arena) {
  return raw.LoadWave(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Wave LoadWaveFromMemory(String fileType, Uint8List fileData) =>
    ffi.using((arena) {
      return raw.LoadWaveFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        arena.bytes(fileData),
        fileData.length,
      ).toDart();
    });

bool IsWaveValid(Wave wave) => raw.IsWaveValid(wave.ptr.ref);

Sound LoadSound(String fileName) => ffi.using((arena) {
  return raw.LoadSound(fileName.toNativeUtf8(allocator: arena).cast()).toDart();
});

Sound LoadSoundFromWave(Wave wave) =>
    raw.LoadSoundFromWave(wave.ptr.ref).toDart();

Sound LoadSoundAlias(Sound source) =>
    raw.LoadSoundAlias(source.ptr.ref).toDart();

bool IsSoundValid(Sound sound) => raw.IsSoundValid(sound.ptr.ref);

void UpdateSound(Sound sound, Uint8List data, int sampleCount) =>
    ffi.using((arena) {
      raw.UpdateSound(sound.ptr.ref, arena.bytes(data).cast(), sampleCount);
    });

void UnloadWave(Wave wave) => wave.dispose();

void UnloadSound(Sound sound) => sound.dispose();

void UnloadSoundAlias(Sound alias) => raw.UnloadSoundAlias(alias.ptr.ref);

bool ExportWave(Wave wave, String fileName) => ffi.using((arena) {
  return raw.ExportWave(
    wave.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

bool ExportWaveAsCode(Wave wave, String fileName) => ffi.using((arena) {
  return raw.ExportWaveAsCode(
    wave.ptr.ref,
    fileName.toNativeUtf8(allocator: arena).cast(),
  );
});

void PlaySound(Sound sound) => raw.PlaySound(sound.ptr.ref);

void StopSound(Sound sound) => raw.StopSound(sound.ptr.ref);

void PauseSound(Sound sound) => raw.PauseSound(sound.ptr.ref);

void ResumeSound(Sound sound) => raw.ResumeSound(sound.ptr.ref);

bool IsSoundPlaying(Sound sound) => raw.IsSoundPlaying(sound.ptr.ref);

void SetSoundVolume(Sound sound, double volume) =>
    raw.SetSoundVolume(sound.ptr.ref, volume);

void SetSoundPitch(Sound sound, double pitch) =>
    raw.SetSoundPitch(sound.ptr.ref, pitch);

void SetSoundPan(Sound sound, double pan) =>
    raw.SetSoundPan(sound.ptr.ref, pan);

Wave WaveCopy(Wave wave) => raw.WaveCopy(wave.ptr.ref).toDart();

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

void UnloadWaveSamples(Float32List samples) {}

Music LoadMusicStream(String fileName) => ffi.using((arena) {
  return raw.LoadMusicStream(
    fileName.toNativeUtf8(allocator: arena).cast(),
  ).toDart();
});

Music LoadMusicStreamFromMemory(String fileType, Uint8List data) =>
    ffi.using((arena) {
      return raw.LoadMusicStreamFromMemory(
        fileType.toNativeUtf8(allocator: arena).cast(),
        arena.bytes(data),
        data.length,
      ).toDart();
    });

bool IsMusicValid(Music music) => raw.IsMusicValid(music.ptr.ref);

void UnloadMusicStream(Music music) => music.dispose();

void PlayMusicStream(Music music) => raw.PlayMusicStream(music.ptr.ref);

bool IsMusicStreamPlaying(Music music) =>
    raw.IsMusicStreamPlaying(music.ptr.ref);

void UpdateMusicStream(Music music) => raw.UpdateMusicStream(music.ptr.ref);

void StopMusicStream(Music music) => raw.StopMusicStream(music.ptr.ref);

void PauseMusicStream(Music music) => raw.PauseMusicStream(music.ptr.ref);

void ResumeMusicStream(Music music) => raw.ResumeMusicStream(music.ptr.ref);

void SeekMusicStream(Music music, double position) =>
    raw.SeekMusicStream(music.ptr.ref, position);

void SetMusicVolume(Music music, double volume) =>
    raw.SetMusicVolume(music.ptr.ref, volume);

void SetMusicPitch(Music music, double pitch) =>
    raw.SetMusicPitch(music.ptr.ref, pitch);

void SetMusicPan(Music music, double pan) =>
    raw.SetMusicPan(music.ptr.ref, pan);

double GetMusicTimeLength(Music music) => raw.GetMusicTimeLength(music.ptr.ref);

double GetMusicTimePlayed(Music music) => raw.GetMusicTimePlayed(music.ptr.ref);

AudioStream LoadAudioStream(int sampleRate, int sampleSize, int channels) =>
    raw.LoadAudioStream(sampleRate, sampleSize, channels).toDart();

bool IsAudioStreamValid(AudioStream stream) =>
    raw.IsAudioStreamValid(stream.ptr.ref);

void UnloadAudioStream(AudioStream stream) => stream.dispose();

void UpdateAudioStream(AudioStream stream, Uint8List data, int frameCount) =>
    ffi.using((arena) {
      raw.UpdateAudioStream(
        stream.ptr.ref,
        arena.bytes(data).cast(),
        frameCount,
      );
    });

bool IsAudioStreamProcessed(AudioStream stream) =>
    raw.IsAudioStreamProcessed(stream.ptr.ref);

void PlayAudioStream(AudioStream stream) => raw.PlayAudioStream(stream.ptr.ref);

void PauseAudioStream(AudioStream stream) =>
    raw.PauseAudioStream(stream.ptr.ref);

void ResumeAudioStream(AudioStream stream) =>
    raw.ResumeAudioStream(stream.ptr.ref);

bool IsAudioStreamPlaying(AudioStream stream) =>
    raw.IsAudioStreamPlaying(stream.ptr.ref);

void StopAudioStream(AudioStream stream) => raw.StopAudioStream(stream.ptr.ref);

void SetAudioStreamVolume(AudioStream stream, double volume) =>
    raw.SetAudioStreamVolume(stream.ptr.ref, volume);

void SetAudioStreamPitch(AudioStream stream, double pitch) =>
    raw.SetAudioStreamPitch(stream.ptr.ref, pitch);

void SetAudioStreamPan(AudioStream stream, double pan) =>
    raw.SetAudioStreamPan(stream.ptr.ref, pan);

void SetAudioStreamCallback(AudioStream stream, AudioCallback callback) =>
    raw.SetAudioStreamCallback(stream.ptr.ref, callback);

void AttachAudioStreamProcessor(AudioStream stream, AudioCallback processor) =>
    raw.AttachAudioStreamProcessor(stream.ptr.ref, processor);

void DetachAudioStreamProcessor(AudioStream stream, AudioCallback processor) =>
    raw.DetachAudioStreamProcessor(stream.ptr.ref, processor);

void AttachAudioMixedProcessor(AudioCallback processor) =>
    raw.AttachAudioMixedProcessor(processor);

void DetachAudioMixedProcessor(AudioCallback processor) =>
    raw.DetachAudioMixedProcessor(processor);
