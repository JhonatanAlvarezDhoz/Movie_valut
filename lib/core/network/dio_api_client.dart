import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/logger/logger.dart';
import 'package:movie_vault/core/network/api_client.dart';

/// Dio-backed implementation of [ApiClient].
///
/// This class is the transport boundary: it owns retries and maps Dio failures
/// into controlled `AppException` types before errors can reach data sources.
class DioApiClient implements ApiClient {
  DioApiClient(this.dio, this.logger);

  final Dio dio;
  final AppLogger logger;

  /// Retries transient failures while letting client errors fail immediately.
  Future<Response<dynamic>> _retry(
    Future<Response<dynamic>> Function() request, {
    int retries = 3,
  }) async {
    for (var attempt = 0; attempt < retries; attempt++) {
      try {
        return await request();
      } on DioException catch (error) {
        final statusCode = error.response?.statusCode;
        final isClientError =
            statusCode != null && statusCode >= 400 && statusCode < 500;

        if (isClientError || attempt == retries - 1) {
          throw _mapDioException(error);
        }

        await Future<void>.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }

    throw ServerException('No fue posible completar la petición.');
  }

  /// Converts raw Dio failures into the app's controlled exception taxonomy.
  Exception _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == HttpStatus.unauthorized) {
      return UnauthorizedException('Token de TMDB inválido o ausente.');
    }

    if (statusCode != null && statusCode >= 400 && statusCode < 500) {
      return ServerException('TMDB rechazó la solicitud.');
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException('Error del servidor de TMDB.');
    }

    final isNetworkFailure =
        error.response == null ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown;

    if (isNetworkFailure) {
      return NetworkException('Sin conexión. Usando datos locales si existen.');
    }

    return ServerException('No fue posible completar la petición.');
  }

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _retry(() => dio.get(path, queryParameters: query));
    return response.data;
  }

  @override
  Future<dynamic> post(String path, {dynamic data}) async {
    final response = await _retry(() => dio.post(path, data: data));
    return response.data;
  }

  @override
  Future<dynamic> patch(String path, {dynamic data}) async {
    final response = await _retry(() => dio.patch(path, data: data));
    return response.data;
  }

  @override
  Future<dynamic> uploadImage(String path, String filePath) async {
    final file = File(filePath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    final response = await _retry(() => dio.post(path, data: formData));
    return response.data;
  }
}
