class BattleResult {
  const BattleResult({
    required this.victory,
    required this.playerHp,
    required this.enemyHp,
    required this.xpGained,
    required this.playerSpirit,
    this.lootedItemId,
  });

  final bool victory;
  final int playerHp;
  final int enemyHp;
  final int xpGained;
  final int playerSpirit;
  final String? lootedItemId;
}
