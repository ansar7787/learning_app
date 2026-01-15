class StreakModel {
  final int currentDay;
  final List<StreakDay> days;

  StreakModel({required this.currentDay, required this.days});

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    final currentDay = json['current_day'] ?? 1;
    final List daysList = json['days'] ?? [];
    return StreakModel(
      currentDay: currentDay,
      days: daysList.map((e) => StreakDay.fromJson(e, currentDay)).toList(),
    );
  }
}

class StreakDay {
  final int day;
  final bool completed;
  final bool isToday;

  StreakDay({required this.day, required this.completed, this.isToday = false});

  factory StreakDay.fromJson(dynamic json, int currentDay) {
    if (json is! Map<String, dynamic>) {
      return StreakDay(day: 0, completed: false);
    }

    // Assuming 'day_number' exists based on investigation
    // Fallback to 'id' if day_number is missing
    final d = json['day_number'] ?? json['id'] ?? 0;

    // Logic:
    // isToday if day == currentDay
    // completed if day < currentDay (unless API provides 'is_completed')
    // We'll trust day < currentDay logic primarily for streaks usually

    return StreakDay(
      day: d,
      isToday: d == currentDay,
      completed: d < currentDay,
    );
  }
}
