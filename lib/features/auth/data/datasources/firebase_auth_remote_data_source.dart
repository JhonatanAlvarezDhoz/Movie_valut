import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_vault/core/errors/exceptions/exception.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/features/auth/data/models/auth_session_model.dart';

class FirebaseAuthRemoteDataSource {
  const FirebaseAuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Future<AuthSessionModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _sessionFromCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    }
  }

  Future<AuthSessionModel> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _sessionFromCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapFirebaseAuthException(error);
    } catch (_) {
      throw ServerException('No fue posible cerrar sesión.');
    }
  }

  AuthSessionModel? currentSession() {
    final user = _firebaseAuth.currentUser;
    final email = user?.email;

    if (user == null || email == null || email.isEmpty) {
      return null;
    }

    return AuthSessionModel.fromFirebase(userId: user.uid, email: email);
  }

  AuthSessionModel _sessionFromCredential(UserCredential credential) {
    final user = credential.user;
    final email = user?.email;

    if (user == null || email == null || email.isEmpty) {
      throw ParsingException('Firebase no devolvió una sesión válida.');
    }

    return AuthSessionModel.fromFirebase(userId: user.uid, email: email);
  }

  AppException _mapFirebaseAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return ValidationException('Ingresá un correo válido.');
      case 'weak-password':
        return ValidationException(
          'La contraseña debe tener al menos 6 caracteres.',
        );
      case 'email-already-in-use':
        return ConflictException('Ya existe una cuenta con ese correo.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return UnauthorizedException('Correo o contraseña incorrectos.');
      case 'network-request-failed':
        return NetworkException('No hay conexión para autenticar.');
      default:
        return ServerException('No fue posible autenticar con Firebase.');
    }
  }
}
