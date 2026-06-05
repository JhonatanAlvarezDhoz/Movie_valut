import 'package:movie_vault/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:movie_vault/features/auth/data/datasources/hive_auth_local_data_source.dart';
import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';
import 'package:movie_vault/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required FirebaseAuthRemoteDataSource remoteDataSource,
    required HiveAuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final FirebaseAuthRemoteDataSource _remoteDataSource;
  final HiveAuthLocalDataSource _localDataSource;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) async {
    final session = await _remoteDataSource.register(
      email: email,
      password: password,
    );
    await _localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
    await _localDataSource.clearSession();
  }

  @override
  Future<AuthSession?> currentSession() async {
    final remoteSession = _remoteDataSource.currentSession();
    if (remoteSession != null) {
      await _localDataSource.saveSession(remoteSession);
      return remoteSession;
    }

    return _localDataSource.readSession();
  }
}
