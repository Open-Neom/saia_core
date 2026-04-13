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
  int get totalInteractions => itzliReplies + manualReplies + feedbackCount;

  /// Whether the spirit has been activated (has any activity).
  bool get isActive => totalInteractions > 0;

  /// Whether the spirit is considered "trained" (enough feedback).
  bool get isTrained => feedbackCount >= 10;

  /// Whether the spirit is "aligned" (high confirmation rate).
  bool get isAligned => confirmationRate >= 0.7 && feedbackCount >= 5;

  /// Spirit power level — composite score for display.
  /// Combines tier, TST, karma, training, and acceptance.
  int get powerLevel {
    var power = tierLevel * 10;             // 10-50 from subscription
    power += tstLevel * 5;                  // 0-50 from cognitive level
    power += (karma ~/ 5).clamp(0, 50);     // 0-50 from reputation
    power += feedbackCount.clamp(0, 30);    // 0-30 from training
    power += acceptedAnswers * 3;           // 3 per best answer
    return power;
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

  factory SaiaSpirit.fromJSON(Map<String, dynamic>? data) {
    if (data == null) return const SaiaSpirit(userId: '');
    return SaiaSpirit(
      userId: data['userId'] as String? ?? '',
      ownerName: data['ownerName'] as String? ?? '',
      tierLevel: data['tierLevel'] as int? ?? 0,
      tstLevel: data['tstLevel'] as int? ?? 0,
      karma: data['karma'] as int? ?? 0,
      isRecognized: data['isRecognized'] as bool? ?? false,
      itzliReplies: data['itzliReplies'] as int? ?? 0,
      manualReplies: data['manualReplies'] as int? ?? 0,
      feedbackCount: data['feedbackCount'] as int? ?? 0,
      confirmationRate: (data['confirmationRate'] as num?)?.toDouble() ?? 0.0,
      acceptedAnswers: data['acceptedAnswers'] as int? ?? 0,
      createdAt: data['createdAt'] as int? ?? 0,
      lastActiveAt: data['lastActiveAt'] as int? ?? 0,
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
    return SaiaSpirit(
      userId: userId,
      ownerName: ownerName ?? this.ownerName,
      tierLevel: tierLevel ?? this.tierLevel,
      tstLevel: tstLevel ?? this.tstLevel,
      karma: karma ?? this.karma,
      isRecognized: isRecognized ?? this.isRecognized,
      itzliReplies: itzliReplies ?? this.itzliReplies,
      manualReplies: manualReplies ?? this.manualReplies,
      feedbackCount: feedbackCount ?? this.feedbackCount,
      confirmationRate: confirmationRate ?? this.confirmationRate,
      acceptedAnswers: acceptedAnswers ?? this.acceptedAnswers,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  String toString() => 'SaiaSpirit($ownerName, tier:$tierLevel, '
      'tst:$tstLevel, karma:$karma, power:$powerLevel, rank:${rank.name})';
}
