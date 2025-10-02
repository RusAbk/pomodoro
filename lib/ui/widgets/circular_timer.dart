import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/design_system.dart';
import '../../models/pomodoro_session.dart';
import '../../core/extensions.dart';

class CircularTimer extends StatefulWidget {
  final double progress;
  final Duration remainingTime;
  final PomodoroSessionType? sessionType;
  final bool isRunning;
  final double size;

  const CircularTimer({
    super.key,
    required this.progress,
    required this.remainingTime,
    this.sessionType,
    this.isRunning = false,
    this.size = 280.0,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 60),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isRunning) {
      _startAnimations();
    }
  }

  @override
  void didUpdateWidget(CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isRunning && !oldWidget.isRunning) {
      _startAnimations();
    } else if (!widget.isRunning && oldWidget.isRunning) {
      _stopAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _rotationController.stop();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Color _getColorForSessionType(PomodoroSessionType? type) {
    switch (type) {
      case PomodoroSessionType.work:
        return AppColors.primaryColor;
      case PomodoroSessionType.shortBreak:
        return AppColors.successColor;
      case PomodoroSessionType.longBreak:
        return AppColors.accentColor;
      case null:
        return Colors.grey;
    }
  }

  LinearGradient _getGradientForSessionType(PomodoroSessionType? type) {
    switch (type) {
      case PomodoroSessionType.work:
        return AppColors.primaryGradient;
      case PomodoroSessionType.shortBreak:
        return LinearGradient(
          colors: [AppColors.successColor, AppColors.successColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case PomodoroSessionType.longBreak:
        return LinearGradient(
          colors: [AppColors.accentColor, AppColors.accentColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case null:
        return LinearGradient(
          colors: [Colors.grey, Colors.grey.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final sessionColor = _getColorForSessionType(widget.sessionType);
    final gradient = _getGradientForSessionType(widget.sessionType);
    
    return AnimatedBuilder(
      animation: widget.isRunning ? _pulseAnimation : 
          const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isRunning ? _pulseAnimation.value : 1.0,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: sessionColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: sessionColor.withOpacity(0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Фоновый круг
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white,
                        Colors.grey.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),
                
                // Прогресс-бар
                AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: CircularProgressPainter(
                        progress: widget.progress,
                        gradient: gradient,
                        strokeWidth: 8.0,
                        backgroundColor: sessionColor.withOpacity(0.1),
                        rotation: widget.isRunning ? _rotationController.value : 0.0,
                      ),
                    );
                  },
                ),
                
                // Центральное содержимое
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Эмодзи сессии
                    if (widget.sessionType != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        child: Text(
                          widget.sessionType!.typeEmoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    
                    const SizedBox(height: AppSpacing.md),
                    
                    // Время
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: sessionColor,
                        letterSpacing: 2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                      child: Text(_formatTime(widget.remainingTime)),
                    ),
                    
                    const SizedBox(height: AppSpacing.sm),
                    
                    // Тип сессии
                    if (widget.sessionType != null)
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          fontSize: 16,
                          color: sessionColor.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                        child: Text(widget.sessionType!.typeDisplayName),
                      ),
                  ],
                ),
                
                // Декоративные элементы
                ...List.generate(12, (index) {
                  final angle = (index * 30.0) * math.pi / 180.0;
                  final radius = widget.size / 2 - 20;
                  
                  return Positioned(
                    left: widget.size / 2 + math.cos(angle - math.pi / 2) * radius - 2,
                    top: widget.size / 2 + math.sin(angle - math.pi / 2) * radius - 2,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index % 3 == 0 
                            ? sessionColor.withOpacity(0.6)
                            : sessionColor.withOpacity(0.2),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final LinearGradient gradient;
  final double strokeWidth;
  final Color backgroundColor;
  final double rotation;

  CircularProgressPainter({
    required this.progress,
    required this.gradient,
    required this.strokeWidth,
    required this.backgroundColor,
    this.rotation = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Фоновый круг
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius, backgroundPaint);
    
    // Прогресс-дуга
    if (progress > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradientPaint = Paint()
        ..shader = gradient.createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      
      final sweepAngle = 2 * math.pi * progress;
      const startAngle = -math.pi / 2; // Начинаем сверху
      
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation * 2 * math.pi);
      canvas.translate(-center.dx, -center.dy);
      
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        gradientPaint,
      );
      
      canvas.restore();
      
      // Светящаяся точка на конце прогресса
      final endAngle = startAngle + sweepAngle + (rotation * 2 * math.pi);
      final endX = center.dx + radius * math.cos(endAngle);
      final endY = center.dy + radius * math.sin(endAngle);
      
      final glowPaint = Paint()
        ..color = gradient.colors.first.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(endX, endY),
        strokeWidth / 2 + 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.rotation != rotation;
  }
}