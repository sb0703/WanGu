import 'stats.dart';

class Enemy {
  const Enemy({
    required this.id,
    required this.name,
    required this.description,
    required this.dangerLevel,
    required this.stats,
    required this.loot,
    this.xpReward = 12,
  });

  final String id;
  final String name;
  final String description; // Contains habitat and traits
  final int dangerLevel; // 1-10 scale
  final Stats stats;
  final List<String> loot; // item ids
  final int xpReward;
}
