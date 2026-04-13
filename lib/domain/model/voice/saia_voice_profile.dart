import 'saia_voice_mode.dart';

/// A stored voice profile — the "voice" of a user's SaiaSpirit.
///
/// Can be created via design (text description), clone (reference audio),
/// or ultimate clone (reference + transcript). The profile stores
/// the configuration needed to reproduce the voice consistently.
class SaiaVoiceProfile {
  /// Unique identifier for this voice profile.
  final String id;

  /// User who owns this voice profile.
  final String userId;

  /// Display name for the voice.
  final String name;

  /// How this voice was created.
  final SaiaVoiceMode mode;

  /// Text description used for design mode.
  /// Example: "mujer joven, voz calida, tono profesional"
  final String? designDescription;

  /// Provider-specific voice ID (e.g., ElevenLabs voice_id).
  /// When we switch to VoxCPM, this becomes the LoRA adapter path.
  final String? providerVoiceId;

  /// Path or URL to the reference audio used for cloning.
  final String? referenceAudioPath;

  /// Transcript of the reference audio (for ultimate clone mode).
  final String? referenceTranscript;

  /// Language code (e.g., 'es-MX', 'en-US').
  final String language;

  /// When this profile was created.
  final int createdAt;

  /// When this profile was last used.
  final int lastUsedAt;

  const SaiaVoiceProfile({
    required this.id,
    required this.userId,
    required this.name,
    this.mode = SaiaVoiceMode.design,
    this.designDescription,
    this.providerVoiceId,
    this.referenceAudioPath,
    this.referenceTranscript,
    this.language = 'es-MX',
    this.createdAt = 0,
    this.lastUsedAt = 0,
  });

  Map<String, dynamic> toJSON() => {
    'id': id,
    'userId': userId,
    'name': name,
    'mode': mode.name,
    'designDescription': designDescription,
    'providerVoiceId': providerVoiceId,
    'referenceAudioPath': referenceAudioPath,
    'referenceTranscript': referenceTranscript,
    'language': language,
    'createdAt': createdAt,
    'lastUsedAt': lastUsedAt,
  };

  factory SaiaVoiceProfile.fromJSON(Map<String, dynamic>? data) {
    if (data == null) return const SaiaVoiceProfile(id: '', userId: '', name: '');
    return SaiaVoiceProfile(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      name: data['name'] as String? ?? '',
      mode: SaiaVoiceMode.values.firstWhere(
        (e) => e.name == (data['mode'] as String? ?? 'design'),
        orElse: () => SaiaVoiceMode.design,
      ),
      designDescription: data['designDescription'] as String?,
      providerVoiceId: data['providerVoiceId'] as String?,
      referenceAudioPath: data['referenceAudioPath'] as String?,
      referenceTranscript: data['referenceTranscript'] as String?,
      language: data['language'] as String? ?? 'es-MX',
      createdAt: data['createdAt'] as int? ?? 0,
      lastUsedAt: data['lastUsedAt'] as int? ?? 0,
    );
  }
}
