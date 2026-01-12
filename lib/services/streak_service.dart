import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const String _lastVisitKey = 'last_visit_date';
  static const String _streakCountKey = 'streak_count';

  Future<int> getStreakCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = _formatDate(today);

    final lastVisit = prefs.getString(_lastVisitKey);
    int currentStreak = prefs.getInt(_streakCountKey) ?? 0;

    if (lastVisit == null) {
      // First time user
      currentStreak = 1;
      await prefs.setString(_lastVisitKey, todayString);
      await prefs.setInt(_streakCountKey, currentStreak);
    } else if (lastVisit != todayString) {
      // Check if yesterday
      final lastVisitDate = DateTime.parse(lastVisit);
      final yesterday = today.subtract(Duration(days: 1));

      if (_isSameDay(lastVisitDate, yesterday)) {
        // Consecutive day - increment streak
        currentStreak++;
      } else if (_isSameDay(lastVisitDate, today)) {
        // Same day - no change
      } else {
        // Streak broken - reset to 1
        currentStreak = 1;
      }

      await prefs.setString(_lastVisitKey, todayString);
      await prefs.setInt(_streakCountKey, currentStreak);
    }

    return currentStreak;
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> resetStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastVisitKey);
    await prefs.remove(_streakCountKey);
  }
}
