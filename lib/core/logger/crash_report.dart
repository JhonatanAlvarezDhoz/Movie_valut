import 'package:movie_valut/core/logger/logger.dart';

/// Stub for crash reporting services (Firebase, Sentry, etc.)
class CrashReporter {
  final AppLogger logger;

  CrashReporter(this.logger);

  void recordError(Object error, StackTrace stack) {
    // Aquí puedes integrar Firebase Crashlytics o Sentry
    logger.error("Crash report enviado", error: error, stackTrace: stack);
  }
}
