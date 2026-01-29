class WorldClock {
  const WorldClock({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  WorldClock tickDays(int days) {
    int newDay = day + days;
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

    return WorldClock(year: newYear, month: newMonth, day: newDay);
  }

  String shortLabel() => '$year/$month/$day';
}
