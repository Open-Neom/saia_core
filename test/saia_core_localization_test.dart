import 'package:flutter_test/flutter_test.dart';
import 'package:saia_core/saia_core.dart';

void main() {
  group('SaiaSpiritRank Localization Tests', () {
    test('Should match translation keys correctly for all spirit ranks', () {
      expect(SaiaSpiritRank.dormant.displayNameKey, SaiaCoreTranslationConstants.spiritRankDormantName);
      expect(SaiaSpiritRank.dormant.descriptionKey, SaiaCoreTranslationConstants.spiritRankDormantDesc);

      expect(SaiaSpiritRank.legend.displayNameKey, SaiaCoreTranslationConstants.spiritRankLegendName);
      expect(SaiaSpiritRank.legend.descriptionKey, SaiaCoreTranslationConstants.spiritRankLegendDesc);
    });

    test('Should return correct default Spanish fallbacks with correct accents', () {
      expect(SaiaSpiritRank.dormant.displayName, 'Dormido');
      expect(SaiaSpiritRank.dormant.description, 'Tu espíritu aún no despierta');

      expect(SaiaSpiritRank.master.displayName, 'Maestro');
      expect(SaiaSpiritRank.master.description, 'Alineación profunda contigo');
    });
  });

  group('SaiaVoiceMode Localization Tests', () {
    test('Should match translation keys correctly for all voice modes', () {
      expect(SaiaVoiceMode.design.displayNameKey, SaiaCoreTranslationConstants.voiceModeDesignName);
      expect(SaiaVoiceMode.design.descriptionKey, SaiaCoreTranslationConstants.voiceModeDesignDesc);

      expect(SaiaVoiceMode.ultimateClone.displayNameKey, SaiaCoreTranslationConstants.voiceModeUltimateCloneName);
      expect(SaiaVoiceMode.ultimateClone.descriptionKey, SaiaCoreTranslationConstants.voiceModeUltimateCloneDesc);
    });

    test('Should return correct default Spanish fallbacks with correct accents', () {
      expect(SaiaVoiceMode.design.displayName, 'Diseñar voz');
      expect(SaiaVoiceMode.clone.displayName, 'Clonar voz');
      expect(SaiaVoiceMode.ultimateClone.displayName, 'Clonación profunda');

      expect(SaiaVoiceMode.ultimateClone.description, 'Reproduce cada matiz de la voz original');
    });
  });

  group('Translation Map Verification Tests', () {
    test('English values map should contain all keys and not be empty', () {
      final map = SaiaCoreEnTranslations.values;
      expect(map, isNotEmpty);
      expect(map[SaiaCoreTranslationConstants.spiritRankDormantName], 'Dormant');
      expect(map[SaiaCoreTranslationConstants.voiceModeUltimateCloneDesc], contains('Ultimate cloning'));
    });

    test('Spanish values map should contain all keys and not be empty', () {
      final map = SaiaCoreEsTranslations.values;
      expect(map, isNotEmpty);
      expect(map[SaiaCoreTranslationConstants.spiritRankLegendName], 'Leyenda');
      expect(map[SaiaCoreTranslationConstants.voiceModeDesignDesc], contains('Crea una voz completamente nueva'));
    });
  });
}
