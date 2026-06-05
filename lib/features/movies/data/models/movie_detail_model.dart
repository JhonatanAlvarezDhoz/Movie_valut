import 'package:movie_vault/features/movies/data/models/cast_member_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.movie,
    required super.genres,
    required super.cast,
  });

  factory MovieDetailModel.fromJson(
    Map<dynamic, dynamic> json, {
    required Movie fallbackMovie,
  }) {
    final genresSource = json['genres'];
    final creditsSource = json['credits'];
    final castSource = creditsSource is Map ? creditsSource['cast'] : null;

    return MovieDetailModel(
      movie: MovieModel.fromJson({
        ...MovieModel.fromEntity(fallbackMovie).toJson(),
        ...json,
      }, categoryLabel: fallbackMovie.categoryLabel),
      genres: genresSource is List
          ? genresSource
                .whereType<Map<dynamic, dynamic>>()
                .map((genre) => genre['name'] as String? ?? '')
                .where((name) => name.isNotEmpty)
                .toList(growable: false)
          : const [],
      cast: castSource is List
          ? castSource
                .whereType<Map<dynamic, dynamic>>()
                .map(CastMemberModel.fromJson)
                .where((member) => member.id != 0)
                .take(10)
                .toList(growable: false)
          : const [],
    );
  }
}
