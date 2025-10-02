import '../models/pomodoro_session.dart';

extension PomodoroSessionTypeExtension on PomodoroSessionType {
  String get typeDisplayName {
    switch (this) {
      case PomodoroSessionType.work:
        return 'Работа';
      case PomodoroSessionType.shortBreak:
        return 'Короткий перерыв';
      case PomodoroSessionType.longBreak:
        return 'Длинный перерыв';
    }
  }

  String get typeEmoji {
    switch (this) {
      case PomodoroSessionType.work:
        return '🍅';
      case PomodoroSessionType.shortBreak:
        return '☕';
      case PomodoroSessionType.longBreak:
        return '🛌';
    }
  }
}