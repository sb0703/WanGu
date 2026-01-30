/// 世界时钟模型
class WorldClock {
  const WorldClock({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
  });

  final int year; // 年
  final int month; // 月 (1-12)
  final int day; // 日 (1-30)
  final int hour; // 时 (0-23)

  /// 时间流逝 (按天)
  WorldClock tickDays(num days) {
    // 如果是小数，转换为小时计算以保证精度
    int hoursToAdd = (days * 24).round();
    return tickHours(hoursToAdd);
  }

  /// 时间流逝 (按小时)
  WorldClock tickHours(int hours) {
    int newHour = hour + hours;
    int daysToAdd = 0;
    while (newHour >= 24) {
      newHour -= 24;
      daysToAdd++;
    }

    int newDay = day + daysToAdd;
    int newMonth = month;
    int newYear = year;
    while (newDay > 30) {
      newDay -= 30;
      newMonth += 1;
      if (newMonth > 12) {
        newMonth = 1;
        newYear += 1;
      }
    }

    return WorldClock(
      year: newYear,
      month: newMonth,
      day: newDay,
      hour: newHour,
    );
  }

  WorldClock copyWith({int? year, int? month, int? day, int? hour}) {
    return WorldClock(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
    );
  }

  /// 简短格式化文本
  String shortLabel() => '$year/$month/$day';
}
