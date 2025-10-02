import 'package:flutter/material.dart';
import '../../core/design_system.dart';
import 'glass_components.dart';
import 'animated_loading.dart';

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Анимированная иконка ошибки
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppColors.errorColor.withOpacity(0.2),
                            AppColors.errorColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.circle),
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: AppColors.errorColor,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              Text(
                'Упс! Что-то пошло не так',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.errorColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.lg),
                AnimatedGradientButton(
                  text: 'Попробовать снова',
                  icon: Icons.refresh_rounded,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyDisplay({
    super.key,
    this.message = 'Нет данных',
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Анимированная иконка
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primaryColor.withOpacity(0.2),
                              AppColors.primaryColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.circle),
                        ),
                        child: Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              Text(
                'Пусто здесь',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              
              if (onAction != null && actionLabel != null) ...[
                const SizedBox(height: AppSpacing.lg),
                AnimatedGradientButton(
                  text: actionLabel!,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class BeautifulLoadingDisplay extends StatelessWidget {
  final String? message;

  const BeautifulLoadingDisplay({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: GlassCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Анимированный градиентный индикатор
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
                child: const PulsingLoader(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              Text(
                message ?? 'Загружаем данные...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppSpacing.md),
              
              AnimatedLoadingDots(
                color: AppColors.primaryColor,
                size: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}