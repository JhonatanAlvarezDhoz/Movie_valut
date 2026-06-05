import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_page.dart';
import 'package:movie_vault/features/movies/domain/repositories/movies_repository.dart';

/// Loads one paginated movie category and exposes controlled [Result] output.
class GetMoviesUseCase {
  const GetMoviesUseCase(this._repository);

  final MoviesRepository _repository;

  Future<Result<MoviePage>> call(
    MovieCategory category, {
    bool forceRefresh = false,
    int page = 1,
  }) async {
    try {
      final moviesPage = await _repository.getMovies(
        category,
        forceRefresh: forceRefresh,
        page: page,
      );
      return ResultSuccess(moviesPage);
    } on Exception catch (error) {
      return ResultFailure(ExceptionMapper.map(error));
    } catch (_) {
      return const ResultFailure(UnknownFailure());
    }
  }
}
