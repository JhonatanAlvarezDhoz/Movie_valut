import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';
import 'package:movie_vault/features/movies/domain/repositories/movies_repository.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movie_detail_use_case.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movies_use_case.dart';

void main() {
  final movie = _movie(id: 42);
  final page = MoviePage(movies: [movie], currentPage: 1, totalPages: 2);
  final detail = MovieDetail(
    movie: movie,
    genres: const ['Drama'],
    cast: const [],
  );

  test(
    'GetMoviesUseCase returns paginated movies and forwards params',
    () async {
      final repository = _FakeMoviesRepository(page: page);
      final useCase = GetMoviesUseCase(repository);

      final result = await useCase(
        MovieCategory.upcoming,
        forceRefresh: true,
        page: 2,
      );

      expect(result, isA<ResultSuccess<MoviePage>>());
      expect((result as ResultSuccess<MoviePage>).value.movies.first.id, 42);
      expect(repository.lastCategory, MovieCategory.upcoming);
      expect(repository.lastForceRefresh, isTrue);
      expect(repository.lastPage, 2);
    },
  );

  test(
    'GetMoviesUseCase maps repository exceptions to ResultFailure',
    () async {
      final useCase = GetMoviesUseCase(
        _FakeMoviesRepository(error: NetworkException('Sin conexión')),
      );

      final result = await useCase(MovieCategory.popular);

      expect(result, isA<ResultFailure<MoviePage>>());
      expect(
        (result as ResultFailure<MoviePage>).failure,
        isA<NetworkFailure>(),
      );
    },
  );

  test('GetMovieDetailUseCase returns movie detail', () async {
    final useCase = GetMovieDetailUseCase(
      _FakeMoviesRepository(detail: detail),
    );

    final result = await useCase(movie);

    expect(result, isA<ResultSuccess<MovieDetail>>());
    expect((result as ResultSuccess<MovieDetail>).value.genres, ['Drama']);
  });
}

Movie _movie({required int id}) {
  return Movie(
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

class _FakeMoviesRepository implements MoviesRepository {
  _FakeMoviesRepository({this.page, this.detail, this.error});

  final MoviePage? page;
  final MovieDetail? detail;
  final Exception? error;

  MovieCategory? lastCategory;
  bool? lastForceRefresh;
  int? lastPage;

  @override
  Future<MoviePage> getMovies(
    MovieCategory category, {
    bool forceRefresh = false,
    int page = 1,
  }) async {
    final failure = error;
    if (failure != null) throw failure;
    lastCategory = category;
    lastForceRefresh = forceRefresh;
    lastPage = page;
    return this.page ??
        MoviePage(movies: [_movie(id: 1)], currentPage: page, totalPages: page);
  }

  @override
  Future<MovieDetail> getMovieDetail(Movie movie) async {
    final failure = error;
    if (failure != null) throw failure;
    return detail ??
        MovieDetail(movie: movie, genres: const [], cast: const []);
  }
}
