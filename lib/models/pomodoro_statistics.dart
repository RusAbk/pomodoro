import 'pomodoro_session.dart';

class PomodoroStatistics {
  final int totalSessions;
  final int completedWorkSessions;
  final int completedBreakSessions;
  final Duration totalFocusTime;
  final Duration totalBreakTime;
  final DateTime? lastSessionDate;
  final int currentStreak;
  final int longestStreak;
  final Map<DateTime, int> dailyStats;

  const PomodoroStatistics({
    this.totalSessions = 0,
    this.completedWorkSessions = 0,
    this.completedBreakSessions = 0,
    this.totalFocusTime = Duration.zero,
    this.totalBreakTime = Duration.zero,
    this.lastSessionDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.dailyStats = const {},
  });

  PomodoroStatistics copyWith({
    int? totalSessions,
    int? completedWorkSessions,
    int? completedBreakSessions,
    Duration? totalFocusTime,
    Duration? totalBreakTime,
    DateTime? lastSessionDate,
    int? currentStreak,
    int? longestStreak,
    Map<DateTime, int>? dailyStats,
  }) {
    return PomodoroStatistics(
      totalSessions: totalSessions ?? this.totalSessions,
      completedWorkSessions: completedWorkSessions ?? this.completedWorkSessions,
      completedBreakSessions: completedBreakSessions ?? this.completedBreakSessions,
      totalFocusTime: totalFocusTime ?? this.totalFocusTime,
      totalBreakTime: totalBreakTime ?? this.totalBreakTime,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      dailyStats: dailyStats ?? this.dailyStats,
    );
  }

  PomodoroStatistics addCompletedSession({
    required PomodoroSessionType sessionType,
    required Duration sessionDuration,
    required DateTime sessionDate,
  }) {
    final today = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
    final updatedDailyStats = Map<DateTime, int>.from(dailyStats);
    updatedDailyStats[today] = (updatedDailyStats[today] ?? 0) + 1;

    int newCurrentStreak = currentStreak;
    if (lastSessionDate != null) {
      final lastDay = DateTime(lastSessionDate!.year, lastSessionDate!.month, lastSessionDate!.day);
      final dayDifference = today.difference(lastDay).inDays;
      
      if (dayDifference == 1) {
        // Consecutive day
        newCurrentStreak++;
      } else if (dayDifference > 1) {
        // Streak broken
        newCurrentStreak = 1;
      }
      // Same day, keep current streak
    } else {
      newCurrentStreak = 1;
    }

    return copyWith(
      totalSessions: totalSessions + 1,
      completedWorkSessions: sessionType == PomodoroSessionType.work 
          ? completedWorkSessions + 1 
          : completedWorkSessions,
      completedBreakSessions: sessionType != PomodoroSessionType.work 
          ? completedBreakSessions + 1 
          : completedBreakSessions,
      totalFocusTime: sessionType == PomodoroSessionType.work 
          ? totalFocusTime + sessionDuration 
          : totalFocusTime,
      totalBreakTime: sessionType != PomodoroSessionType.work 
          ? totalBreakTime + sessionDuration 
          : totalBreakTime,
      lastSessionDate: sessionDate,
      currentStreak: newCurrentStreak,
      longestStreak: newCurrentStreak > longestStreak ? newCurrentStreak : longestStreak,
      dailyStats: updatedDailyStats,
    );
  }

  factory PomodoroStatistics.fromJson(Map<String, dynamic> json) {
    final dailyStatsJson = json['dailyStats'] as Map<String, dynamic>? ?? {};
    final dailyStats = <DateTime, int>{};
    
    for (final entry in dailyStatsJson.entries) {
      dailyStats[DateTime.parse(entry.key)] = entry.value as int;
    }

    return PomodoroStatistics(
      totalSessions: json['totalSessions'] as int? ?? 0,
      completedWorkSessions: json['completedWorkSessions'] as int? ?? 0,
      completedBreakSessions: json['completedBreakSessions'] as int? ?? 0,
      totalFocusTime: Duration(seconds: json['totalFocusTime'] as int? ?? 0),
      totalBreakTime: Duration(seconds: json['totalBreakTime'] as int? ?? 0),
      lastSessionDate: json['lastSessionDate'] != null 
          ? DateTime.parse(json['lastSessionDate'] as String) 
          : null,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      dailyStats: dailyStats,
    );
  }

  Map<String, dynamic> toJson() {
    final dailyStatsJson = <String, int>{};
    for (final entry in dailyStats.entries) {
      dailyStatsJson[entry.key.toIso8601String()] = entry.value;
    }

    return {
      'totalSessions': totalSessions,
      'completedWorkSessions': completedWorkSessions,
      'completedBreakSessions': completedBreakSessions,
      'totalFocusTime': totalFocusTime.inSeconds,
      'totalBreakTime': totalBreakTime.inSeconds,
      'lastSessionDate': lastSessionDate?.toIso8601String(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'dailyStats': dailyStatsJson,
    };
  }

  double get completionRate {
    if (totalSessions == 0) return 0.0;
    return (completedWorkSessions + completedBreakSessions) / totalSessions;
  }

  int get todaysCompletedSessions {
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);
    return dailyStats[todayKey] ?? 0;
  }

  @override
  String toString() {
    return 'PomodoroStatistics{total: $totalSessions, completed: $completedWorkSessions, streak: $currentStreak}';
  }
}