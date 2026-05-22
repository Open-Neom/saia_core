import '../../../utils/constants/saia_core_translation_constants.dart';

/// The three modes of SAIA voice synthesis.
///
/// Mirrors VoxCPM's architecture so when we switch from ElevenLabs
/// to self-hosted VoxCPM, zero code changes are needed upstream.
enum SaiaVoiceMode {
  /// Create a new voice from a text description alone.
  /// No reference audio needed.
  /// Example: "(mujer joven, voz calida) Hola, bienvenido"
  design,

  /// Clone a voice from a reference audio sample.
  /// Reproduces general timbre and tone.
  clone,

  /// Ultimate cloning — reproduces every nuance.
  /// Requires reference audio + its exact transcript.
  /// Preserves rhythm, emotion, breathing, micro-pauses.
  ultimateClone;

  /// Key for the localized display name of this voice mode.
  String get displayNameKey => switch (this) {
    design        => SaiaCoreTranslationConstants.voiceModeDesignName,
    clone         => SaiaCoreTranslationConstants.voiceModeCloneName,
    ultimateClone => SaiaCoreTranslationConstants.voiceModeUltimateCloneName,
  };

  /// Key for the localized description of this voice mode.
  String get descriptionKey => switch (this) {
    design        => SaiaCoreTranslationConstants.voiceModeDesignDesc,
    clone         => SaiaCoreTranslationConstants.voiceModeCloneDesc,
    ultimateClone => SaiaCoreTranslationConstants.voiceModeUltimateCloneDesc,
  };

  /// The display name of this voice mode (English default fallback).
  String get displayName => switch (this) {
    design        => 'Voice Design',
    clone         => 'Voice Cloning',
    ultimateClone => 'Deep Cloning',
  };

  /// The description of this voice mode (English default fallback).
  String get description => switch (this) {
    design        => 'Creates a new voice from a text description',
    clone         => 'Reproduces a voice from a reference audio sample',
    ultimateClone => 'Reproduces every nuance of the original voice',
  };
}

