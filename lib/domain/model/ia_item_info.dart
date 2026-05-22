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

  /// Deserializes a new [IaItemInfo] from a JSON-compatible [Map].
  IaItemInfo.fromJSON(Map<String, dynamic>? data)
      : itemId = data?['itemId'] ?? '',
        isEnabled = data?['isEnabled'] ?? false,
        agentName = data?['agentName'] ?? '',
        personality = data?['personality'] ?? '',
        itemContext = data?['itemContext'] ?? '',
        authorInstructions = data?['authorInstructions'] ?? '',
        contextGeneratedAt = data?['contextGeneratedAt'] ?? 0,
        language = data?['language'] ?? 'es',
        avatarUrl = data?['avatarUrl'] ?? '';

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
