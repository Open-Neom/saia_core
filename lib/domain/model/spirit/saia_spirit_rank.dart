import '../../../utils/constants/saia_core_translation_constants.dart';

/// Rank of a SaiaSpirit based on its composite power level.
///
/// Each rank represents a stage of evolution:
///   dormant  → spirit not yet activated (powerLevel < 10)
///   awakened → first interactions (10-29)
///   trained  → consistent feedback and training (30-59)
///   veteran  → significant community presence (60-99)
///   master   → expert-level alignment and karma (100-149)
///   legend   → peak evolution, recognized across the ecosystem (150+)
enum SaiaSpiritRank {
  dormant,
  awakened,
  trained,
  veteran,
  master,
  legend;

  /// Clave para la localización del nombre del rango.
  String get displayNameKey => switch (this) {
    dormant  => SaiaCoreTranslationConstants.spiritRankDormantName,
    awakened => SaiaCoreTranslationConstants.spiritRankAwakenedName,
    trained  => SaiaCoreTranslationConstants.spiritRankTrainedName,
    veteran  => SaiaCoreTranslationConstants.spiritRankVeteranName,
    master   => SaiaCoreTranslationConstants.spiritRankMasterName,
    legend   => SaiaCoreTranslationConstants.spiritRankLegendName,
  };

  /// Clave para la localización de la descripción del rango.
  String get descriptionKey => switch (this) {
    dormant  => SaiaCoreTranslationConstants.spiritRankDormantDesc,
    awakened => SaiaCoreTranslationConstants.spiritRankAwakenedDesc,
    trained  => SaiaCoreTranslationConstants.spiritRankTrainedDesc,
    veteran  => SaiaCoreTranslationConstants.spiritRankVeteranDesc,
    master   => SaiaCoreTranslationConstants.spiritRankMasterDesc,
    legend   => SaiaCoreTranslationConstants.spiritRankLegendDesc,
  };

  /// Nombre del rango en español (fallback por defecto).
  String get displayName => switch (this) {
    dormant  => 'Dormido',
    awakened => 'Despierto',
    trained  => 'Entrenado',
    veteran  => 'Veterano',
    master   => 'Maestro',
    legend   => 'Leyenda',
  };

  /// Descripción del rango en español (fallback por defecto).
  String get description => switch (this) {
    dormant  => 'Tu espíritu aún no despierta',
    awakened => 'Las primeras chispas de consciencia',
    trained  => 'Aprende tu voz y tu estilo',
    veteran  => 'Reconocido por la comunidad',
    master   => 'Alineación profunda contigo',
    legend   => 'Tu espíritu trasciende',
  };
}

