import 'package:dio/dio.dart';
import 'package:movie_vault/core/constants/keys/network_header_keys.dart';
import 'package:movie_vault/core/logger/logger.dart';

/// Applies cross-cutting request headers.
///
/// This interceptor does not implement ETags. Movie freshness is handled by the
/// movies repository/local datasource using the 12-hour cache policy.
class NetworkHeadersInterceptor extends Interceptor {
  const NetworkHeadersInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _applyDefaultContentType(options);
    _logger.debug('Request ${options.method} ${options.uri.path}');
    handler.next(options);
  }

  /// Adds JSON content type unless a request explicitly opts out or uses form data.
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
