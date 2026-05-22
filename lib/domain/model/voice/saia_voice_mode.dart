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

  /// Clave para la localización del nombre del modo de voz.
  String get displayNameKey => switch (this) {
    design        => SaiaCoreTranslationConstants.voiceModeDesignName,
    clone         => SaiaCoreTranslationConstants.voiceModeCloneName,
    ultimateClone => SaiaCoreTranslationConstants.voiceModeUltimateCloneName,
  };

  /// Clave para la localización de la descripción del modo de voz.
  String get descriptionKey => switch (this) {
    design        => SaiaCoreTranslationConstants.voiceModeDesignDesc,
    clone         => SaiaCoreTranslationConstants.voiceModeCloneDesc,
    ultimateClone => SaiaCoreTranslationConstants.voiceModeUltimateCloneDesc,
  };

  /// Nombre del modo de voz en español (fallback por defecto).
  String get displayName => switch (this) {
    design        => 'Diseñar voz',
    clone         => 'Clonar voz',
    ultimateClone => 'Clonación profunda',
  };

  /// Descripción del modo de voz en español (fallback por defecto).
  String get description => switch (this) {
    design        => 'Crea una voz nueva desde una descripción',
    clone         => 'Reproduce una voz desde un audio de referencia',
    ultimateClone => 'Reproduce cada matiz de la voz original',
  };
}

