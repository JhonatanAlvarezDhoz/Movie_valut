import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';

abstract interface class MoviesRepository {
  Future<MoviePage> getMovies(
    MovieCategory category, {
    bool forceRefresh = false,
    int page = 1,
  });

  Future<MovieDetail> getMovieDetail(Movie movie);
}
