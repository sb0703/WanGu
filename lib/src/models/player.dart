import 'item.dart';
import 'realm_stage.dart';
import 'stats.dart';

class Player {
  const Player({
    required this.name,
    required this.stageIndex,
    required this.stats,
    required this.xp,
    required this.lifespanHours,
    required this.inventory,
    required this.equipped,
  });

  final String name;
  final int stageIndex;
  final Stats stats;
  final int xp;
  final int lifespanHours;
  final List<Item> inventory;
  final List<Item> equipped;

  RealmStage get realm => RealmStage.stages[stageIndex];

  Player copyWith({
    String? name,
    int? stageIndex,
    Stats? stats,
    int? xp,
    int? lifespanHours,
    List<Item>? inventory,
    List<Item>? equipped,
  }) {
    return Player(
      name: name ?? this.name,
      stageIndex: stageIndex ?? this.stageIndex,
      stats: stats ?? this.stats,
      xp: xp ?? this.xp,
      lifespanHours: lifespanHours ?? this.lifespanHours,
      inventory: inventory ?? this.inventory,
      equipped: equipped ?? this.equipped,
    );
  }
}
