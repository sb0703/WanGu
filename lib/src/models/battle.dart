import '../models/enemy.dart';

enum BattleState {
  inProgress,
  victory,
  defeat,
  fled,
}

class BattleLog {
  final String message;
  final bool isPlayerAction;
  final int damage;
  final bool isCrit;

  BattleLog(this.message, {this.isPlayerAction = false, this.damage = 0, this.isCrit = false});
}

class Battle {
  final Enemy enemy;
  int playerHp;
  int playerMaxHp;
  int playerSpirit;
  int playerMaxSpirit;
  int enemyHp;
  int enemyMaxHp;
  
  List<BattleLog> logs = [];
  BattleState state = BattleState.inProgress;
  int turn = 0;

  Battle({
    required this.enemy,
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerSpirit,
    required this.playerMaxSpirit,
  }) : enemyHp = enemy.stats.hp, enemyMaxHp = enemy.stats.maxHp;

  bool get isOver => state != BattleState.inProgress;
}
