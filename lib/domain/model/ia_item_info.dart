/// AI configuration for a release item (book, song, etc).
/// Stores pre-generated context so AI doesn't need to process
/// the PDF/content on every chat session.
class IaItemInfo {
  /// Unique identifier of the release item.
  String itemId;

  /// Whether AI assistant is enabled for this item.
  // ignore: prefer_final_fields
  bool isEnabled;

  /// Custom name for the AI assistant (configured by author in EMXI).
  String agentName;

  /// Personality/tone of the AI (configured by author in EMXI).
  /// Examples: "friendly and casual", "formal and academic", "mysterious narrator".
  String personality;

  /// Pre-generated context/summary of the book content.
  /// This is generated once when the author enables AI and can be
  /// manually edited or regenerated.
  String itemContext;

  /// Additional context or instructions from the author.
  String authorInstructions;

  /// Timestamp when context was last generated.
  int contextGeneratedAt;

  /// Language of the content (for response language hints).
  String language;

  /// Avatar URL for the AI agent (optional custom avatar).
  String avatarUrl;

  /// Default constructor for creating an [IaItemInfo] configuration.
  IaItemInfo({
    this.itemId = '',
    this.isEnabled = false,
    this.agentName = '',
    this.personality = '',
    this.itemContext = '',
    this.authorInstructions = '',
    this.contextGeneratedAt = 0,
    this.language = 'es',
    this.avatarUrl = '',
  });

  @override
  String toString() {
    return 'IaItemInfo{itemId: $itemId, isEnabled: $isEnabled, agentName: $agentName, personality: $personality, '
        'itemContext: ${itemContext.length} chars, authorInstructions: ${authorInstructions.length} chars, '
        'contextGeneratedAt: $contextGeneratedAt, language: $language, avatarUrl: $avatarUrl}';
  }

  static const int maxItemIdChars = 128;
  static const int maxAgentNameChars = 120;
  static const int maxPersonalityChars = 2000;
  static const int maxItemContextChars = 131072;
  static const int maxAuthorInstructionsChars = 16384;

  static final RegExp _gemmaChannelRe = RegExp(
    r'<\|(?:channel|turn)\s*>\s*thought\b[\s\S]*?(?:<(?:channel|turn)\|>|$)'
    r'|<\|tool_call\s*>[\s\S]*?(?:<tool_call\|>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalBlockRe = RegExp(
    r'<\s*(think|thought|auto_memory|system_context|memory_recall)\b[^>]*>[\s\S]*?(?:<\s*/\s*\1\s*>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalTagRe = RegExp(
    r'(?:<\s*/?\s*(?:think|thought|auto_memory|system_context|memory_recall)\b[^>]*>|<\|/?(?:turn|channel|tool_call|im_start|im_end|eot_id)\|>|<\|(?:channel|turn|tool_call)\b[^>]*>|<(?:channel|turn|tool_call)\|>|<end_of_turn>|\[\s*(?:MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT|BIOCHIP\s*:[^\]]*)\s*\])',
    caseSensitive: false,
  );
  static final RegExp _contentCloseTagRe = RegExp(
    r'<\s*/\s*content\s*>',
    caseSensitive: false,
  );
  static final RegExp _idnDotHomoglyphRe = RegExp(r'[\u3002\uFF0E\uFF61]');
  static final RegExp _unsafeInlineControlsRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u061C\u200B-\u200F\u2028\u2029\u202A-\u202E\u2060-\u2064\u2066-\u2069\uFEFF]',
  );
  static final RegExp _unsafeMultilineControlsRe = RegExp(
    r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F-\x9F\u061C\u200B-\u200F\u2028\u2029\u202A-\u202E\u2060-\u2064\u2066-\u2069\uFEFF]',
  );
  static final RegExp _encodedControlOrBidiInUriRe = RegExp(
    r'%(?:0[0-9a-f]|1[0-9a-f]|7f|c2%[89][0-9a-f]|d8%9c|e2%80%(?:8[b-f]|a[8-e])|e2%81%a[0-9]|ef%bb%bf)',
    caseSensitive: false,
  );
  static const Set<String> _forbiddenItemIds = {
    '.',
    '..',
    '__proto__',
    'constructor',
    'prototype',
  };

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

  /// Validates that [rawId] is a safe Firestore/storage identifier free of
  /// path separators, traversal segments, prototype keys, and control chars.
  static bool isSafeItemId(String rawId) {
    if (_unsafeInlineControlsRe.hasMatch(rawId)) return false;
    final trimmed = rawId.trim();
    final lower = trimmed.toLowerCase();
    if (trimmed.isEmpty ||
        trimmed.length > maxItemIdChars ||
        _forbiddenItemIds.contains(lower) ||
        RegExp(r'^__.*__$').hasMatch(trimmed) ||
        trimmed.contains('..') ||
        trimmed.contains('/') ||
        trimmed.contains(r'\') ||
        trimmed.contains('?') ||
        trimmed.contains('#') ||
        _unsafeInlineControlsRe.hasMatch(trimmed)) {
      return false;
    }
    return !lower.contains('%00') &&
        !lower.contains('%2e') &&
        !lower.contains('%2f') &&
        !lower.contains('%5c') &&
        !lower.contains('%25');
  }

  static String _sanitizeItemId(Object? raw) {
    final cleaned = _sanitizeText(raw, maxChars: maxItemIdChars);
    return isSafeItemId(cleaned) ? cleaned : '';
  }

  static String _sanitizeText(
    Object? raw, {
    required int maxChars,
    bool multiline = false,
    String fallback = '',
  }) {
    if (raw == null) return fallback;
    var text = raw
        .toString()
        .replaceAll(_gemmaChannelRe, '')
        .replaceAll(_internalBlockRe, '')
        .replaceAll(_internalTagRe, '')
        .replaceAll(_contentCloseTagRe, '[content_end]')
        .replaceAll(
          multiline ? _unsafeMultilineControlsRe : _unsafeInlineControlsRe,
          '',
        )
        .trim();
    if (text.isEmpty) return fallback;
    if (text.length > maxChars) {
      text = _truncateUtf16Safe(text, maxChars).trimRight();
    }
    return text;
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

  /// Validates that [rawUrl] is an allowed public `http`/`https` avatar URL
  /// free of credentials, loopback/private/metadata SSRF hosts, and traversal.
  static bool isSafePublicAvatarUrl(String rawUrl) {
    if (_unsafeInlineControlsRe.hasMatch(rawUrl)) return false;
    final trimmed = rawUrl.trim();
    if (trimmed.isEmpty ||
        trimmed.length > 2048 ||
        trimmed.contains(r'\') ||
        _idnDotHomoglyphRe.hasMatch(trimmed) ||
        _unsafeInlineControlsRe.hasMatch(trimmed) ||
        _encodedControlOrBidiInUriRe.hasMatch(trimmed)) {
      return false;
    }
    final lowerRaw = trimmed.toLowerCase();
    if (lowerRaw.contains('%00') ||
        lowerRaw.contains('%2e') ||
        lowerRaw.contains('%2f') ||
        lowerRaw.contains('%5c') ||
        lowerRaw.contains('%25') ||
        lowerRaw.contains('/../')) {
      return false;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'https' && scheme != 'http') return false;
    if (uri.userInfo.isNotEmpty) return false;
    final host = uri.host.toLowerCase().replaceAll(RegExp(r'\.+$'), '');
    if (host.isEmpty ||
        host == 'localhost' ||
        host.endsWith('.localhost') ||
        host.endsWith('.local') ||
        host.endsWith('.internal') ||
        host.endsWith('.ts.net') ||
        host.endsWith('.onion') ||
        host.endsWith('.test') ||
        host.endsWith('.example') ||
        host == 'metadata.google.internal' ||
        host == 'metadata.goog' ||
        host == 'instance-data') {
      return false;
    }
    if (host.contains(':')) {
      final bare = host.startsWith('[') && host.endsWith(']')
          ? host.substring(1, host.length - 1)
          : host;
      if (bare == '::1' ||
          bare == '::' ||
          bare.startsWith('fe80:') ||
          bare.startsWith('fc') ||
          bare.startsWith('fd') ||
          bare.startsWith('ff') ||
          bare.contains('ffff:') ||
          bare.startsWith('2001:0:') ||
          bare.startsWith('2001::') ||
          bare.startsWith('2001:db8:') ||
          bare.contains('%')) {
        return false;
      }
      return !uri.pathSegments.any((s) => s == '..');
    }
    final parts = host.split('.');
    if (parts.length == 4 && parts.every((p) => RegExp(r'^\d+$').hasMatch(p))) {
      final octets = parts.map(int.tryParse).toList();
      if (octets.any((o) => o == null || o < 0 || o > 255)) return false;
      final a = octets[0]!;
      final b = octets[1]!;
      final c = octets[2]!;
      if (a == 0 ||
          a == 10 ||
          a == 127 ||
          (a == 169 && b == 254) ||
          (a == 172 && b >= 16 && b <= 31) ||
          (a == 192 && b == 168) ||
          (a == 100 && b >= 64 && b <= 127) ||
          (a == 192 && b == 0 && c == 2) ||
          (a == 198 && b == 51 && c == 100) ||
          (a == 203 && b == 0 && c == 113) ||
          (a == 198 && (b == 18 || b == 19)) ||
          a >= 224) {
        return false;
      }
    }
    return !uri.pathSegments.any((s) => s == '..');
  }

  static String _sanitizeAvatarUrl(Object? raw) {
    if (raw == null) return '';
    final candidate = raw.toString().trim();
    if (candidate.isEmpty) return '';
    return isSafePublicAvatarUrl(candidate) ? candidate : '';
  }

  /// Deserializes a new [IaItemInfo] from a JSON-compatible [Map].
  IaItemInfo.fromJSON(Map<Object?, Object?>? data)
      : itemId = _sanitizeItemId(data?['itemId']),
        isEnabled = data?['isEnabled'] == true,
        agentName =
            _sanitizeText(data?['agentName'], maxChars: maxAgentNameChars),
        personality = _sanitizeText(
          data?['personality'],
          maxChars: maxPersonalityChars,
          multiline: true,
        ),
        itemContext = _sanitizeText(
          data?['itemContext'],
          maxChars: maxItemContextChars,
          multiline: true,
        ),
        authorInstructions = _sanitizeText(
          data?['authorInstructions'],
          maxChars: maxAuthorInstructionsChars,
          multiline: true,
        ),
        contextGeneratedAt = _parseFiniteInt(data?['contextGeneratedAt']),
        language = _sanitizeText(
          data?['language'],
          maxChars: 16,
          fallback: 'es',
        ),
        avatarUrl = _sanitizeAvatarUrl(data?['avatarUrl']);

  /// Serializes this [IaItemInfo] into a JSON-compatible [Map].
  Map<String, dynamic> toJSON() => {
        'itemId': itemId,
        'isEnabled': isEnabled,
        'agentName': agentName,
        'personality': personality,
        'itemContext': itemContext,
        'authorInstructions': authorInstructions,
        'contextGeneratedAt': contextGeneratedAt,
        'language': language,
        'avatarUrl': avatarUrl,
      };

  /// Creates a copy of this [IaItemInfo] with optionally overridden properties.
  IaItemInfo copyWith({
    String? itemId,
    bool? isEnabled,
    String? agentName,
    String? personality,
    String? itemContext,
    String? authorInstructions,
    int? contextGeneratedAt,
    String? language,
    String? avatarUrl,
  }) {
    return IaItemInfo(
      itemId: itemId ?? this.itemId,
      isEnabled: isEnabled ?? this.isEnabled,
      agentName: agentName ?? this.agentName,
      personality: personality ?? this.personality,
      itemContext: itemContext ?? this.itemContext,
      authorInstructions: authorInstructions ?? this.authorInstructions,
      contextGeneratedAt: contextGeneratedAt ?? this.contextGeneratedAt,
      language: language ?? this.language,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  /// Check if context has been generated.
  bool get hasContext => itemContext.isNotEmpty;

  /// Check if properly configured for chat.
  bool get isReadyForChat => isEnabled && agentName.isNotEmpty && hasContext;
}
