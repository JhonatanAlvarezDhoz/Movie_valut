import 'package:dio/dio.dart';
import 'package:movie_valut/core/constants/keys/network_header_keys.dart';
import 'package:movie_valut/core/logger/logger.dart';

/// Interceptor de headers transversales.
///
/// No maneja ETags: para TMDB se usará una política de refresco cada 12 horas
/// coordinada por el repository/local datasource de películas.
class NetworkHeadersInterceptor extends Interceptor {
  final AppLogger _logger;

  const NetworkHeadersInterceptor(this._logger);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _applyDefaultContentType(options);
    _logger.debug('Request ${options.method} ${options.uri.path}');
    handler.next(options);
  }

  void _applyDefaultContentType(RequestOptions options) {
    final shouldSkipDefaultJson =
        options.extra[NetworkRequestKeys.skipDefaultJsonContentType] == true;
    final alreadyHasContentType = options.headers.keys.any(
      (key) => key.toString().toLowerCase() == 'content-type',
    );
    final isMultipartRequest = options.data is FormData;

    if (shouldSkipDefaultJson || alreadyHasContentType || isMultipartRequest) {
      return;
    }

    options.headers[NetworkHeaderKeys.contentType] =
        NetworkHeaderKeys.applicationJsonUtf8;
  }
}
