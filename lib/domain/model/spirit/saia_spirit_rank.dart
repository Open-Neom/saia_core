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

  /// Key for the localized display name of this rank.
  String get displayNameKey => switch (this) {
    dormant  => SaiaCoreTranslationConstants.spiritRankDormantName,
    awakened => SaiaCoreTranslationConstants.spiritRankAwakenedName,
    trained  => SaiaCoreTranslationConstants.spiritRankTrainedName,
    veteran  => SaiaCoreTranslationConstants.spiritRankVeteranName,
    master   => SaiaCoreTranslationConstants.spiritRankMasterName,
    legend   => SaiaCoreTranslationConstants.spiritRankLegendName,
  };

  /// Key for the localized description of this rank.
  String get descriptionKey => switch (this) {
    dormant  => SaiaCoreTranslationConstants.spiritRankDormantDesc,
    awakened => SaiaCoreTranslationConstants.spiritRankAwakenedDesc,
    trained  => SaiaCoreTranslationConstants.spiritRankTrainedDesc,
    veteran  => SaiaCoreTranslationConstants.spiritRankVeteranDesc,
    master   => SaiaCoreTranslationConstants.spiritRankMasterDesc,
    legend   => SaiaCoreTranslationConstants.spiritRankLegendDesc,
  };

  /// The display name of this rank (English default fallback).
  String get displayName => switch (this) {
    dormant  => 'Dormant',
    awakened => 'Awakened',
    trained  => 'Trained',
    veteran  => 'Veteran',
    master   => 'Master',
    legend   => 'Legend',
  };

  /// The description of this rank (English default fallback).
  String get description => switch (this) {
    dormant  => 'Your spirit has not awakened yet',
    awakened => 'First sparks of consciousness',
    trained  => 'Learns your voice and style',
    veteran  => 'Recognized by the community',
    master   => 'Deep alignment with you',
    legend   => 'Your spirit transcends',
  };
}

