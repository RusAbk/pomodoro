import 'package:flutter/foundation.dart';
import '../models/pomodoro_settings.dart';

class PomodoroSettingsService extends ChangeNotifier {
  PomodoroSettings _settings = const PomodoroSettings();
  
  PomodoroSettings get settings => _settings;

  /// Обновляет настройки
  void updateSettings(PomodoroSettings newSettings) {
    _settings = newSettings;
    notifyListeners();
    _saveSettings();
  }

  /// Обновляет продолжительность работы
  void updateWorkDuration(Duration duration) {
    _settings = _settings.copyWith(workDuration: duration);
    notifyListeners();
    _saveSettings();
  }

  /// Обновляет продолжительность короткого перерыва
  void updateShortBreakDuration(Duration duration) {
    _settings = _settings.copyWith(shortBreakDuration: duration);
    notifyListeners();
    _saveSettings();
  }

  /// Обновляет продолжительность длинного перерыва
  void updateLongBreakDuration(Duration duration) {
    _settings = _settings.copyWith(longBreakDuration: duration);
    notifyListeners();
    _saveSettings();
  }

  /// Обновляет количество сессий до длинного перерыва
  void updateSessionsUntilLongBreak(int sessions) {
    _settings = _settings.copyWith(sessionsUntilLongBreak: sessions);
    notifyListeners();
    _saveSettings();
  }

  /// Переключает уведомления
  void toggleNotifications() {
    _settings = _settings.copyWith(enableNotifications: !_settings.enableNotifications);
    notifyListeners();
    _saveSettings();
  }

  /// Переключает звуки
  void toggleSounds() {
    _settings = _settings.copyWith(enableSounds: !_settings.enableSounds);
    notifyListeners();
    _saveSettings();
  }

  /// Переключает автозапуск перерывов
  void toggleAutoStartBreaks() {
    _settings = _settings.copyWith(autoStartBreaks: !_settings.autoStartBreaks);
    notifyListeners();
    _saveSettings();
  }

  /// Переключает автозапуск помодоро
  void toggleAutoStartPomodoros() {
    _settings = _settings.copyWith(autoStartPomodoros: !_settings.autoStartPomodoros);
    notifyListeners();
    _saveSettings();
  }

  /// Обновляет громкость
  void updateVolume(double volume) {
    _settings = _settings.copyWith(volume: volume.clamp(0.0, 1.0));
    notifyListeners();
    _saveSettings();
  }

  /// Сбрасывает настройки к значениям по умолчанию
  void resetToDefaults() {
    _settings = const PomodoroSettings();
    notifyListeners();
    _saveSettings();
  }

  /// Загружает настройки (заглушка для будущей реализации с SharedPreferences)
  Future<void> loadSettings() async {
    try {
      // TODO: Implement with SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // final settingsJson = prefs.getString('pomodoro_settings');
      // if (settingsJson != null) {
      //   final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
      //   _settings = PomodoroSettings.fromJson(settingsMap);
      //   notifyListeners();
      // }
      
      if (kDebugMode) {
        print('Settings loaded: $_settings');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading settings: $e');
      }
    }
  }

  /// Сохраняет настройки (заглушка для будущей реализации с SharedPreferences)
  void _saveSettings() {
    try {
      // TODO: Implement with SharedPreferences
      // final prefs = await SharedPreferences.getInstance();
      // final settingsJson = json.encode(_settings.toJson());
      // await prefs.setString('pomodoro_settings', settingsJson);
      
      if (kDebugMode) {
        print('Settings saved: $_settings');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving settings: $e');
      }
    }
  }

  /// Получает рекомендуемые пресеты настроек
  static List<PomodoroSettings> getPresets() {
    return [
      const PomodoroSettings(), // Классический Pomodoro
      const PomodoroSettings( // Короткие сессии
        workDuration: Duration(minutes: 15),
        shortBreakDuration: Duration(minutes: 3),
        longBreakDuration: Duration(minutes: 10),
      ),
      const PomodoroSettings( // Длинные сессии
        workDuration: Duration(minutes: 45),
        shortBreakDuration: Duration(minutes: 10),
        longBreakDuration: Duration(minutes: 30),
      ),
      const PomodoroSettings( // Ультрамарафон
        workDuration: Duration(minutes: 90),
        shortBreakDuration: Duration(minutes: 20),
        longBreakDuration: Duration(minutes: 45),
        sessionsUntilLongBreak: 2,
      ),
    ];
  }

  /// Получает названия пресетов
  static List<String> getPresetNames() {
    return [
      'Классический (25/5/15)',
      'Короткие сессии (15/3/10)',
      'Длинные сессии (45/10/30)',
      'Ультрамарафон (90/20/45)',
    ];
  }
}