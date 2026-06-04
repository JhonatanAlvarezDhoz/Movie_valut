import 'package:dio/dio.dart';
import 'package:movie_valut/core/logger/logger.dart';

/// Interceptor for logging HTTP traffic
class LoggingInterceptor extends Interceptor {
  final AppLogger logger;

  LoggingInterceptor(this.logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.info("REQUEST => ${options.method} ${options.uri}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.info(
      "RESPONSE => ${response.statusCode} ${response.requestOptions.uri}",
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.error(
      "ERROR => ${err.requestOptions.uri}",
      error: err,
      stackTrace: err.stackTrace,
    );
    super.onError(err, handler);
  }
}
