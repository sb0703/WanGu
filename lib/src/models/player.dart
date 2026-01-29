import 'item.dart';
import 'realm_stage.dart';
import 'stats.dart';

class Player {
  const Player({
    required this.name,
    required this.stageIndex,
    this.level = 1, // 1-10 (Display as Layer 1 to 10/Perfection)
    required this.stats,
    required this.xp,
    required this.lifespanDays,
    required this.inventory,
    required this.equipped,
  });

  final String name;
  final int stageIndex;
  final int level; // Minor realm level: 1..9, 10=Perfection
  final Stats stats;
  final int xp;
  final int lifespanDays;
  final List<Item> inventory;
  final List<Item> equipped;

  RealmStage get realm => RealmStage.stages[stageIndex];
  
  // Calculate max XP for current level
  // Base XP * (1 + (level-1) * 0.5) -> Scaling up
  int get currentMaxXp {
    final base = realm.maxXp;
    // Level 1: 100%, Level 2: 150%, ..., Level 9: 500%
    return (base * (1 + (level - 1) * 0.5)).toInt();
  }
  
  String get realmLabel {
    if (level >= 10) return '${realm.name}大圆满';
    const cnNumbers = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];
    final levelStr = level <= 10 ? cnNumbers[level - 1] : '$level';
    return '${realm.name}$levelStr层';
  }

  Player copyWith({
    String? name,
    int? stageIndex,
    int? level,
    Stats? stats,
    int? xp,
    int? lifespanDays,
    List<Item>? inventory,
    List<Item>? equipped,
  }) {
    return Player(
      name: name ?? this.name,
      stageIndex: stageIndex ?? this.stageIndex,
      level: level ?? this.level,
      stats: stats ?? this.stats,
      xp: xp ?? this.xp,
      lifespanDays: lifespanDays ?? this.lifespanDays,
      inventory: inventory ?? this.inventory,
      equipped: equipped ?? this.equipped,
    );
  }
}
