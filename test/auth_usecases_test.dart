import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/errors/failures/failures.dart';
import 'package:movie_vault/core/errors/result.dart';
import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';
import 'package:movie_vault/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_vault/features/auth/domain/usecases/get_current_session_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/logout_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/register_user_use_case.dart';

void main() {
  const session = AuthSession(userId: 'user-1', email: 'user@test.com');

  test(
    'LoginUserUseCase returns ResultSuccess when repository succeeds',
    () async {
      final useCase = LoginUserUseCase(
        _FakeAuthRepository(loginSession: session),
      );

      final result = await useCase(email: session.email, password: '123456');

      expect(result, isA<ResultSuccess<AuthSession>>());
      expect((result as ResultSuccess<AuthSession>).value, session);
    },
  );

  test(
    'RegisterUserUseCase maps repository exceptions to ResultFailure',
    () async {
      final useCase = RegisterUserUseCase(
        _FakeAuthRepository(registerError: ConflictException('Correo en uso')),
      );

      final result = await useCase(email: session.email, password: '123456');

      expect(result, isA<ResultFailure<AuthSession>>());
      expect(
        (result as ResultFailure<AuthSession>).failure,
        isA<ConflictFailure>(),
      );
    },
  );

  test('LogoutUserUseCase returns ResultSuccess<void>', () async {
    final useCase = LogoutUserUseCase(_FakeAuthRepository());

    final result = await useCase();

    expect(result, isA<ResultSuccess<void>>());
  });

  test(
    'GetCurrentSessionUseCase returns nullable session through Result',
    () async {
      final useCase = GetCurrentSessionUseCase(
        _FakeAuthRepository(currentSessionValue: session),
      );

      final result = await useCase();

      expect(result, isA<ResultSuccess<AuthSession?>>());
      expect((result as ResultSuccess<AuthSession?>).value, session);
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    this.loginSession,
    this.currentSessionValue,
    this.registerError,
  });

  final AuthSession? loginSession;
  final AuthSession? currentSessionValue;
  final Exception? registerError;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    return loginSession ?? AuthSession(userId: 'login-user', email: email);
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) async {
    final error = registerError;
    if (error != null) throw error;
    return AuthSession(userId: 'register-user', email: email);
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> currentSession() async {
    return currentSessionValue;
  }
}
