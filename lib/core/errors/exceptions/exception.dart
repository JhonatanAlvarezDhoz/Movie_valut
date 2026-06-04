/// Base exception for infrastructure layer
class AppException implements Exception {
  final String message;
  AppException(this.message);
}
