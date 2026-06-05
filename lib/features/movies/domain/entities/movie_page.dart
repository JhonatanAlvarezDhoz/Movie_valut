import 'package:movie_vault/features/movies/domain/entities/movie.dart';

class MoviePage {
  const MoviePage({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
  });

  final List<Movie> movies;
  final int currentPage;
  final int totalPages;

  bool get hasMorePages => currentPage < totalPages;
}
