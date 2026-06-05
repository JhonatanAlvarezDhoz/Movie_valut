/// Movie summary used by the home list and as detail fallback data.
///
/// This entity is intentionally framework-free: no Flutter, Dio, Hive or TMDB
/// response types are allowed in domain.
class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.categoryLabel,
  });

  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final String categoryLabel;
}
