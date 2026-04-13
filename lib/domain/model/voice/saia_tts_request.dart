import 'dart:typed_data';

import 'saia_voice_mode.dart';

/// Request for SAIA TTS synthesis — supports all 3 voice modes.
///
/// For design mode: provide [designDescription] (no audio needed).
/// For clone mode: provide [referenceAudio].
/// For ultimate clone: provide [referenceAudio] + [referenceTranscript].
class SaiaTtsRequest {
  /// Text to synthesize.
  final String text;

  /// Voice mode to use.
  final SaiaVoiceMode mode;

  /// Text description for voice design.
  /// Format: "mujer joven, voz calida, tono profesional"
  final String? designDescription;

  /// Reference audio bytes for cloning modes.
  final Uint8List? referenceAudio;

  /// Exact transcript of the reference audio (for ultimate clone).
  final String? referenceTranscript;

  /// Provider-specific voice ID to use (if known).
  final String? voiceId;

  /// Speech speed multiplier (1.0 = normal).
  final double speed;

  /// Language code.
  final String language;

  const SaiaTtsRequest({
    required this.text,
    this.mode = SaiaVoiceMode.design,
    this.designDescription,
    this.referenceAudio,
    this.referenceTranscript,
    this.voiceId,
    this.speed = 1.0,
    this.language = 'es-MX',
  });

  /// Convenience: design mode request.
  factory SaiaTtsRequest.design({
    required String text,
    required String description,
    String language = 'es-MX',
  }) => SaiaTtsRequest(
    text: text,
    mode: SaiaVoiceMode.design,
    designDescription: description,
    language: language,
  );

  /// Convenience: clone mode request.
  factory SaiaTtsRequest.clone({
    required String text,
    required Uint8List referenceAudio,
    String language = 'es-MX',
  }) => SaiaTtsRequest(
    text: text,
    mode: SaiaVoiceMode.clone,
    referenceAudio: referenceAudio,
    language: language,
  );

  /// Convenience: ultimate clone request.
  factory SaiaTtsRequest.ultimateClone({
    required String text,
    required Uint8List referenceAudio,
    required String referenceTranscript,
    String language = 'es-MX',
  }) => SaiaTtsRequest(
    text: text,
    mode: SaiaVoiceMode.ultimateClone,
    referenceAudio: referenceAudio,
    referenceTranscript: referenceTranscript,
    language: language,
  );
}
