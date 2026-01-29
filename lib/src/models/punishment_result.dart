import 'player.dart';

class PunishmentResult {
  final Player player;
  final String message;
  final String logMessage;
  final int daysPassed;
  final bool teleportToDanger;
  final bool spawnNemesis;

  const PunishmentResult({
    required this.player,
    required this.message,
    required this.logMessage,
    this.daysPassed = 0,
    this.teleportToDanger = false,
    this.spawnNemesis = false,
  });
}
