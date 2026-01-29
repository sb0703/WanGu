class WorldClock {
  const WorldClock({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
  });

  final int year;
  final int month;
  final int day;
  final int hour;

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

    return WorldClock(year: newYear, month: newMonth, day: newDay, hour: hour);
  }
  
  WorldClock tickHours(int hours) {
    int newHour = hour + hours;
    int daysToAdd = 0;
    while (newHour >= 24) {
      newHour -= 24;
      daysToAdd++;
    }
    if (daysToAdd > 0) {
      return tickDays(daysToAdd).copyWith(hour: newHour);
    }
    return copyWith(hour: newHour);
  }
  
  WorldClock copyWith({int? year, int? month, int? day, int? hour}) {
    return WorldClock(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      hour: hour ?? this.hour,
    );
  }

  String shortLabel() => '$year/$month/$day';
}
