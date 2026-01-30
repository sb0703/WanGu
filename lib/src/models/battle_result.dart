/// 战斗结算结果
class BattleResult {
  const BattleResult({
    required this.victory,
    required this.playerHp,
    required this.enemyHp,
    required this.xpGained,
    required this.playerSpirit,
    this.lootedItemId,
  });

  final bool victory; // 是否胜利
  final int playerHp; // 剩余气血
  final int enemyHp; // 敌人剩余气血
  final int xpGained; // 获得修为
  final int playerSpirit; // 剩余灵力
  final String? lootedItemId; // 掉落物品ID
}
