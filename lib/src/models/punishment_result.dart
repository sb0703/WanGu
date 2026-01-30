import 'player.dart';

/// 惩罚结算结果
class PunishmentResult {
  final Player player; // 惩罚后的玩家状态
  final String message; // 提示消息
  final String logMessage; // 日志消息
  final int daysPassed; // 经过天数
  final bool teleportToDanger; // 是否传送至危险区域
  final bool spawnNemesis; // 是否生成宿敌

  const PunishmentResult({
    required this.player,
    required this.message,
    required this.logMessage,
    this.daysPassed = 0,
    this.teleportToDanger = false,
    this.spawnNemesis = false,
  });
}
