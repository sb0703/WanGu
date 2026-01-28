import 'stats.dart';

class Enemy {
  const Enemy({
    required this.name,
    required this.stats,
    required this.loot,
    this.xpReward = 12,
  });

  final String name;
  final Stats stats;
  final List<String> loot; // item ids
  final int xpReward;
}
