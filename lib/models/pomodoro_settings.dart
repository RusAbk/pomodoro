class PomodoroSettings {
  final Duration workDuration;
  final Duration shortBreakDuration;
  final Duration longBreakDuration;
  final int sessionsUntilLongBreak;
  final bool enableNotifications;
  final bool enableSounds;
  final bool autoStartBreaks;
  final bool autoStartPomodoros;
  final double volume;

  const PomodoroSettings({
    this.workDuration = const Duration(minutes: 25),
    this.shortBreakDuration = const Duration(minutes: 5),
    this.longBreakDuration = const Duration(minutes: 15),
    this.sessionsUntilLongBreak = 4,
    this.enableNotifications = true,
    this.enableSounds = true,
    this.autoStartBreaks = false,
    this.autoStartPomodoros = false,
    this.volume = 0.8,
  });

  PomodoroSettings copyWith({
    Duration? workDuration,
    Duration? shortBreakDuration,
    Duration? longBreakDuration,
    int? sessionsUntilLongBreak,
    bool? enableNotifications,
    bool? enableSounds,
    bool? autoStartBreaks,
    bool? autoStartPomodoros,
    double? volume,
  }) {
    return PomodoroSettings(
      workDuration: workDuration ?? this.workDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsUntilLongBreak: sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      enableSounds: enableSounds ?? this.enableSounds,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
      volume: volume ?? this.volume,
    );
  }

  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      workDuration: Duration(minutes: json['workDuration'] as int? ?? 25),
      shortBreakDuration: Duration(minutes: json['shortBreakDuration'] as int? ?? 5),
      longBreakDuration: Duration(minutes: json['longBreakDuration'] as int? ?? 15),
      sessionsUntilLongBreak: json['sessionsUntilLongBreak'] as int? ?? 4,
      enableNotifications: json['enableNotifications'] as bool? ?? true,
      enableSounds: json['enableSounds'] as bool? ?? true,
      autoStartBreaks: json['autoStartBreaks'] as bool? ?? false,
      autoStartPomodoros: json['autoStartPomodoros'] as bool? ?? false,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.8,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDuration': workDuration.inMinutes,
      'shortBreakDuration': shortBreakDuration.inMinutes,
      'longBreakDuration': longBreakDuration.inMinutes,
      'sessionsUntilLongBreak': sessionsUntilLongBreak,
      'enableNotifications': enableNotifications,
      'enableSounds': enableSounds,
      'autoStartBreaks': autoStartBreaks,
      'autoStartPomodoros': autoStartPomodoros,
      'volume': volume,
    };
  }

  @override
  String toString() {
    return 'PomodoroSettings{work: ${workDuration.inMinutes}min, shortBreak: ${shortBreakDuration.inMinutes}min, longBreak: ${longBreakDuration.inMinutes}min}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PomodoroSettings &&
          runtimeType == other.runtimeType &&
          workDuration == other.workDuration &&
          shortBreakDuration == other.shortBreakDuration &&
          longBreakDuration == other.longBreakDuration &&
          sessionsUntilLongBreak == other.sessionsUntilLongBreak &&
          enableNotifications == other.enableNotifications &&
          enableSounds == other.enableSounds &&
          autoStartBreaks == other.autoStartBreaks &&
          autoStartPomodoros == other.autoStartPomodoros &&
          volume == other.volume;

  @override
  int get hashCode => Object.hash(
      workDuration,
      shortBreakDuration,
      longBreakDuration,
      sessionsUntilLongBreak,
      enableNotifications,
      enableSounds,
      autoStartBreaks,
      autoStartPomodoros,
      volume,
  );
}