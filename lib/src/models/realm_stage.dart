/// 修仙境界阶段模型
class RealmStage {
  const RealmStage({
    required this.name,
    required this.maxXp,
    required this.hpBonus,
    required this.attackBonus,
    required this.spiritBonus,
  });

  final String name; // 境界名称 (如: 练气)
  final int maxXp; // 该境界基础修为上限
  final int hpBonus; // 突破增加气血
  final int attackBonus; // 突破增加攻击
  final int spiritBonus; // 突破增加灵力

  /// 境界定义列表
  static const stages = <RealmStage>[
    RealmStage(
      name: '练气',
      maxXp: 200,
      hpBonus: 0,
      attackBonus: 0,
      spiritBonus: 0,
    ),
    RealmStage(
      name: '筑基',
      maxXp: 1000,
      hpBonus: 30,
      attackBonus: 5,
      spiritBonus: 20,
    ),
    RealmStage(
      name: '金丹',
      maxXp: 5000,
      hpBonus: 80,
      attackBonus: 12,
      spiritBonus: 60,
    ),
    RealmStage(
      name: '元婴',
      maxXp: 20000,
      hpBonus: 150,
      attackBonus: 25,
      spiritBonus: 120,
    ),
  ];
}
