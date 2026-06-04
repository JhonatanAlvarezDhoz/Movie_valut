import 'package:movie_valut/core/constants/enums/log_levels.dart';
import 'package:movie_valut/core/logger/log_event.dart';
import 'package:flutter/foundation.dart';

/// Main logger class
class AppLogger {
  void log(LogEvent event) {
    final logMessage =
        "[${event.level.name.toUpperCase()}] ${event.timestamp} - ${event.message}";

    debugPrint(logMessage);

    if (event.error != null) {
      debugPrint(event.error.toString());
    }

    if (event.stackTrace != null) {
      debugPrint(event.stackTrace.toString());
    }
  }

  void debug(String message) {
    log(LogEvent(level: LogLevel.debug, message: message));
  }

  void info(String message) {
    log(LogEvent(level: LogLevel.info, message: message));
  }

  void warning(String message) {
    log(LogEvent(level: LogLevel.warning, message: message));
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    log(
      LogEvent(
        level: LogLevel.error,
        message: message,
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }
}
