import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import '../../models/pomodoro_session.dart';
import '../../services/pomodoro_timer_service.dart';
import '../../services/pomodoro_settings_service.dart';
import '../../services/pomodoro_statistics_service.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/glass_components.dart';
import '../widgets/circular_timer.dart';
import '../widgets/mode_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final PomodoroTimerService _timerService;
  late final PomodoroSettingsService _settingsService;
  late final PomodoroStatisticsService _statisticsService;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _timerService = PomodoroTimerService();
    _settingsService = PomodoroSettingsService();
    _statisticsService = PomodoroStatisticsService();
    
    // Подключаем callback для сбора статистики
    _timerService.onSessionCompleted = (session) {
      _statisticsService.addCompletedSession(
        sessionType: session.type,
        sessionDuration: session.duration,
      );
      
      // Показываем снекбар с поздравлением
      _showSessionCompletedSnackBar(session);
    };
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));
    
    // Запускаем анимацию появления
    _slideController.forward();
    
    // Загружаем настройки и статистику
    _settingsService.loadSettings();
    _statisticsService.loadStatistics();
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _timerService.dispose();
    super.dispose();
  }

  void _startNewSession() {
    print('_startNewSession вызван');
    
    // Если нет текущей сессии, начинаем с рабочей сессии
    PomodoroSessionType sessionType;
    if (_timerService.currentSession == null) {
      sessionType = PomodoroSessionType.work;
      print('Текущей сессии нет, создаю рабочую');
    } else {
      sessionType = _timerService.getNextSessionType(_settingsService.settings);
      print('Определяю следующий тип: $sessionType');
    }
    
    final duration = _timerService.getDurationForSessionType(sessionType, _settingsService.settings);
    print('Длительность сессии: ${duration.inMinutes} минут');
    
    _timerService.createSession(
      type: sessionType,
      duration: duration,
    );
    
    print('Сессия создана, запускаю таймер');
    _timerService.startTimer();
  }

  void _toggleTimer() {
    print('_toggleTimer вызван');
    print('isRunning: ${_timerService.isRunning}');
    print('isPaused: ${_timerService.isPaused}');
    print('currentSession: ${_timerService.currentSession}');
    
    if (_timerService.isRunning) {
      print('Ставлю на паузу');
      _timerService.pauseTimer();
    } else if (_timerService.isPaused) {
      print('Возобновляю работу');
      _timerService.startTimer();
    } else {
      // Если нет текущей сессии, создаем новую
      if (_timerService.currentSession == null) {
        print('Создаю новую сессию');
        _startNewSession();
      } else {
        print('Запускаю существующую сессию');
        // Если сессия есть но не запущена, просто запускаем
        _timerService.startTimer();
      }
    }
  }

  void _stopTimer() {
    _timerService.stopTimer();
  }
  
  Widget _buildModeSelector() {
    return ListenableBuilder(
      listenable: _timerService,
      builder: (context, child) {
        return ModeSelector(
          currentMode: _timerService.currentSession?.type,
          onModeChanged: (mode) {
            _timerService.switchMode(mode, _settingsService.settings);
          },
          isEnabled: !_timerService.isRunning,
        );
      },
    );
  }

  void _showSessionCompletedSnackBar(PomodoroSession session) {
    final message = session.type == PomodoroSessionType.work 
        ? '🎉 Рабочая сессия завершена!'
        : '✨ Перерыв завершен!';
    
    final nextType = _timerService.getNextSessionType(_settingsService.settings);
    final nextMessage = nextType == PomodoroSessionType.work
        ? 'Следующий: Работа'
        : (nextType == PomodoroSessionType.shortBreak 
           ? 'Следующий: Короткий перерыв'
           : 'Следующий: Длинный перерыв');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(nextMessage),
          ],
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Начать следующий',
          onPressed: () {
            _timerService.startNextSession(_settingsService.settings);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Градиентный фон
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.1),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          children: [
            // Красивый AppBar
            GradientAppBar(
              title: 'Pomodoro Timer 🍅',
              actions: [
                IconButton(
                  onPressed: () {
                    // TODO: Открыть настройки
                  },
                  icon: const Icon(Icons.settings_rounded, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: Открыть статистику
                  },
                  icon: const Icon(Icons.analytics_rounded, color: Colors.white),
                ),
              ],
            ),
            
            // Основной контент
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _slideController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Приветственная карточка
                        _buildWelcomeCard(),
                        
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Переключатель режимов
                        _buildModeSelector(),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Круглый таймер
                        _buildTimerSection(),
                        
                        const SizedBox(height: AppSpacing.xl),
                        
                        // Управляющие кнопки
                        _buildControlButtons(),
                        
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Статистика сессий
                        _buildSessionStats(),
                        
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return ListenableBuilder(
      listenable: _statisticsService,
      builder: (context, child) {
        return GlassCard(
          child: Column(
            children: [
              Text(
                '🍅 Pomodoro Technique',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _statisticsService.getMotivationalMessage(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimerSection() {
    return ListenableBuilder(
      listenable: _timerService,
      builder: (context, child) {
        return Column(
          children: [
            // Индикатор текущего режима
            _buildSessionModeIndicator(),
            const SizedBox(height: AppSpacing.lg),
            
            // Круговой таймер
            Center(
              child: CircularTimer(
                progress: _timerService.progress,
                remainingTime: _timerService.remainingTime,
                sessionType: _timerService.currentSession?.type,
                isRunning: _timerService.isRunning,
              ),
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Следующий режим
            _buildNextSessionInfo(),
          ],
        );
      },
    );
  }
  
  Widget _buildSessionModeIndicator() {
    final session = _timerService.currentSession;
    if (session == null) {
      return GlassCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_circle_outline,
              color: AppColors.primaryColor,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Готов к работе',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      );
    }
    
    final (modeText, modeIcon, modeColor) = switch (session.type) {
      PomodoroSessionType.work => ('🍅 Режим работы', Icons.work, AppColors.primaryColor),
      PomodoroSessionType.shortBreak => ('☕ Короткий перерыв', Icons.free_breakfast, AppColors.secondaryColor),
      PomodoroSessionType.longBreak => ('🌴 Длинный перерыв', Icons.beach_access, AppColors.accentColor),
    };
    
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            modeIcon,
            color: modeColor,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            modeText,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: modeColor,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNextSessionInfo() {
    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, child) {
        final nextType = _timerService.getNextSessionType(_settingsService.settings);
        final nextDuration = _timerService.getDurationForSessionType(nextType, _settingsService.settings);
        
        final (nextText, nextIcon) = switch (nextType) {
          PomodoroSessionType.work => ('Работа', Icons.work_outline),
          PomodoroSessionType.shortBreak => ('Короткий перерыв', Icons.free_breakfast_outlined),
          PomodoroSessionType.longBreak => ('Длинный перерыв', Icons.beach_access_outlined),
        };
        
        return GestureDetector(
          onTap: () {
            _timerService.switchMode(nextType, _settingsService.settings);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  nextIcon,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Рекомендуемый: $nextText (${nextDuration.inMinutes} мин)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Icon(
                  Icons.touch_app,
                  size: 14,
                  color: AppColors.primaryColor.withOpacity(0.7),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButtons() {
    return ListenableBuilder(
      listenable: _timerService,
      builder: (context, child) {
        return Column(
          children: [
            // Основные кнопки управления
            Row(
              children: [
                // Кнопка старт/пауза
                Expanded(
                  flex: 2,
                  child: AnimatedGradientButton(
                    text: _timerService.isRunning 
                        ? 'Пауза'
                        : _timerService.isPaused 
                            ? 'Продолжить'
                            : 'Начать',
                    icon: _timerService.isRunning 
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onPressed: _toggleTimer,
                  ),
                ),
                
                const SizedBox(width: AppSpacing.sm),
                
                // Кнопка стоп/сброс
                Expanded(
                  child: AnimatedGradientButton(
                    text: 'Стоп',
                    icon: Icons.stop_rounded,
                    onPressed: _timerService.currentSession != null ? _stopTimer : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildSessionStats() {
    return ListenableBuilder(
      listenable: Listenable.merge([_timerService, _statisticsService]),
      builder: (context, child) {
        return GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📊 Статистика',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Сегодня',
                      '${_statisticsService.statistics.todaysCompletedSessions}',
                      '🎯',
                      AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(
                      'Серия дней',
                      '${_statisticsService.statistics.currentStreak}',
                      '🔥',
                      AppColors.warningColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Всего помидоров',
                      '${_statisticsService.statistics.completedWorkSessions}',
                      '🍅',
                      AppColors.successColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildStatCard(
                      'Время фокуса',
                      '${(_statisticsService.statistics.totalFocusTime.inMinutes / 60).toStringAsFixed(1)}ч',
                      '⏱️',
                      AppColors.accentColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, String emoji, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}