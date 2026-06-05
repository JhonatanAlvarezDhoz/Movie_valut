import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/database/cache_refresh_policy.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movie_vault/features/movies/data/models/movie_detail_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_page_model.dart';
import 'package:movie_vault/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

void main() {
  test(
    'repository uses cached first page when fake remote is offline',
    () async {
      final repository = MoviesRepositoryImpl(
        remoteDataSource: _FakeMoviesRemoteDataSource(
          error: NetworkException(),
        ),
        localDataSource: _FakeMoviesLocalDataSource(
          cachedEntry: MoviesCacheEntry(
            movies: [_movie(id: 1)],
            fetchedAt: DateTime.utc(2020),
            currentPage: 1,
            totalPages: 3,
          ),
        ),
        cacheRefreshPolicy: const CacheRefreshPolicy(),
      );

      final page = await repository.getMovies(MovieCategory.popular);

      expect(page.movies.map((movie) => movie.id), [1]);
      expect(page.currentPage, 1);
      expect(page.totalPages, 3);
    },
  );

  test('repository saves remote page through fake local datasource', () async {
    final local = _FakeMoviesLocalDataSource();
    final repository = MoviesRepositoryImpl(
      remoteDataSource: _FakeMoviesRemoteDataSource(
        page: MoviePageModel(
          movies: [_movie(id: 2)],
          currentPage: 2,
          totalPages: 4,
        ),
      ),
      localDataSource: local,
      cacheRefreshPolicy: const CacheRefreshPolicy(),
    );

    final page = await repository.getMovies(MovieCategory.popular, page: 2);

    expect(page.currentPage, 2);
    expect(local.savedMovies.map((movie) => movie.id), [2]);
    expect(local.savedAppend, isTrue);
    expect(local.savedCurrentPage, 2);
    expect(local.savedTotalPages, 4);
  });
}

MovieModel _movie({required int id}) {
  return MovieModel(
    id: id,
    title: 'Movie $id',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    releaseDate: '2026-01-01',
    voteAverage: 8,
    categoryLabel: MovieCategory.popular.label,
  );
}

class _FakeMoviesRemoteDataSource implements MoviesRemoteDataSource {
  const _FakeMoviesRemoteDataSource({this.page, this.error});

  final MoviePageModel? page;
  final Exception? error;

  @override
  Future<MoviePageModel> getMovies(
    MovieCategory category, {
    int page = 1,
  }) async {
    final failure = error;
    if (failure != null) throw failure;
    return this.page ??
        MoviePageModel(
          movies: [_movie(id: 10)],
          currentPage: page,
          totalPages: page,
        );
  }

  @override
  Future<MovieDetailModel> getMovieDetail(Movie movie) {
    throw UnimplementedError();
  }
}

class _FakeMoviesLocalDataSource implements MoviesLocalDataSource {
  _FakeMoviesLocalDataSource({this.cachedEntry});

  final MoviesCacheEntry? cachedEntry;
  List<MovieModel> savedMovies = const [];
  bool? savedAppend;
  int? savedCurrentPage;
  int? savedTotalPages;

  @override
  Future<MoviesCacheEntry?> readMovies(MovieCategory category) async {
    return cachedEntry;
  }

  @override
  Future<void> saveMovies(
    MovieCategory category,
    List<MovieModel> movies, {
    required int currentPage,
    required int totalPages,
    bool append = false,
  }) async {
    savedMovies = movies;
    savedAppend = append;
    savedCurrentPage = currentPage;
    savedTotalPages = totalPages;
  }
}
