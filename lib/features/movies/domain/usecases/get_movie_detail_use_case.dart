import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/movies/domain/entities/movie.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_detail.dart';
import 'package:movie_vault/features/movies/domain/repositories/movies_repository.dart';

class GetMovieDetailUseCase {
  const GetMovieDetailUseCase(this._repository);

  final MoviesRepository _repository;

  Future<Result<MovieDetail>> call(Movie movie) async {
    try {
      final detail = await _repository.getMovieDetail(movie);
      return ResultSuccess(detail);
    } on Exception catch (error) {
      return ResultFailure(ExceptionMapper.map(error));
    } catch (_) {
      return const ResultFailure(UnknownFailure());
    }
  }
}
