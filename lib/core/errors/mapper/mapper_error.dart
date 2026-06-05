import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/errors/failures/failure.dart';
import 'package:movie_vault/core/errors/failures/failures.dart';

/// Maps Exceptions (infra layer) to Failures (domain/UI layer)
class ExceptionMapper {
  static Failure map(Exception e) {
    if (e is NetworkException) {
      return NetworkFailure(e.message);
    } else if (e is ServerException) {
      return ServerFailure(e.message);
    } else if (e is ValidationException) {
      return ValidationFailure(e.message);
    } else if (e is UnauthorizedException) {
      return UnauthorizedFailure(e.message);
    } else if (e is ConflictException) {
      return ConflictFailure(e.message);
    } else if (e is ParsingException) {
      return ServerFailure(e.message);
    } else if (e is NotModifiedException) {
      return CacheFailure(e.message);
    } else if (e is CacheException) {
      return CacheFailure(e.message);
    } else {
      return const UnknownFailure();
    }
  }
}
