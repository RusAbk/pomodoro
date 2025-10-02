import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/pomodoro_session.dart';
import '../models/pomodoro_settings.dart';

class PomodoroTimerService extends ChangeNotifier {
  Timer? _timer;
  PomodoroSession? _currentSession;
  Duration _remainingTime = Duration.zero;
  int _completedWorkSessions = 0;
  
  // Callback для уведомления о завершении сессии
  void Function(PomodoroSession)? onSessionCompleted;
  
  // Getters
  PomodoroSession? get currentSession => _currentSession;
  Duration get remainingTime => _remainingTime;
  bool get isRunning => _timer != null && _timer!.isActive;
  bool get isPaused => _currentSession != null && !isRunning;
  bool get isIdle => _currentSession == null;
  double get progress {
    if (_currentSession == null) return 0.0;
    final totalSeconds = _currentSession!.duration.inSeconds;
    final elapsedSeconds = totalSeconds - _remainingTime.inSeconds;
    return totalSeconds > 0 ? elapsedSeconds / totalSeconds : 0.0;
  }
  
  int get completedWorkSessions => _completedWorkSessions;

  /// Создает новую сессию
  void createSession({
    required PomodoroSessionType type,
    required Duration duration,
    String? taskName,
  }) {
    print('Создаю сессию: тип=$type, длительность=${duration.inMinutes}мин');
    
    if (_timer?.isActive == true) {
      _timer!.cancel();
      print('Остановил предыдущий таймер');
    }
    
    _currentSession = PomodoroSession(
      id: DateTime.now().millisecondsSinceEpoch,
      type: type,
      duration: duration,
      startTime: DateTime.now(),
      status: PomodoroStatus.idle,
      taskName: taskName,
    );
    
    _remainingTime = duration;
    print('Сессия создана: $_currentSession');
    print('Оставшееся время: ${_remainingTime.inMinutes}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}');
    
    notifyListeners();
  }

  /// Запускает таймер
  void startTimer() {
    if (_currentSession == null) {
      print('Не могу запустить таймер: нет текущей сессии');
      return;
    }
    
    print('Запускаю таймер для сессии ${_currentSession!.type}');
    
    _currentSession = _currentSession!.copyWith(
      status: PomodoroStatus.running,
      startTime: DateTime.now(),
    );
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        notifyListeners();
      } else {
        _completeSession();
      }
    });
    
    notifyListeners();
  }

  /// Приостанавливает таймер
  void pauseTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
      _currentSession = _currentSession?.copyWith(status: PomodoroStatus.paused);
      notifyListeners();
    }
  }

  /// Останавливает и сбрасывает таймер
  void stopTimer() {
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    
    _currentSession = null;
    _remainingTime = Duration.zero;
    notifyListeners();
  }

  /// Переключает режим на указанный тип
  void switchMode(PomodoroSessionType mode, PomodoroSettings settings) {
    // Останавливаем текущий таймер
    if (_timer?.isActive == true) {
      _timer!.cancel();
    }
    
    // Создаем новую сессию выбранного типа
    final duration = getDurationForSessionType(mode, settings);
    createSession(
      type: mode,
      duration: duration,
    );
    
    notifyListeners();
  }

  /// Переключает на режим работы
  void switchToWork(PomodoroSettings settings) {
    switchMode(PomodoroSessionType.work, settings);
  }

  /// Переключает на короткий перерыв
  void switchToShortBreak(PomodoroSettings settings) {
    switchMode(PomodoroSessionType.shortBreak, settings);
  }

  /// Переключает на длинный перерыв
  void switchToLongBreak(PomodoroSettings settings) {
    switchMode(PomodoroSessionType.longBreak, settings);
  }

  /// Завершает текущую сессию
  void _completeSession() {
    if (_currentSession == null) return;
    
    _timer?.cancel();
    
    final completedSession = _currentSession!.copyWith(
      status: PomodoroStatus.completed,
      endTime: DateTime.now(),
    );
    
    // Увеличиваем счетчик рабочих сессий
    if (completedSession.type == PomodoroSessionType.work) {
      _completedWorkSessions++;
    }
    
    // Уведомляем о завершении сессии
    onSessionCompleted?.call(completedSession);
    
    _currentSession = completedSession;
    notifyListeners();
    
    // Показываем завершенную сессию 3 секунды, затем сбрасываем
    Timer(const Duration(seconds: 3), () {
      if (_currentSession?.status == PomodoroStatus.completed) {
        _currentSession = null;
        _remainingTime = Duration.zero;
        notifyListeners();
      }
    });
  }

  /// Сбрасывает счетчик сессий (например, в начале нового дня)
  void resetWorkSessionsCounter() {
    _completedWorkSessions = 0;
    notifyListeners();
  }

  /// Получает тип следующей сессии согласно Pomodoro технике
  PomodoroSessionType getNextSessionType(PomodoroSettings settings) {
    // Если нет текущей сессии или она не завершена, начинаем с работы
    if (_currentSession == null || _currentSession!.status != PomodoroStatus.completed) {
      return PomodoroSessionType.work;
    }
    
    // Если только что завершили рабочую сессию
    if (_currentSession!.type == PomodoroSessionType.work) {
      // Проверяем, пора ли длинный перерыв
      if (_completedWorkSessions % settings.sessionsUntilLongBreak == 0) {
        return PomodoroSessionType.longBreak;
      } else {
        return PomodoroSessionType.shortBreak;
      }
    } else {
      // После любого перерыва - работа
      return PomodoroSessionType.work;
    }
  }

  /// Создает следующую сессию автоматически
  void startNextSession(PomodoroSettings settings) {
    final nextType = getNextSessionType(settings);
    final duration = getDurationForSessionType(nextType, settings);
    
    createSession(
      type: nextType,
      duration: duration,
    );
    startTimer();
  }

  /// Проверяет, готова ли следующая сессия к запуску
  bool get canStartNextSession => 
      _currentSession?.status == PomodoroStatus.completed || _currentSession == null;

  /// Получает длительность для типа сессии
  Duration getDurationForSessionType(
    PomodoroSessionType type,
    PomodoroSettings settings,
  ) {
    switch (type) {
      case PomodoroSessionType.work:
        return settings.workDuration;
      case PomodoroSessionType.shortBreak:
        return settings.shortBreakDuration;
      case PomodoroSessionType.longBreak:
        return settings.longBreakDuration;
    }
  }

  /// Форматирует время в MM:SS
  String formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}