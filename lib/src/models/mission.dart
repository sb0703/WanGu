enum MissionType {
  collect, // 收集物品
  hunt, // 讨伐怪物
}

class MissionReward {
  final int contribution; // 宗门贡献
  final int exp; // 修为/经验
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
  final int? timeLimitDays; // Time limit in game days, null means no limit
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
    this.timeLimitDays,
    required this.reward,
  });
}

class ActiveMission {
  final String missionId;
  int currentCount;
  bool isCompleted; // 是否已达成目标，可提交

  // 记录接取时的游戏时间
  final int startYear;
  final int startMonth;
  final int startDay;
  final int startHour;

  ActiveMission({
    required this.missionId,
    this.currentCount = 0,
    this.isCompleted = false,
    required this.startYear,
    required this.startMonth,
    required this.startDay,
    required this.startHour,
  });

  Map<String, dynamic> toJson() => {
    'missionId': missionId,
    'currentCount': currentCount,
    'isCompleted': isCompleted,
    'startYear': startYear,
    'startMonth': startMonth,
    'startDay': startDay,
    'startHour': startHour,
  };

  factory ActiveMission.fromJson(Map<String, dynamic> json) {
    return ActiveMission(
      missionId: json['missionId'] as String,
      currentCount: json['currentCount'] as int,
      isCompleted: json['isCompleted'] as bool,
      startYear: json['startYear'] as int? ?? 1,
      startMonth: json['startMonth'] as int? ?? 1,
      startDay: json['startDay'] as int? ?? 1,
      startHour: json['startHour'] as int? ?? 0,
    );
  }
}
