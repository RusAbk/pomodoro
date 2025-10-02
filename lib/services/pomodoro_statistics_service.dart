import 'package:flutter/foundation.dart';
import '../models/pomodoro_session.dart';
import '../models/pomodoro_statistics.dart';

class PomodoroStatisticsService extends ChangeNotifier {
  PomodoroStatistics _statistics = const PomodoroStatistics();
  
  PomodoroStatistics get statistics => _statistics;

  /// Добавляет завершенную сессию в статистику
  void addCompletedSession({
    required PomodoroSessionType sessionType,
    required Duration sessionDuration,
    DateTime? sessionDate,
  }) {
    _statistics = _statistics.addCompletedSession(
      sessionType: sessionType,
      sessionDuration: sessionDuration,
      sessionDate: sessionDate ?? DateTime.now(),
    );
    notifyListeners();
    _saveStatistics();
  }

  /// Получает статистику за текущую неделю
  Map<DateTime, int> getWeeklyStats() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStats = <DateTime, int>{};
    
    for (int i = 0; i < 7; i++) {
      final day = DateTime(weekStart.year, weekStart.month, weekStart.day + i);
      weekStats[day] = _statistics.dailyStats[day] ?? 0;
    }
    
    return weekStats;
  }

  /// Получает статистику за текущий месяц
  Map<DateTime, int> getMonthlyStats() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final monthStats = <DateTime, int>{};
    
    for (int i = 0; i < monthEnd.day; i++) {
      final day = DateTime(monthStart.year, monthStart.month, monthStart.day + i);
      monthStats[day] = _statistics.dailyStats[day] ?? 0;
    }
    
    return monthStats;
  }

  /// Получает среднее количество сессий в день за последние 30 дней
  double getAverageSessionsPerDay() {
    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));
    
    int totalSessions = 0;
    int daysWithData = 0;
    
    for (final entry in _statistics.dailyStats.entries) {
      if (entry.key.isAfter(thirtyDaysAgo) && entry.key.isBefore(now)) {
        totalSessions += entry.value;
        if (entry.value > 0) daysWithData++;
      }
    }
    
    return daysWithData > 0 ? totalSessions / daysWithData : 0.0;
  }

  /// Получает лучшую неделю (с максимальным количеством сессий)
  int getBestWeekSessions() {
    final now = DateTime.now();
    int maxWeekSessions = 0;
    
    // Проверяем последние 12 недель
    for (int weekOffset = 0; weekOffset < 12; weekOffset++) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (weekOffset * 7)));
      int weekSessions = 0;
      
      for (int i = 0; i < 7; i++) {
        final day = DateTime(weekStart.year, weekStart.month, weekStart.day + i);
        weekSessions += _statistics.dailyStats[day] ?? 0;
      }
      
      if (weekSessions > maxWeekSessions) {
        maxWeekSessions = weekSessions;
      }
    }
    
    return maxWeekSessions;
  }

  /// Получает процент выполнения целей (например, 8 помидоров в день)
  double getGoalCompletionRate({int dailyGoal = 8}) {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    final todaySessions = _statistics.dailyStats[todayKey] ?? 0;
    
    return (todaySessions / dailyGoal).clamp(0.0, 1.0);
  }

  /// Получает количество активных дней в месяце
  int getActiveDaysInMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    
    int activeDays = 0;
    
    for (final entry in _statistics.dailyStats.entries) {
      if (entry.key.isAfter(monthStart.subtract(const Duration(days: 1))) &&
          entry.key.isBefore(monthEnd.add(const Duration(days: 1))) &&
          entry.value > 0) {
        activeDays++;
      }
    }
    
    return activeDays;
  }

  /// Сбрасывает всю статистику
  void resetStatistics() {
    _statistics = const PomodoroStatistics();
    notifyListeners();
    _saveStatistics();
  }

  /// Загружает статистику (заглушка для будущей реализации)
  Future<void> loadStatistics() async {
    try {
      // TODO: Implement with SharedPreferences or local database
      if (kDebugMode) {
        print('Statistics loaded: $_statistics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading statistics: $e');
      }
    }
  }

  /// Сохраняет статистику (заглушка для будущей реализации)
  void _saveStatistics() {
    try {
      // TODO: Implement with SharedPreferences or local database
      if (kDebugMode) {
        print('Statistics saved: $_statistics');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving statistics: $e');
      }
    }
  }

  /// Экспортирует статистику в формате CSV (для будущей реализации)
  String exportToCsv() {
    final buffer = StringBuffer();
    buffer.writeln('Date,Sessions,Type');
    
    for (final entry in _statistics.dailyStats.entries) {
      buffer.writeln('${entry.key.toIso8601String().split('T')[0]},${entry.value},daily');
    }
    
    return buffer.toString();
  }

  /// Получает мотивационное сообщение на основе статистики
  String getMotivationalMessage() {
    final streak = _statistics.currentStreak;
    final todaySessions = _statistics.todaysCompletedSessions;
    
    if (streak == 0 && todaySessions == 0) {
      return "🍅 Начните свой первый помидор сегодня!";
    } else if (streak == 1) {
      return "🔥 Отличное начало! Продолжайте завтра!";
    } else if (streak < 7) {
      return "💪 Серия $streak дней! Вы на правильном пути!";
    } else if (streak < 30) {
      return "🏆 Невероятная серия $streak дней! Вы - мастер продуктивности!";
    } else {
      return "🌟 Легенда! $streak дней подряд! Вы вдохновляете других!";
    }
  }
}