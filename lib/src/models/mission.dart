
enum MissionType {
  collect, // 收集物品
  hunt,    // 讨伐怪物
}

class MissionReward {
  final int contribution; // 宗门贡献
  final int exp;          // 修为/经验
  final List<String> itemIds; // 奖励物品ID列表

  const MissionReward({
    this.contribution = 0,
    this.exp = 0,
    this.itemIds = const [],
  });
}

class Mission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final String targetId; // 物品ID 或 怪物ID
  final String targetName; // 目标名称显示
  final int targetCount;
  final int difficulty; // 1-10
  final MissionReward reward;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetId,
    required this.targetName,
    required this.targetCount,
    required this.difficulty,
    required this.reward,
  });
}

class ActiveMission {
  final String missionId;
  int currentCount;
  bool isCompleted; // 是否已达成目标，可提交

  ActiveMission({
    required this.missionId,
    this.currentCount = 0,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    'missionId': missionId,
    'currentCount': currentCount,
    'isCompleted': isCompleted,
  };

  factory ActiveMission.fromJson(Map<String, dynamic> json) {
    return ActiveMission(
      missionId: json['missionId'] as String,
      currentCount: json['currentCount'] as int,
      isCompleted: json['isCompleted'] as bool,
    );
  }
}
