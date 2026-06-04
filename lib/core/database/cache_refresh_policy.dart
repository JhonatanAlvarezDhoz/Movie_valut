import 'package:movie_valut/core/config/app_config.dart';

/// Política reutilizable para decidir cuándo refrescar datos cacheados.
///
/// Para TMDB no usaremos ETag. La feature de películas consultará remoto si no
/// hay cache local o si el último fetch exitoso superó este intervalo.
class CacheRefreshPolicy {
  const CacheRefreshPolicy({
    this.refreshInterval = AppConfig.moviesRefreshInterval,
  });

  final Duration refreshInterval;

  bool shouldRefresh(DateTime? lastSuccessfulFetch, {DateTime? now}) {
    if (lastSuccessfulFetch == null) {
      return true;
    }

    final currentTime = now ?? DateTime.now().toUtc();
    return currentTime.difference(lastSuccessfulFetch.toUtc()) >=
        refreshInterval;
  }
}
