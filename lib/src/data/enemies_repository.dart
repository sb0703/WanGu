import 'dart:math';

import '../models/enemy.dart';
import '../models/stats.dart';

class EnemiesRepository {
  static final Random _rng = Random();

  static Enemy rollEnemy(int danger) {
    // 简单的敌人池，根据危险度筛选
    final candidates = [
      // 低级怪 (1-3)
      if (danger <= 3) ...[
        Enemy(
          name: '狂暴野猪',
          stats: const Stats(maxHp: 40, hp: 40, maxSpirit: 0, spirit: 0, attack: 10, defense: 3, speed: 5, insight: 0),
          loot: const ['herb'],
          xpReward: 10,
        ),
        Enemy(
          name: '青竹蛇',
          stats: const Stats(maxHp: 30, hp: 30, maxSpirit: 10, spirit: 10, attack: 15, defense: 1, speed: 12, insight: 0),
          loot: const ['herb'],
          xpReward: 12,
        ),
      ],
      // 中级怪 (3-6)
      if (danger >= 3 && danger <= 6) ...[
        Enemy(
          name: '铁背熊',
          stats: const Stats(maxHp: 120, hp: 120, maxSpirit: 0, spirit: 0, attack: 25, defense: 15, speed: 4, insight: 0),
          loot: const ['rusty_sword', 'herb'],
          xpReward: 35,
        ),
        Enemy(
          name: '嗜血蝙蝠',
          stats: const Stats(maxHp: 60, hp: 60, maxSpirit: 20, spirit: 20, attack: 22, defense: 5, speed: 15, insight: 0),
          loot: const [],
          xpReward: 25,
        ),
      ],
      // 高级怪 (6+)
      if (danger >= 6) ...[
        Enemy(
          name: '鬼面蜘蛛',
          stats: const Stats(maxHp: 200, hp: 200, maxSpirit: 50, spirit: 50, attack: 40, defense: 10, speed: 18, insight: 0),
          loot: const ['cloth_robe', 'herb'],
          xpReward: 60,
        ),
        Enemy(
          name: '赤炎虎王',
          stats: const Stats(maxHp: 350, hp: 350, maxSpirit: 100, spirit: 100, attack: 55, defense: 25, speed: 20, insight: 0),
          loot: const ['rusty_sword', 'cloth_robe', 'herb'],
          xpReward: 120,
        ),
      ],
    ];

    if (candidates.isEmpty) {
      // Fallback
      return Enemy(
        name: '野狗',
        stats: const Stats(maxHp: 30, hp: 30, maxSpirit: 0, spirit: 0, attack: 8, defense: 2, speed: 6, insight: 0),
        loot: const [],
        xpReward: 5,
      );
    }

    return candidates[_rng.nextInt(candidates.length)];
  }
}
