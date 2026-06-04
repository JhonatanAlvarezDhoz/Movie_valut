import 'package:movie_vault/core/errors/failures/failure.dart';
import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';
import 'package:movie_vault/core/logger/logger.dart';

/// Centralized error handler
class ErrorHandler {
  final AppLogger logger;

  ErrorHandler(this.logger);

  /// Handles any error and converts it into a Failure
  Failure handle(Object error, StackTrace stack) {
    logger.error("Unhandled error", error: error, stackTrace: stack);

    if (error is Exception) {
      return ExceptionMapper.map(error);
    }

    return const UnknownFailure();
  }
}
