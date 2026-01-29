import 'item.dart';
import 'realm_stage.dart';
import 'stats.dart';

class Player {
  const Player({
    required this.name,
    required this.stageIndex,
    required this.stats,
    required this.xp,
    required this.lifespanDays,
    required this.inventory,
    required this.equipped,
  });

  final String name;
  final int stageIndex;
  final Stats stats;
  final int xp;
  final int lifespanDays;
  final List<Item> inventory;
  final List<Item> equipped;

  RealmStage get realm => RealmStage.stages[stageIndex];

  Player copyWith({
    String? name,
    int? stageIndex,
    Stats? stats,
    int? xp,
    int? lifespanDays,
    List<Item>? inventory,
    List<Item>? equipped,
  }) {
    return Player(
      name: name ?? this.name,
      stageIndex: stageIndex ?? this.stageIndex,
      stats: stats ?? this.stats,
      xp: xp ?? this.xp,
      lifespanDays: lifespanDays ?? this.lifespanDays,
      inventory: inventory ?? this.inventory,
      equipped: equipped ?? this.equipped,
    );
  }
}
