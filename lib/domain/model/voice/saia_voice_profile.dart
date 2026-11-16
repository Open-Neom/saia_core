import '../ia_item_info.dart';
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

  static final RegExp _unsafeControlsRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u202A-\u202E\u2066-\u2069\u061C]',
  );
  static final RegExp _gemmaThoughtRe = RegExp(
    r'<\|(?:channel|turn)>thought\b[\s\S]*?(?:<(?:channel|turn)\|>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalBlockRe = RegExp(
    r'<\s*(think|thought|auto_memory|system_context|memory_recall)\b[^>]*>[\s\S]*?(?:<\s*/\s*\1\s*>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalTagRe = RegExp(
    r'(?:<\s*/?\s*(?:think|thought|auto_memory|system_context|memory_recall)\b[^>]*>|<\|/?turn\|>|<\|(?:channel|turn)\b[^>]*>|<(?:channel|turn)\|>|\[\s*(?:MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT|BIOCHIP\s*:[^\]]*)\s*\])',
    caseSensitive: false,
  );
  static final RegExp _windowsReservedStemRe = RegExp(
    r'^(?:con|prn|aux|nul|com[1-9]|lpt[1-9])$',
    caseSensitive: false,
  );

  static String _truncateUtf16Safe(String input, int maxChars) {
    if (maxChars <= 0 || input.isEmpty) return '';
    if (input.length <= maxChars) return input;
    var end = maxChars;
    final prev = input.codeUnitAt(end - 1);
    if (prev >= 0xD800 && prev <= 0xDBFF) {
      end -= 1;
    }
    return end <= 0 ? '' : input.substring(0, end);
  }

  static String? _sanitizeOptString(Object? raw, {required int maxChars}) {
    if (raw == null) return null;
    var text = raw
        .toString()
        .replaceAll(_gemmaThoughtRe, '')
        .replaceAll(_internalBlockRe, '')
        .replaceAll(_internalTagRe, '')
        .replaceAll(_unsafeControlsRe, '')
        .trim();
    if (text.isEmpty) return null;
    if (text.length > maxChars) {
      text = _truncateUtf16Safe(text, maxChars).trimRight();
    }
    return text.isEmpty ? null : text;
  }

  static String? _sanitizeIdentifier(Object? raw, {required int maxChars}) {
    final cleaned = _sanitizeOptString(raw, maxChars: maxChars);
    if (cleaned == null) return null;
    if (cleaned == '.' ||
        cleaned == '..' ||
        cleaned == '__proto__' ||
        cleaned == 'constructor' ||
        cleaned == 'prototype' ||
        RegExp(r'^__.*__$').hasMatch(cleaned) ||
        cleaned.contains('/') ||
        cleaned.contains(r'\') ||
        cleaned.contains('?') ||
        cleaned.contains('#')) {
      return null;
    }
    final lower = cleaned.toLowerCase();
    if (lower.contains('%00') ||
        lower.contains('%2e') ||
        lower.contains('%2f') ||
        lower.contains('%5c')) {
      return null;
    }
    return cleaned;
  }

  static int _parseFiniteInt(Object? raw) {
    if (raw is num) {
      return raw.isFinite && raw >= 0 ? raw.toInt() : 0;
    }
    if (raw is String) {
      final parsed = int.tryParse(raw.trim());
      if (parsed != null && parsed >= 0) return parsed;
    }
    return 0;
  }

  static bool _isSensitiveLocalPath(String rawPath) {
    final norm = rawPath.trim().replaceAll(r'\', '/').toLowerCase();
    final segments = norm.split('/').where((s) => s.isNotEmpty).toList();
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final stem = seg.split('.').first;
      if (_windowsReservedStemRe.hasMatch(stem) ||
          seg == '.ssh' ||
          seg == '.gnupg' ||
          seg == '.aws' ||
          seg == '.azure' ||
          seg == '.kube' ||
          seg == '.git' ||
          seg == 'keychains' ||
          seg == '.env' ||
          seg.startsWith('.env.') ||
          seg == '.secret.local' ||
          seg == '.git-credentials' ||
          seg == '.netrc' ||
          seg == '.npmrc' ||
          seg == '.pypirc' ||
          seg == 'application_default_credentials.json' ||
          seg == 'id_rsa' ||
          seg == 'id_ed25519' ||
          seg == 'id_ecdsa' ||
          seg == 'id_dsa' ||
          seg == 'authorized_keys' ||
          seg.endsWith('.pem') ||
          seg.endsWith('.key') ||
          seg.endsWith('.p12') ||
          seg.endsWith('.pfx') ||
          seg.endsWith('.kdbx')) {
        return true;
      }
      if (seg == '.config' &&
          i + 1 < segments.length &&
          segments[i + 1] == 'gcloud') {
        return true;
      }
    }
    return norm.startsWith('/etc/') ||
        norm.startsWith('/private/etc/') ||
        norm.startsWith('/proc/') ||
        norm.startsWith('/sys/') ||
        norm.startsWith('/dev/');
  }

  /// Rejects path traversal (`..`), CLI flags (`-`), credentials/SSRF hosts in
  /// URLs, sensitive local credential paths, and unsafe schemes (`javascript:`,
  /// `data:`) in [referenceAudioPath].
  static bool isSafeReferenceAudioSource(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty ||
        trimmed.length > 1024 ||
        trimmed.startsWith('-') ||
        trimmed.startsWith('//') ||
        trimmed.startsWith(r'\\') ||
        trimmed.startsWith(r'\??\') ||
        _unsafeControlsRe.hasMatch(trimmed)) {
      return false;
    }
    final lower = trimmed.toLowerCase();
    if (lower.startsWith('javascript:') ||
        lower.startsWith('data:') ||
        lower.startsWith('vbscript:') ||
        lower.startsWith('file:') ||
        lower.contains('%00') ||
        lower.contains('%2e') ||
        lower.contains('%2f') ||
        lower.contains('%5c')) {
      return false;
    }
    if (trimmed.contains('://')) {
      return IaItemInfo.isSafePublicAvatarUrl(trimmed);
    }
    final segments = trimmed.split(RegExp(r'[/\\]'));
    if (segments.any((s) => s == '..')) {
      return false;
    }
    return !_isSensitiveLocalPath(trimmed);
  }

  factory SaiaVoiceProfile.fromJSON(Map<Object?, Object?>? data) {
    if (data == null) return const SaiaVoiceProfile(id: '', userId: '', name: '');
    final modeName = data['mode']?.toString().trim() ?? 'design';
    final rawAudioPath = _sanitizeOptString(
      data['referenceAudioPath'],
      maxChars: 1024,
    );
    return SaiaVoiceProfile(
      id: _sanitizeIdentifier(data['id'], maxChars: 128) ?? '',
      userId: _sanitizeIdentifier(data['userId'], maxChars: 128) ?? '',
      name: _sanitizeOptString(data['name'], maxChars: 120) ?? '',
      mode: SaiaVoiceMode.values.firstWhere(
        (e) => e.name == modeName,
        orElse: () => SaiaVoiceMode.design,
      ),
      designDescription: _sanitizeOptString(
        data['designDescription'],
        maxChars: 1000,
      ),
      providerVoiceId: _sanitizeOptString(
        data['providerVoiceId'],
        maxChars: 256,
      ),
      referenceAudioPath: rawAudioPath != null &&
              isSafeReferenceAudioSource(rawAudioPath)
          ? rawAudioPath
          : null,
      referenceTranscript: _sanitizeOptString(
        data['referenceTranscript'],
        maxChars: 4000,
      ),
      language: _sanitizeOptString(data['language'], maxChars: 16) ?? 'es-MX',
      createdAt: _parseFiniteInt(data['createdAt']),
      lastUsedAt: _parseFiniteInt(data['lastUsedAt']),
    );
  }
}
