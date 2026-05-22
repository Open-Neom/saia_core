import 'package:flutter/material';
import 'package:saia_core/saia_core.dart';

void main() {
  runApp(const SaiaCoreExampleApp());
}

/// A beautiful example application showcasing the capabilities of the
/// Systemic Artificial Intelligence Agent (SAIA) core module.
class SaiaCoreExampleApp extends StatelessWidget {
  const SaiaCoreExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAIA Core Example',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8A2BE2),
          secondary: Color(0xFF00E5FF),
          surface: Color(0xFF1E1E30),
        ),
      ),
      home: const SaiaDashboardScreen(),
    );
  }
}

/// The main dashboard screen showing SAIA's features:
/// Spirit Ranks, Voice Synthesis Modes, and Translation Contracts.
class SaiaDashboardScreen extends StatefulWidget {
  const SaiaDashboardScreen({super.key});

  @override
  State<SaiaDashboardScreen> createState() => _SaiaDashboardScreenState();
}

class _SaiaDashboardScreenState extends State<SaiaDashboardScreen> {
  // Demo AI Spirit instance using saia_core models.
  final SaiaSpirit _demoSpirit = SaiaSpirit(
    spiritId: 'saia-spirit-001',
    ownerId: 'user-neom-777',
    displayName: 'Aura-AI',
    powerLevel: 125, // Maps to SaiaSpiritRank.master
    rank: SaiaSpiritRank.master,
    auraIntensity: 0.85,
    customColorHex: '#8A2BE2',
    lastSyncTimestamp: DateTime.now().millisecondsSinceEpoch,
  );

  bool _isEnglish = true;

  @override
  Widget build(BuildContext context) {
    // Select translation map based on state
    final translations = _isEnglish
        ? SaiaCoreEnTranslations.values
        : SaiaCoreEsTranslations.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Systemic Artificial Intelligence Agent (SAIA)'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(_isEnglish ? 'English' : 'Español', style: const TextStyle(fontSize: 14)),
              Switch(
                value: !_isEnglish,
                onChanged: (val) {
                  setState(() {
                    _isEnglish = !val;
                  });
                },
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Spirit Aura Card
            _buildSpiritCard(translations),
            const SizedBox(height: 32),

            // 2. Spirit Ranks Grid
            Text(
              _isEnglish ? 'Ecosystem Spirit Ranks' : 'Rangos de Espíritus en el Ecosistema',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRanksSection(translations),
            const SizedBox(height: 32),

            // 3. Voice Synthesis Modes
            Text(
              _isEnglish ? 'Voice Synthesis Configurations' : 'Configuraciones de Síntesis de Voz',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildVoiceModesSection(translations),
          ],
        ),
      ),
    );
  }

  Widget _buildSpiritCard(Map<String, String> translations) {
    final rankName = translations[_demoSpirit.rank.displayNameKey] ?? _demoSpirit.rank.displayName;
    final rankDesc = translations[_demoSpirit.rank.descriptionKey] ?? _demoSpirit.rank.description;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3A1C71), Color(0xFFD76D77), Color(0xFFFFAF7B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8A2BE2).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _demoSpirit.displayName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ID: ${_demoSpirit.spiritId}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${_demoSpirit.powerLevel} PL',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rankName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rankDesc,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _demoSpirit.auraIntensity,
              backgroundColor: Colors.white.withOpacity(0.15),
              color: Colors.white,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRanksSection(Map<String, String> translations) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 3 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: SaiaSpiritRank.values.length,
          itemBuilder: (context, index) {
            final rank = SaiaSpiritRank.values[index];
            final rankName = translations[rank.displayNameKey] ?? rank.displayName;
            final rankDesc = translations[rank.descriptionKey] ?? rank.description;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        rankName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Icon(
                        Icons.shield,
                        color: _getRankColor(rank),
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      rankDesc,
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildVoiceModesSection(Map<String, String> translations) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: SaiaVoiceMode.values.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final mode = SaiaVoiceMode.values[index];
        final modeName = translations[mode.displayNameKey] ?? mode.displayName;
        final modeDesc = translations[mode.descriptionKey] ?? mode.description;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              child: Icon(
                _getVoiceIcon(mode),
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: Text(
              modeName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              modeDesc,
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
            ),
          ),
        );
      },
    );
  }

  Color _getRankColor(SaiaSpiritRank rank) {
    switch (rank) {
      case SaiaSpiritRank.dormant:
        return Colors.grey;
      case SaiaSpiritRank.awakened:
        return Colors.green;
      case SaiaSpiritRank.trained:
        return Colors.blue;
      case SaiaSpiritRank.veteran:
        return Colors.orange;
      case SaiaSpiritRank.master:
        return Colors.purple;
      case SaiaSpiritRank.legend:
        return Colors.red;
    }
  }

  IconData _getVoiceIcon(SaiaVoiceMode mode) {
    switch (mode) {
      case SaiaVoiceMode.design:
        return Icons.record_voice_over;
      case SaiaVoiceMode.clone:
        return Icons.copy;
      case SaiaVoiceMode.ultimateClone:
        return Icons.graphic_eq;
    }
  }
}
