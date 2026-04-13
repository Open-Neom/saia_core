import 'dart:typed_data';

/// Result of a SAIA TTS synthesis operation.
class SaiaTtsResult {
  /// Raw audio bytes.
  final Uint8List audioBytes;

  /// Audio format (mp3, wav, pcm).
  final String format;

  /// Sample rate in Hz (e.g., 48000 for VoxCPM, 44100 for ElevenLabs).
  final int sampleRate;

  /// Estimated duration in milliseconds.
  final int durationMs;

  /// Which provider generated this audio.
  final String provider;

  const SaiaTtsResult({
    required this.audioBytes,
    this.format = 'mp3',
    this.sampleRate = 44100,
    this.durationMs = 0,
    this.provider = '',
  });

  bool get isEmpty => audioBytes.isEmpty;
  bool get isNotEmpty => audioBytes.isNotEmpty;
}
