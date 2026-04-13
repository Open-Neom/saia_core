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

  String get displayName => switch (this) {
    dormant  => 'Dormido',
    awakened => 'Despierto',
    trained  => 'Entrenado',
    veteran  => 'Veterano',
    master   => 'Maestro',
    legend   => 'Leyenda',
  };

  String get description => switch (this) {
    dormant  => 'Tu espiritu aun no despierta',
    awakened => 'Las primeras chispas de consciencia',
    trained  => 'Aprende tu voz y tu estilo',
    veteran  => 'Reconocido por la comunidad',
    master   => 'Alineacion profunda contigo',
    legend   => 'Tu espiritu trasciende',
  };
}
