import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

class MoviesCacheEntry {
  const MoviesCacheEntry({
    required this.movies,
    required this.fetchedAt,
    required this.currentPage,
    required this.totalPages,
  });

  final List<MovieModel> movies;
  final DateTime fetchedAt;
  final int currentPage;
  final int totalPages;
}

class MoviesLocalDataSource {
  static const _boxName = 'movies_cache_box';
  static const _moviesPrefix = 'movies';
  static const _fetchedAtPrefix = 'fetched_at';
  static const _currentPagePrefix = 'current_page';
  static const _totalPagesPrefix = 'total_pages';

  Future<Box<dynamic>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }

    return Hive.openBox<dynamic>(_boxName);
  }

  Future<MoviesCacheEntry?> readMovies(MovieCategory category) async {
    try {
      final box = await _box;
      final source = box.get(_moviesKey(category));
      final fetchedAtSource = box.get(_fetchedAtKey(category));
      final currentPageSource = box.get(_currentPageKey(category));
      final totalPagesSource = box.get(_totalPagesKey(category));

      if (source is! List) return null;

      final movies = source
          .whereType<Map>()
          .map(MovieModel.fromJson)
          .where((movie) => movie.id != 0)
          .toList(growable: false);

      if (movies.isEmpty) return null;

      final fetchedAt = fetchedAtSource is String
          ? DateTime.tryParse(fetchedAtSource)
          : null;

      return MoviesCacheEntry(
        movies: movies,
        fetchedAt:
            fetchedAt ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
        currentPage: currentPageSource is int ? currentPageSource : 1,
        totalPages: totalPagesSource is int ? totalPagesSource : 1,
      );
    } catch (_) {
      throw CacheException('No fue posible leer películas locales.');
    }
  }

  Future<void> saveMovies(
    MovieCategory category,
    List<MovieModel> movies, {
    required int currentPage,
    required int totalPages,
    bool append = false,
  }) async {
    try {
      final uniqueMovies = <int, MovieModel>{};
      if (append) {
        final cachedEntry = await readMovies(category);
        for (final movie in cachedEntry?.movies ?? const <MovieModel>[]) {
          uniqueMovies[movie.id] = movie;
        }
      }

      for (final movie in movies) {
        uniqueMovies[movie.id] = movie;
      }

      final box = await _box;
      await box.put(
        _moviesKey(category),
        uniqueMovies.values
            .map((movie) => movie.toJson())
            .toList(growable: false),
      );
      await box.put(
        _fetchedAtKey(category),
        DateTime.now().toUtc().toIso8601String(),
      );
      await box.put(_currentPageKey(category), currentPage);
      await box.put(_totalPagesKey(category), totalPages);
    } catch (_) {
      throw CacheException('No fue posible guardar películas locales.');
    }
  }

  String _moviesKey(MovieCategory category) =>
      '$_moviesPrefix.${category.cacheKey}';
  String _fetchedAtKey(MovieCategory category) =>
      '$_fetchedAtPrefix.${category.cacheKey}';
  String _currentPageKey(MovieCategory category) =>
      '$_currentPagePrefix.${category.cacheKey}';
  String _totalPagesKey(MovieCategory category) =>
      '$_totalPagesPrefix.${category.cacheKey}';
}
