import 'package:movie_valut/core/errors/failures/failure.dart';

/// Explicit operation result for domain/application boundaries.
///
/// Repositories may still throw infrastructure exceptions internally, but
/// use cases should expose `Result` so presentation consumes controlled
/// failures instead of catching infrastructure details directly.
sealed class Result<T> {
  const Result();
}

final class ResultSuccess<T> extends Result<T> {
  final T value;

  const ResultSuccess(this.value);
}

final class ResultFailure<T> extends Result<T> {
  final Failure failure;

  const ResultFailure(this.failure);
}
