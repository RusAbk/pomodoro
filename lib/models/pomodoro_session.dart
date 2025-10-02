enum PomodoroSessionType { work, shortBreak, longBreak }

enum PomodoroStatus { idle, running, paused, completed }

class PomodoroSession {
  final int id;
  final PomodoroSessionType type;
  final Duration duration;
  final DateTime startTime;
  final DateTime? endTime;
  final PomodoroStatus status;
  final String? taskName;

  const PomodoroSession({
    required this.id,
    required this.type,
    required this.duration,
    required this.startTime,
    this.endTime,
    required this.status,
    this.taskName,
  });

  PomodoroSession copyWith({
    int? id,
    PomodoroSessionType? type,
    Duration? duration,
    DateTime? startTime,
    DateTime? endTime,
    PomodoroStatus? status,
    String? taskName,
  }) {
    return PomodoroSession(
      id: id ?? this.id,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      taskName: taskName ?? this.taskName,
    );
  }

  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as int,
      type: PomodoroSessionType.values[json['type'] as int],
      duration: Duration(seconds: json['duration'] as int),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      status: PomodoroStatus.values[json['status'] as int],
      taskName: json['taskName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'duration': duration.inSeconds,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'status': status.index,
      'taskName': taskName,
    };
  }

  String get typeDisplayName {
    switch (type) {
      case PomodoroSessionType.work:
        return 'Работа';
      case PomodoroSessionType.shortBreak:
        return 'Короткий перерыв';
      case PomodoroSessionType.longBreak:
        return 'Длинный перерыв';
    }
  }

  String get typeEmoji {
    switch (type) {
      case PomodoroSessionType.work:
        return '🍅';
      case PomodoroSessionType.shortBreak:
        return '☕';
      case PomodoroSessionType.longBreak:
        return '🛌';
    }
  }

  @override
  String toString() {
    return 'PomodoroSession{id: $id, type: $type, duration: $duration, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}