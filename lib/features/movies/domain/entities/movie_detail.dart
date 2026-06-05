import 'package:movie_vault/features/movies/domain/entities/cast_member.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';

class MovieDetail {
  const MovieDetail({
    required this.movie,
    required this.genres,
    required this.cast,
  });

  final Movie movie;
  final List<String> genres;
  final List<CastMember> cast;
}
