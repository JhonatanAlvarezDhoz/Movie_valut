import 'package:movie_vault/features/movies/domain/entities/cast_member.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';

/// Complete movie information used by the detail screen.
///
/// It composes the summary movie plus optional TMDB detail data such as genres
/// and cast. If detail loading fails offline, the summary movie can still be
/// shown safely.
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
