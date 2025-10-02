import '../models/pomodoro_session.dart';

/// Базовое состояние для UI
abstract class UiState<T> {
  const UiState();
}

/// Состояние загрузки
class LoadingState<T> extends UiState<T> {
  const LoadingState();
}

/// Состояние с данными
class DataState<T> extends UiState<T> {
  final T data;
  const DataState(this.data);
}

/// Состояние ошибки
class ErrorState<T> extends UiState<T> {
  final String message;
  final Exception? exception;
  
  const ErrorState(this.message, {this.exception});
}

/// Пустое состояние (начальное)
class EmptyState<T> extends UiState<T> {
  const EmptyState();
}

/// Конкретные состояния для Pomodoro
typedef PomodoroSessionState = UiState<PomodoroSession>;
typedef PomodoroSessionListState = UiState<List<PomodoroSession>>;