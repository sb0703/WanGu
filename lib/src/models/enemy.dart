import 'stats.dart';

/// 敌人模型
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

  final String id; // ID
  final String name; // 名称
  final String description; // 描述 (包含栖息地和特征)
  final int dangerLevel; // 危险等级 (1-10)
  final Stats stats; // 属性
  final List<String> loot; // 掉落物品ID列表
  final int xpReward; // 击败获得的修为奖励
}
