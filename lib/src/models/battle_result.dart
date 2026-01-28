class BattleResult {
  const BattleResult({
    required this.victory,
    required this.playerHp,
    required this.enemyHp,
    required this.xpGained,
    this.lootedItemName,
  });

  final bool victory;
  final int playerHp;
  final int enemyHp;
  final int xpGained;
  final String? lootedItemName;
}
