import 'package:dio/dio.dart';
import 'package:movie_vault/core/config/app_config.dart';
import 'package:movie_vault/core/constants/keys/network_header_keys.dart';

/// Adds TMDB authentication to outgoing requests.
///
/// TMDB uses an app-level bearer token/API key from `.env`. This is not the
/// Firebase user session; user authentication stays in the auth feature.
class TmdbAuthInterceptor extends Interceptor {
  const TmdbAuthInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = AppConfig.tmdbAccessToken.trim();
    final apiKey = AppConfig.tmdbApiKey.trim();

    if (accessToken.isNotEmpty) {
      options.headers[NetworkHeaderKeys.authorization] =
          '${NetworkHeaderKeys.bearerPrefix} $accessToken';
    } else if (apiKey.isNotEmpty) {
      options.queryParameters.putIfAbsent('api_key', () => apiKey);
    }

    handler.next(options);
  }
}
