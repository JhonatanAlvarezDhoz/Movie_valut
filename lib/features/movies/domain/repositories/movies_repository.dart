import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';

/// Contract used by movie use cases.
///
/// Implementations decide when to use TMDB, Hive cache, or offline fallback.
/// Domain consumers only receive clean entities and never API/cache models.
abstract interface class MoviesRepository {
  /// Returns one page of movies for the requested TMDB category.
  Future<MoviePage> getMovies(
    MovieCategory category, {
    bool forceRefresh = false,
    int page = 1,
  });

  /// Returns detailed information for one movie, including genres and cast.
  Future<MovieDetail> getMovieDetail(Movie movie);
}
