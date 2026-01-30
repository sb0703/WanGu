/// 游戏日志条目
class LogEntry {
  const LogEntry(this.message, {required this.tick});

  final String message; // 日志内容
  final int tick; // 时间戳 (tick)
}
