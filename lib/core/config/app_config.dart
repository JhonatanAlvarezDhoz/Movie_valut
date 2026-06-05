import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centraliza la configuración externa de la app.
///
/// Las pantallas y features no leen `.env` directamente. Si mañana TMDB cambia
/// nombres de variables o pasamos a flavors, el cambio queda encapsulado acá.
abstract final class AppConfig {
  static String get tmdbApiBaseUrl => dotenv.get('apiUrlTMDB', fallback: '');

  static String get tmdbAccessToken =>
      dotenv.get('accessTokenTMDB', fallback: '');

  static String get tmdbApiKey => dotenv.get('keyApiTMDB', fallback: '');

  static String get tmdbImageOriginalBaseUrl =>
      dotenv.get('ImageBaseOriginalUrlTMDB', fallback: '');

  static String get tmdbImageSizedBaseUrl =>
      dotenv.get('ImageBaseUpdateSizeUrlTMDB', fallback: '');

  static const moviesRefreshInterval = Duration(hours: 12);

  static String tmdbImageUrl(String? path, {bool original = false}) {
    final normalizedPath = path?.trim() ?? '';
    if (normalizedPath.isEmpty) return '';

    final baseUrl = original ? tmdbImageOriginalBaseUrl : tmdbImageSizedBaseUrl;
    if (baseUrl.isEmpty) return '';

    final separator = baseUrl.endsWith('/') || normalizedPath.startsWith('/')
        ? ''
        : '/';
    return '$baseUrl$separator$normalizedPath';
  }
}
