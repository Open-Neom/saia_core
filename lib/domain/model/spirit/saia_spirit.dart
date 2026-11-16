import 'saia_spirit_rank.dart';

/// The user's AI spirit — a persistent, evolving companion.
///
/// Each user has one SaiaSpirit that grows through interaction.
/// The spirit is visible in forums, profiles, and social contexts.
/// It reflects how much the user has trained their AI instance
/// and how the community values their contributions.
///
/// Inspired by the Shaman King model: the spirit fights alongside
/// the user, learns their techniques, and becomes stronger over time.
class SaiaSpirit {
  /// User ID that owns this spirit.
  final String userId;

  /// Display name of the spirit's owner.
  final String ownerName;

  /// Subscription tier level (1-5): Obsidiana → Jade.
  /// Determines the spirit's visual stone appearance.
  final int tierLevel;

  /// TST (Tier Stratus Tiere) level (0-10).
  /// Reflects the cognitive sophistication of the spirit.
  final int tstLevel;

  /// Forum karma — accumulated from upvotes on content.
  final int karma;

  /// Whether the spirit has recognition status (karma >= threshold).
  /// Recognized spirits bypass tier gating in forums.
  final bool isRecognized;

  /// Total replies where the spirit (Itzli) drafted the response.
  final int itzliReplies;

  /// Total replies where the user wrote manually.
  final int manualReplies;

  /// Total feedbacks (corrections to Itzli drafts).
  /// Higher = more trained spirit.
  final int feedbackCount;

  /// Percentage of Itzli drafts confirmed without edits.
  /// Higher = spirit aligned with user's voice.
  final double confirmationRate;

  /// Total replies marked as "accepted" (best answer).
  final int acceptedAnswers;

  /// When the spirit was first activated.
  final int createdAt;

  /// Last time the spirit was active (replied or posted).
  final int lastActiveAt;

  const SaiaSpirit({
    required this.userId,
    this.ownerName = '',
    this.tierLevel = 0,
    this.tstLevel = 0,
    this.karma = 0,
    this.isRecognized = false,
    this.itzliReplies = 0,
    this.manualReplies = 0,
    this.feedbackCount = 0,
    this.confirmationRate = 0.0,
    this.acceptedAnswers = 0,
    this.createdAt = 0,
    this.lastActiveAt = 0,
  });

  // ══════════════════════════════════════════════════════════
  // Computed — Spirit evolution metrics
  // ══════════════════════════════════════════════════════════

  /// Total interactions (replies + feedbacks).
  int get totalInteractions {
    final safeItzli =
        itzliReplies.isFinite && itzliReplies > 0 ? itzliReplies : 0;
    final safeManual =
        manualReplies.isFinite && manualReplies > 0 ? manualReplies : 0;
    final safeFeedback =
        feedbackCount.isFinite && feedbackCount > 0 ? feedbackCount : 0;
    return safeItzli + safeManual + safeFeedback;
  }

  /// Whether the spirit has been activated (has any activity).
  bool get isActive => totalInteractions > 0;

  /// Whether the spirit is considered "trained" (enough feedback).
  bool get isTrained => feedbackCount.isFinite && feedbackCount >= 10;

  /// Whether the spirit is "aligned" (high confirmation rate).
  bool get isAligned =>
      confirmationRate.isFinite &&
      confirmationRate >= 0.7 &&
      feedbackCount.isFinite &&
      feedbackCount >= 5;

  /// Spirit power level — composite score for display.
  /// Combines tier, TST, karma, training, and acceptance.
  int get powerLevel {
    final safeTier = tierLevel.isFinite ? tierLevel.clamp(0, 5) : 0;
    final safeTst = tstLevel.isFinite ? tstLevel.clamp(0, 10) : 0;
    final safeKarma = karma.isFinite ? (karma ~/ 5).clamp(0, 50) : 0;
    final safeFeedback = feedbackCount.isFinite ? feedbackCount.clamp(0, 30) : 0;
    final safeAccepted =
        acceptedAnswers.isFinite ? acceptedAnswers.clamp(0, 10000) : 0;
    var power = safeTier * 10; // 0-50 from subscription
    power += safeTst * 5; // 0-50 from cognitive level
    power += safeKarma; // 0-50 from reputation
    power += safeFeedback; // 0-30 from training
    power += safeAccepted * 3; // 3 per best answer (bounded)
    return power;
  }

  static final RegExp _gemmaChannelRe = RegExp(
    r'<\|(?:channel|turn)>thought\b[\s\S]*?(?:<(?:channel|turn)\|>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalBlockRe = RegExp(
    r'<\s*(think|thought|memory_recall|auto_memory|system_context)\b[^>]*>[\s\S]*?(?:<\s*/\s*\1\s*>|$)',
    caseSensitive: false,
  );
  static final RegExp _internalTagRe = RegExp(
    r'(?:<\s*/?\s*(?:think|thought|memory_recall|auto_memory|system_context)\b[^>]*>|<\|/?turn\|>|<\|(?:channel|turn)\b[^>]*>|<(?:channel|turn)\|>|\[\s*(?:BIOCHIP\s*:[^\]]*|MEMORY_RECALL|AUTO_MEMORY|SYSTEM_CONTEXT)\s*\])',
    caseSensitive: false,
  );
  static final RegExp _unsafeControlOrBidiRe = RegExp(
    r'[\x00-\x1F\x7F-\x9F\u202A-\u202E\u2066-\u2069\u061C]',
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

  static String _sanitizeLabel(String raw, {required int maxChars}) {
    if (raw.isEmpty) return '';
    var cleaned = raw
        .replaceAll(_gemmaChannelRe, '')
        .replaceAll(_internalBlockRe, '')
        .replaceAll(_internalTagRe, '')
        .replaceAll(_unsafeControlOrBidiRe, '')
        .trim();
    if (cleaned.length > maxChars) {
      cleaned = _truncateUtf16Safe(cleaned, maxChars).trimRight();
    }
    return cleaned;
  }

  static String _sanitizeUserId(String raw) {
    final cleaned = _sanitizeLabel(raw, maxChars: 128);
    if (cleaned.isEmpty ||
        cleaned == '.' ||
        cleaned == '..' ||
        cleaned == '__proto__' ||
        cleaned == 'constructor' ||
        cleaned == 'prototype' ||
        RegExp(r'^__.*__$').hasMatch(cleaned) ||
        cleaned.contains('/') ||
        cleaned.contains(r'\') ||
        cleaned.contains('?') ||
        cleaned.contains('#')) {
      return '';
    }
    final lower = cleaned.toLowerCase();
    if (lower.contains('%00') ||
        lower.contains('%2e') ||
        lower.contains('%2f') ||
        lower.contains('%5c')) {
      return '';
    }
    return cleaned;
  }

  static int _parseFiniteInt(Object? raw, {int fallback = 0}) {
    if (raw is num) {
      return raw.isFinite ? raw.toInt() : fallback;
    }
    if (raw is String) {
      return int.tryParse(raw.trim()) ?? fallback;
    }
    return fallback;
  }

  static double _parseFiniteDouble(Object? raw, {double fallback = 0.0}) {
    if (raw is num) {
      final d = raw.toDouble();
      return d.isFinite ? d : fallback;
    }
    if (raw is String) {
      final d = double.tryParse(raw.trim());
      if (d != null && d.isFinite) return d;
    }
    return fallback;
  }

  /// Spirit rank based on power level.
  SaiaSpiritRank get rank {
    final p = powerLevel;
    if (p >= 150) return SaiaSpiritRank.legend;
    if (p >= 100) return SaiaSpiritRank.master;
    if (p >= 60)  return SaiaSpiritRank.veteran;
    if (p >= 30)  return SaiaSpiritRank.trained;
    if (p >= 10)  return SaiaSpiritRank.awakened;
    return SaiaSpiritRank.dormant;
  }

  /// The spirit's aura intensity (0.0 to 1.0) for visual rendering.
  /// Based on recent activity and alignment.
  double get auraIntensity {
    if (!isActive) return 0.0;
    var intensity = 0.3; // base for any active spirit
    if (isTrained) intensity += 0.2;
    if (isAligned) intensity += 0.2;
    if (isRecognized) intensity += 0.3;
    return intensity.clamp(0.0, 1.0);
  }

  // ══════════════════════════════════════════════════════════
  // Serialization
  // ══════════════════════════════════════════════════════════

  Map<String, dynamic> toJSON() => {
    'userId': userId,
    'ownerName': ownerName,
    'tierLevel': tierLevel,
    'tstLevel': tstLevel,
    'karma': karma,
    'isRecognized': isRecognized,
    'itzliReplies': itzliReplies,
    'manualReplies': manualReplies,
    'feedbackCount': feedbackCount,
    'confirmationRate': confirmationRate,
    'acceptedAnswers': acceptedAnswers,
    'createdAt': createdAt,
    'lastActiveAt': lastActiveAt,
  };

  factory SaiaSpirit.fromJSON(Map<Object?, Object?>? data) {
    if (data == null) return const SaiaSpirit(userId: '');
    final rawRate = _parseFiniteDouble(data['confirmationRate']);
    final cleanRate = rawRate.clamp(0.0, 1.0);
    return SaiaSpirit(
      userId: _sanitizeUserId(data['userId']?.toString() ?? ''),
      ownerName:
          _sanitizeLabel(data['ownerName']?.toString() ?? '', maxChars: 120),
      tierLevel: _parseFiniteInt(data['tierLevel']).clamp(0, 5),
      tstLevel: _parseFiniteInt(data['tstLevel']).clamp(0, 10),
      karma: _parseFiniteInt(data['karma']),
      isRecognized: data['isRecognized'] == true,
      itzliReplies: _parseFiniteInt(data['itzliReplies']).clamp(
        0,
        100000000,
      ),
      manualReplies: _parseFiniteInt(data['manualReplies']).clamp(
        0,
        100000000,
      ),
      feedbackCount: _parseFiniteInt(data['feedbackCount']).clamp(
        0,
        100000000,
      ),
      confirmationRate: cleanRate,
      acceptedAnswers: _parseFiniteInt(data['acceptedAnswers']).clamp(
        0,
        100000000,
      ),
      createdAt: _parseFiniteInt(data['createdAt']),
      lastActiveAt: _parseFiniteInt(data['lastActiveAt']),
    );
  }

  SaiaSpirit copyWith({
    String? ownerName,
    int? tierLevel,
    int? tstLevel,
    int? karma,
    bool? isRecognized,
    int? itzliReplies,
    int? manualReplies,
    int? feedbackCount,
    double? confirmationRate,
    int? acceptedAnswers,
    int? lastActiveAt,
  }) {
    final nextRate = confirmationRate != null
        ? (confirmationRate.isFinite ? confirmationRate.clamp(0.0, 1.0) : 0.0)
        : this.confirmationRate;
    return SaiaSpirit(
      userId: userId,
      ownerName: ownerName != null
          ? _sanitizeLabel(ownerName, maxChars: 120)
          : this.ownerName,
      tierLevel: tierLevel ?? this.tierLevel,
      tstLevel: tstLevel ?? this.tstLevel,
      karma: karma ?? this.karma,
      isRecognized: isRecognized ?? this.isRecognized,
      itzliReplies: itzliReplies ?? this.itzliReplies,
      manualReplies: manualReplies ?? this.manualReplies,
      feedbackCount: feedbackCount ?? this.feedbackCount,
      confirmationRate: nextRate,
      acceptedAnswers: acceptedAnswers ?? this.acceptedAnswers,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  String toString() => 'SaiaSpirit($ownerName, tier:$tierLevel, '
      'tst:$tstLevel, karma:$karma, power:$powerLevel, rank:${rank.name})';
}
