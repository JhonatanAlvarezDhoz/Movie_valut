/// Base class for all failures used in domain/UI layers.
/// Represents a controlled, user-friendly error.
abstract class Failure {
  final String message;
  const Failure(this.message);
}
