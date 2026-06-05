import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/mapper/mapper_error.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';
import 'package:movie_vault/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  const RegisterUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call({
    required String email,
    required String password,
  }) async {
    try {
      final session = await _repository.register(
        email: email,
        password: password,
      );
      return ResultSuccess(session);
    } on Exception catch (error) {
      return ResultFailure(ExceptionMapper.map(error));
    } catch (_) {
      return const ResultFailure(UnknownFailure());
    }
  }
}
