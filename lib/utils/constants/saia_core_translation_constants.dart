/// Translation keys for user-facing strings in the saia_core package.
///
/// Use as: `SaiaCoreTranslationConstants.spiritRankDormantName.tr` in GetX/Sint
/// enabled environments.
///
/// Each app that depends on saia_core should aggregate
/// `SaiaCoreEsTranslations.values` (and other locale variants) in its unmerged
/// app-level translation dictionary.
class SaiaCoreTranslationConstants {
  SaiaCoreTranslationConstants._();

  // ── Spirit Rank Names ──
  static const String spiritRankDormantName = 'spiritRankDormantName';
  static const String spiritRankAwakenedName = 'spiritRankAwakenedName';
  static const String spiritRankTrainedName = 'spiritRankTrainedName';
  static const String spiritRankVeteranName = 'spiritRankVeteranName';
  static const String spiritRankMasterName = 'spiritRankMasterName';
  static const String spiritRankLegendName = 'spiritRankLegendName';

  // ── Spirit Rank Descriptions ──
  static const String spiritRankDormantDesc = 'spiritRankDormantDesc';
  static const String spiritRankAwakenedDesc = 'spiritRankAwakenedDesc';
  static const String spiritRankTrainedDesc = 'spiritRankTrainedDesc';
  static const String spiritRankVeteranDesc = 'spiritRankVeteranDesc';
  static const String spiritRankMasterDesc = 'spiritRankMasterDesc';
  static const String spiritRankLegendDesc = 'spiritRankLegendDesc';

  // ── Voice Mode Names ──
  static const String voiceModeDesignName = 'voiceModeDesignName';
  static const String voiceModeCloneName = 'voiceModeCloneName';
  static const String voiceModeUltimateCloneName = 'voiceModeUltimateCloneName';

  // ── Voice Mode Descriptions ──
  static const String voiceModeDesignDesc = 'voiceModeDesignDesc';
  static const String voiceModeCloneDesc = 'voiceModeCloneDesc';
  static const String voiceModeUltimateCloneDesc = 'voiceModeUltimateCloneDesc';
}
