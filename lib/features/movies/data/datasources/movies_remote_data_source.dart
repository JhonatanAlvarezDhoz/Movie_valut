import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/network/api_client.dart';
import 'package:movie_vault/core/network/api_response_envelope.dart';
import 'package:movie_vault/features/movies/data/models/movie_detail_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_page_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

/// TMDB remote data source for movie list and detail endpoints.
///
/// It depends on the project [ApiClient] abstraction, never on Dio directly,
/// and converts raw JSON into data models before data reaches repositories.
class MoviesRemoteDataSource {
  const MoviesRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<MoviePageModel> getMovies(
    MovieCategory category, {
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      category.endpoint,
      query: {'language': 'es-ES', 'page': page},
    );

    if (response is! Map<String, dynamic>) {
      throw ParsingException('TMDB devolvió una respuesta inesperada.');
    }

    final envelope = ApiResponseEnvelope.fromJson(response);

    return MoviePageModel.fromJson(
      envelope.toJson(),
      categoryLabel: category.label,
    );
  }

  Future<MovieDetailModel> getMovieDetail(Movie movie) async {
    final response = await _apiClient.get(
      'movie/${movie.id}',
      query: const {'language': 'es-ES', 'append_to_response': 'credits'},
    );

    if (response is! Map<String, dynamic>) {
      throw ParsingException('TMDB devolvió un detalle inesperado.');
    }

    return MovieDetailModel.fromJson(response, fallbackMovie: movie);
  }
}
