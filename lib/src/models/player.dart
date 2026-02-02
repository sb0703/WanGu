import '../data/buffs_repository.dart';
import 'buff.dart';
import 'item.dart';
import 'realm_stage.dart';
import 'stats.dart';

/// Player model
class Player {
  const Player({
    required this.name,
    this.gender = '男', // default gender
    this.appearance = '平平无奇',
    this.roots = const {},
    this.traits = const [],
    this.race = Race.human,
    required this.stageIndex,
    this.level = 1, // 1-10 (显示为 1..10 层小境界)
    required this.stats,
    required this.xp,
    this.contribution = 0,
    required this.lifespanDays,
    required this.inventory,
    required this.equipped,
    this.buffIds = const [], // 状态效果ID列表
  });

  final String name;
  final String gender;
  final String appearance;
  final Map<String, int> roots;
  final List<String> traits;
  final Race race;
  final int stageIndex; // 0=练气, 1=筑基...
  final int level; // 1..9, 10=大圆满
  final Stats stats;
  final int xp;
  final int contribution;
  final int lifespanDays; // days
  final List<Item> inventory;
  final List<Item> equipped;
  final List<String> buffIds;

  /// 当前大境界
  RealmStage get realm => RealmStage.stages[stageIndex];

  /// 当前有效的所有 Buff
  List<Buff> get activeBuffs =>
      buffIds.map((id) => BuffsRepository.get(id)).whereType<Buff>().toList();

  /// Buff 加成后的最终属性
  Stats get effectiveStats {
    Stats finalStats = stats;
    for (final buff in activeBuffs) {
      finalStats = finalStats + buff.statModifiers;
    }
    return finalStats;
  }

  /// 当前等级需要的最大经验
  int get currentMaxXp {
    final base = realm.maxXp;
    return (base * (1 + (level - 1) * 0.5)).toInt();
  }

  /// 境界文字描述
  String get realmLabel {
    final realmName = realm.getName(race);
    if (level >= 10) return '$realmName大圆满';
    const cnNumbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    final levelStr = level <= 10 ? cnNumbers[level - 1] : '$level';
    return '$realmName$levelStr层';
  }

  Player copyWith({
    String? name,
    String? gender,
    String? appearance,
    Map<String, int>? roots,
    List<String>? traits,
    Race? race,
    int? stageIndex,
    int? level,
    Stats? stats,
    int? xp,
    int? contribution,
    num? lifespanDays,
    List<Item>? inventory,
    List<Item>? equipped,
    List<String>? buffIds,
  }) {
    return Player(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      appearance: appearance ?? this.appearance,
      roots: roots ?? this.roots,
      traits: traits ?? this.traits,
      race: race ?? this.race,
      stageIndex: stageIndex ?? this.stageIndex,
      level: level ?? this.level,
      stats: stats ?? this.stats,
      xp: xp ?? this.xp,
      contribution: contribution ?? this.contribution,
      lifespanDays: (lifespanDays ?? this.lifespanDays).toInt(),
      inventory: inventory ?? this.inventory,
      equipped: equipped ?? this.equipped,
      buffIds: buffIds ?? this.buffIds,
    );
  }
}
