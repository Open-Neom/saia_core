import '../model/voice/saia_tts_request.dart';
import '../model/voice/saia_tts_result.dart';
import '../model/voice/saia_voice_mode.dart';
import '../model/voice/saia_voice_profile.dart';

/// Abstract TTS provider contract for the SAIA ecosystem.
///
/// Supports 3 voice modes: design, clone, ultimate clone.
/// Currently implemented by ElevenLabs. Future: self-hosted VoxCPM.
///
/// The provider is swappable — when VoxCPM server is ready,
/// switch the implementation without changing any consuming code.
abstract class SaiaTtsProvider {
  /// Provider identifier (e.g., 'elevenlabs', 'voxcpm').
  String get providerId;

  /// Human-readable display name.
  String get displayName;

  /// Whether the provider is configured and ready to use.
  bool get isConfigured;

  /// Which voice modes this provider supports.
  List<SaiaVoiceMode> get supportedModes;

  /// Initialize the provider (load credentials, warm up, etc.).
  Future<void> initialize();

  /// Synthesize speech from a request.
  ///
  /// The request's [SaiaTtsRequest.mode] determines which synthesis
  /// pipeline is used:
  /// - [SaiaVoiceMode.design]: text description → new voice
  /// - [SaiaVoiceMode.clone]: reference audio → cloned voice
  /// - [SaiaVoiceMode.ultimateClone]: reference + transcript → exact clone
  Future<SaiaTtsResult> synthesize(SaiaTtsRequest request);

  /// Synthesize with streaming — yields audio chunks as they're generated.
  ///
  /// Not all providers support streaming. Default: generates full audio
  /// and yields it as a single chunk.
  Stream<SaiaTtsResult> synthesizeStream(SaiaTtsRequest request) async* {
    yield await synthesize(request);
  }

  /// Create and store a voice profile for future reuse.
  ///
  /// For design mode: stores the description + generated voice ID.
  /// For clone mode: uploads reference audio and stores the voice ID.
  /// For ultimate clone: stores reference audio + transcript + voice ID.
  Future<SaiaVoiceProfile> createVoiceProfile(SaiaTtsRequest request);

  /// List available pre-built voices from this provider.
  Future<List<SaiaVoiceProfile>> listVoices({String? language});

  /// Release resources.
  void dispose();
}
