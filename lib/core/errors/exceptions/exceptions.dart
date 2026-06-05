import 'package:movie_vault/core/errors/exceptions/exception.dart';

/// Thrown when network request fails
class NetworkException extends AppException {
  NetworkException([super.message = "Error de red"]);
}

/// Thrown when backend returns an error
class ServerException extends AppException {
  ServerException([super.message = "Error del servidor"]);
}

/// Thrown when backend reports a validation issue.
class ValidationException extends AppException {
  ValidationException([super.message = "Datos inválidos"]);
}

/// Thrown when backend rejects credentials or the current session.
class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = "Credenciales inválidas"]);
}

/// Thrown when backend reports a resource conflict.
class ConflictException extends AppException {
  ConflictException([super.message = "Conflicto al procesar la solicitud"]);
}

/// Thrown when JSON parsing fails
class ParsingException extends AppException {
  ParsingException([super.message = "Error al parsear datos"]);
}

/// Thrown when backend reports that a cached resource has not changed.
class NotModifiedException extends AppException {
  NotModifiedException([super.message = 'Recurso no modificado']);
}

/// Thrown when local cached data is required but unavailable.
class CacheException extends AppException {
  CacheException([super.message = 'No hay datos locales disponibles']);
}
