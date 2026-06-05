import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';

class MoviePageModel extends MoviePage {
  const MoviePageModel({
    required super.movies,
    required super.currentPage,
    required super.totalPages,
  });

  factory MoviePageModel.fromJson(
    Map<String, dynamic> json, {
    required String categoryLabel,
  }) {
    final results = json['results'];

    return MoviePageModel(
      movies: results is List
          ? results
                .whereType<Map<dynamic, dynamic>>()
                .map(
                  (movieJson) => MovieModel.fromJson(
                    movieJson,
                    categoryLabel: categoryLabel,
                  ),
                )
                .where((movie) => movie.id != 0)
                .toList(growable: false)
          : const [],
      currentPage: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
    );
  }
}
