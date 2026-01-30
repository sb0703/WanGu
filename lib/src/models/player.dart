import '../data/buffs_repository.dart';
import 'buff.dart';
import 'item.dart';
import 'realm_stage.dart';
import 'stats.dart';

/// 玩家模型
class Player {
  const Player({
    required this.name,
    this.gender = '男', // 默认性别
    required this.stageIndex,
    this.level = 1, // 1-10 (显示为 1 到 10 层/圆满)
    required this.stats,
    required this.xp,
    required this.lifespanDays,
    required this.inventory,
    required this.equipped,
    this.buffIds = const [], // 状态效果ID列表
  });

  final String name; // 姓名
  final String gender; // 性别
  final int stageIndex; // 境界索引 (如: 0=练气, 1=筑基)
  final int level; // 小境界层数: 1..9, 10=大圆满
  final Stats stats; // 基础属性
  final int xp; // 当前修为(经验值)
  final int lifespanDays; // 剩余寿元(天)
  final List<Item> inventory; // 背包物品
  final List<Item> equipped; // 已装备物品
  final List<String> buffIds; // 当前生效的状态ID

  /// 获取当前大境界信息
  RealmStage get realm => RealmStage.stages[stageIndex];

  /// 获取当前生效的所有Buff对象
  List<Buff> get activeBuffs =>
      buffIds.map((id) => BuffsRepository.get(id)).whereType<Buff>().toList();

  /// 获取生效后的最终属性 (包含Buff加成)
  Stats get effectiveStats {
    Stats finalStats = stats;
    for (final buff in activeBuffs) {
      finalStats = finalStats + buff.statModifiers;
    }
    return finalStats;
  }

  // 计算当前等级的修为上限
  // 基础修为 * (1 + (level-1) * 0.5) -> 逐级递增
  int get currentMaxXp {
    final base = realm.maxXp;
    // Level 1: 100%, Level 2: 150%, ..., Level 9: 500%
    return (base * (1 + (level - 1) * 0.5)).toInt();
  }

  /// 获取境界文本描述 (如: 练气三层)
  String get realmLabel {
    if (level >= 10) return '${realm.name}大圆满';
    const cnNumbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    final levelStr = level <= 10 ? cnNumbers[level - 1] : '$level';
    return '${realm.name}$levelStr层';
  }

  Player copyWith({
    String? name,
    String? gender,
    int? stageIndex,
    int? level,
    Stats? stats,
    int? xp,
    num? lifespanDays,
    List<Item>? inventory,
    List<Item>? equipped,
    List<String>? buffIds,
  }) {
    return Player(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      stageIndex: stageIndex ?? this.stageIndex,
      level: level ?? this.level,
      stats: stats ?? this.stats,
      xp: xp ?? this.xp,
      lifespanDays: (lifespanDays ?? this.lifespanDays).toInt(),
      inventory: inventory ?? this.inventory,
      equipped: equipped ?? this.equipped,
      buffIds: buffIds ?? this.buffIds,
    );
  }
}
