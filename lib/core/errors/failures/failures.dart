import 'package:movie_valut/core/errors/failures/failure.dart';

/// Represents connectivity-related issues
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "No hay conexión a internet"]);
}

/// Represents backend/server errors (500, bad responses, etc.)
class ServerFailure extends Failure {
  const ServerFailure([super.message = "Error del servidor"]);
}

/// Represents input or business validation errors
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = "Datos inválidos"]);
}

/// Represents authentication or authorization errors
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "No autorizado"]);
}

/// Represents resource or business state conflicts
class ConflictFailure extends Failure {
  const ConflictFailure([super.message = "Conflicto al procesar la solicitud"]);
}

/// Represents local storage/cache related errors
class CacheFailure extends Failure {
  const CacheFailure([super.message = "Error en almacenamiento local"]);
}

/// Fallback failure for unhandled cases
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = "Error desconocido"]);
}
