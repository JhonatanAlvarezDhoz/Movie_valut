import 'package:movie_vault/features/auth/domain/entities/auth_session.dart';

/// Contract used by auth use cases.
///
/// Auth is remote-first for login/register: local persistence is an
/// implementation detail of the repository, never a domain concern.
abstract interface class AuthRepository {
  /// Authenticates an existing Firebase user and returns the active session.
  Future<AuthSession> login({required String email, required String password});

  /// Creates a Firebase user and returns the active session.
  Future<AuthSession> register({
    required String email,
    required String password,
  });

  /// Closes remote and local session state.
  Future<void> logout();

  /// Returns the current session if Firebase or local storage knows one.
  Future<AuthSession?> currentSession();

  /// Sends the password recovery email for an existing Firebase user.
  Future<void> resetPassword(String email);
}
