import '../models/enemy.dart';

/// 战斗状态枚举
enum BattleState {
  inProgress, // 进行中
  victory, // 胜利
  defeat, // 失败
  fled, // 逃跑
}

/// 战斗日志条目
class BattleLog {
  final String message; // 日志消息
  final bool isPlayerAction; // 是否为玩家行动
  final int damage; // 造成的伤害
  final bool isCrit; // 是否暴击

  BattleLog(
    this.message, {
    this.isPlayerAction = false,
    this.damage = 0,
    this.isCrit = false,
  });
}

/// 战斗模型
class Battle {
  final Enemy enemy; // 敌人
  int playerHp; // 玩家当前气血
  int playerMaxHp; // 玩家最大气血
  int playerSpirit; // 玩家当前灵力
  int playerMaxSpirit; // 玩家最大灵力
  int enemyHp; // 敌人当前气血
  int enemyMaxHp; // 敌人最大气血

  List<BattleLog> logs = []; // 战斗日志列表
  BattleState state = BattleState.inProgress; // 当前战斗状态
  int turn = 0; // 回合数

  Battle({
    required this.enemy,
    required this.playerHp,
    required this.playerMaxHp,
    required this.playerSpirit,
    required this.playerMaxSpirit,
  }) : enemyHp = enemy.stats.hp,
       enemyMaxHp = enemy.stats.maxHp;

  /// 战斗是否结束
  bool get isOver => state != BattleState.inProgress;
}
