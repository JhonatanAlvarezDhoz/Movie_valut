import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  const ResetPasswordUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call(String email) async {
    try {
      await _repository.resetPassword(email);
      return const ResultSuccess(null);
    } on Exception catch (error) {
      return ResultFailure(ExceptionMapper.map(error));
    } catch (_) {
      return const ResultFailure(UnknownFailure());
    }
  }
}
