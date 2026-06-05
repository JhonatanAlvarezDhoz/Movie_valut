import 'package:movie_vault/core/database/cache_refresh_policy.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';
import 'package:movie_vault/features/movies/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl({
    required MoviesRemoteDataSource remoteDataSource,
    required MoviesLocalDataSource localDataSource,
    required CacheRefreshPolicy cacheRefreshPolicy,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _cacheRefreshPolicy = cacheRefreshPolicy;

  final MoviesRemoteDataSource _remoteDataSource;
  final MoviesLocalDataSource _localDataSource;
  final CacheRefreshPolicy _cacheRefreshPolicy;

  @override
  Future<MoviePage> getMovies(
    MovieCategory category, {
    bool forceRefresh = false,
    int page = 1,
  }) async {
    final cachedEntry = await _readCacheSafely(category);
    final hasFreshCache =
        cachedEntry != null &&
        !_cacheRefreshPolicy.shouldRefresh(cachedEntry.fetchedAt);

    if (page == 1 && !forceRefresh && hasFreshCache) {
      return _cacheEntryToMoviePage(cachedEntry);
    }

    try {
      final remotePage = await _remoteDataSource.getMovies(
        category,
        page: page,
      );
      await _saveCacheSafely(category, remotePage, append: page > 1);
      return remotePage;
    } on NetworkException {
      if (page == 1 && cachedEntry != null) {
        return _cacheEntryToMoviePage(cachedEntry);
      }
      rethrow;
    }
  }

  @override
  Future<MovieDetail> getMovieDetail(Movie movie) async {
    try {
      return await _remoteDataSource.getMovieDetail(movie);
    } on NetworkException {
      return MovieDetail(movie: movie, genres: const [], cast: const []);
    }
  }

  MoviePage _cacheEntryToMoviePage(MoviesCacheEntry entry) {
    return MoviePage(
      movies: entry.movies,
      currentPage: entry.currentPage,
      totalPages: entry.totalPages,
    );
  }

  Future<MoviesCacheEntry?> _readCacheSafely(MovieCategory category) async {
    try {
      return await _localDataSource.readMovies(category);
    } on CacheException {
      return null;
    }
  }

  Future<void> _saveCacheSafely(
    MovieCategory category,
    MoviePage remotePage, {
    required bool append,
  }) async {
    try {
      await _localDataSource.saveMovies(
        category,
        remotePage.movies.map(MovieModel.fromEntity).toList(growable: false),
        currentPage: remotePage.currentPage,
        totalPages: remotePage.totalPages,
        append: append,
      );
    } on CacheException {
      // Remote data is still valid; cache failure should not block the UI.
    }
  }
}
