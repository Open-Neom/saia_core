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

  String get displayName => switch (this) {
    design       => 'Disenar voz',
    clone        => 'Clonar voz',
    ultimateClone => 'Clonacion profunda',
  };

  String get description => switch (this) {
    design       => 'Crea una voz nueva desde una descripcion',
    clone        => 'Reproduce una voz desde un audio de referencia',
    ultimateClone => 'Reproduce cada matiz de la voz original',
  };
}
