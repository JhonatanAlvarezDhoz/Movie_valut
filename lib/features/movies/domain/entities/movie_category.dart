enum MovieCategory {
  popular(label: 'Populares', endpoint: 'movie/popular', cacheKey: 'popular'),
  nowPlaying(
    label: 'En cartelera',
    endpoint: 'movie/now_playing',
    cacheKey: 'now_playing',
  ),
  upcoming(label: 'Próximas', endpoint: 'movie/upcoming', cacheKey: 'upcoming');

  const MovieCategory({
    required this.label,
    required this.endpoint,
    required this.cacheKey,
  });

  final String label;
  final String endpoint;
  final String cacheKey;
}
