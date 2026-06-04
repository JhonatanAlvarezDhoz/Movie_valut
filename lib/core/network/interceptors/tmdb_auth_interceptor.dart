import 'package:dio/dio.dart';
import 'package:movie_vault/core/config/app_config.dart';
import 'package:movie_vault/core/constants/keys/network_header_keys.dart';

/// Agrega la autenticación de TMDB sin filtrar detalles de red a las features.
///
/// TMDB usa bearer token/API key estático desde `.env`; NO es sesión de usuario.
/// La sesión del usuario se manejará aparte con Firebase Auth + SessionStorage.
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
