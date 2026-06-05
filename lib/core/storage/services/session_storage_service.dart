import 'package:movie_vault/core/constants/keys/storage_keys.dart';
import 'package:movie_vault/core/storage/contracts/secure_key_value_storage.dart';

/// Servicio especializado para datos de sesión/autenticación.
///
/// Esta clase evita que cualquier parte de la app manipule
/// directamente tokens o claves sensibles.
class SessionStorageService {
  final SecureKeyValueStorage _secureStorage;

  const SessionStorageService(this._secureStorage);

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return _secureStorage.read(StorageKeys.accessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(StorageKeys.refreshToken);
  }

  Future<void> saveUserId(String userId) async {
    await _secureStorage.write(key: StorageKeys.userId, value: userId);
  }

  Future<String?> getUserId() async {
    return _secureStorage.read(StorageKeys.userId);
  }

  Future<void> saveUserEmail(String email) async {
    await _secureStorage.write(key: StorageKeys.userEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return _secureStorage.read(StorageKeys.userEmail);
  }

  Future<void> saveSessionExpiresAt(DateTime expiresAt) async {
    await _secureStorage.write(
      key: StorageKeys.sessionExpiresAt,
      value: expiresAt.toUtc().toIso8601String(),
    );
  }

  Future<DateTime?> getSessionExpiresAt() async {
    final value = await _secureStorage.read(StorageKeys.sessionExpiresAt);
    if (value == null || value.isEmpty) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  /// Indica si la sesión local todavía puede usarse para rutas privadas.
  ///
  /// OJO: "sesión válida" acá significa "sesión recuperable para navegar".
  /// Si el access token venció pero todavía tenemos refresh token, dejamos
  /// pasar la navegación para no destruir una sesión que todavía puede
  /// recuperarse con Firebase/Auth en el siguiente chequeo explícito.
  ///
  /// Si limpiamos la sesión apenas vence el access token, destruimos también
  /// el refresh token y bloqueamos justamente el flujo que debería renovarlo.
  Future<bool> hasValidSession({DateTime? now}) async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final expiresAt = await getSessionExpiresAt();

    final hasAccessToken = accessToken != null && accessToken.isNotEmpty;
    final hasRefreshToken = refreshToken != null && refreshToken.isNotEmpty;

    if (!hasAccessToken && !hasRefreshToken) {
      return false;
    }

    if (expiresAt == null) {
      return hasRefreshToken;
    }

    final currentTime = now ?? DateTime.now().toUtc();
    final isExpired = !expiresAt.toUtc().isAfter(currentTime);

    if (isExpired && !hasRefreshToken) {
      await clearSession();
      return false;
    }

    if (isExpired) {
      return true;
    }

    return true;
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(StorageKeys.accessToken);
    await _secureStorage.delete(StorageKeys.refreshToken);
    await _secureStorage.delete(StorageKeys.userId);
    await _secureStorage.delete(StorageKeys.userEmail);
    await _secureStorage.delete(StorageKeys.sessionExpiresAt);
  }
}
