import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import '../../models/pomodoro_session.dart';

class ModeSelector extends StatelessWidget {
  final PomodoroSessionType? currentMode;
  final Function(PomodoroSessionType) onModeChanged;
  final bool isEnabled;

  const ModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            context,
            PomodoroSessionType.work,
            '🍅\nРабота',
            AppColors.primaryColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildModeButton(
            context,
            PomodoroSessionType.shortBreak,
            '☕\nКорот.',
            AppColors.secondaryColor,
          ),
          const SizedBox(width: AppSpacing.xs),
          _buildModeButton(
            context,
            PomodoroSessionType.longBreak,
            '🌴\nДлинн.',
            AppColors.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton(
    BuildContext context,
    PomodoroSessionType mode,
    String label,
    Color color,
  ) {
    final isSelected = currentMode == mode;
    
    return Expanded(
      child: GestureDetector(
        onTap: isEnabled ? () => onModeChanged(mode) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xs,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected 
                  ? color.withOpacity(0.5)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                  color: isSelected 
                      ? color
                      : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(
                          isEnabled ? 1.0 : 0.5
                        ),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}