class WorldClock {
  const WorldClock({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
  });

  final int year;
  final int month;
  final int day;
  final int hour;

  WorldClock tickHours(int hours) {
    int newHour = hour + hours;
    int extraDay = newHour ~/ 24;
    newHour %= 24;

    int newDay = day + extraDay;
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

  String shortLabel() => '$year/$month/$day $hour:00';
}
