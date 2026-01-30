/// 地图节点模型
class MapNode {
  const MapNode({
    required this.id,
    required this.name,
    required this.description,
    required this.danger,
    this.npcIds = const [],
    this.enemyChance = 0.55,
    this.herbChance = 0.25,
    this.resourceIds = const ['herb'],
  });

  final String id; // ID
  final String name; // 名称
  final String description; // 描述
  final int danger; // 危险等级 (0-10, 越高越危险)
  final List<String> npcIds; // NPC ID列表

  // 事件概率 (理想情况下总和 <= 1.0，或者按顺序处理)
  final double enemyChance; // 遇敌概率
  final double herbChance; // 采药概率

  // 该地图包含的资源
  final List<String> resourceIds; // 资源ID列表
}
