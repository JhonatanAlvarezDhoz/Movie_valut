import 'package:movie_valut/core/constants/enums/log_levels.dart';

/// Represents a structured log event
class LogEvent {
  final LogLevel level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  LogEvent({
    required this.level,
    required this.message,
    this.error,
    this.stackTrace,
  }) : timestamp = DateTime.now();
}
