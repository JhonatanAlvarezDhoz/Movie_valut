/// Llaves centralizadas del sistema de storage.
///
/// Se mantienen agrupadas aquí para evitar strings mágicos
/// y para que red, sesión y preferencias hablen el mismo lenguaje.
abstract final class StorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const userId = 'user_id';
  static const userEmail = 'user_email';
  static const sessionExpiresAt = 'session_expires_at';

  static const locale = 'locale';
  static const themeMode = 'theme_mode';
  static const viewportPreset = 'viewport_preset';
  static const onboardingCompleted = 'onboarding_completed';
  static const biometricLoginEnabled = 'security.biometric_login_enabled';

  /// Namespace para metadatos HTTP persistidos localmente.
  static const etagNamespace = 'network.etag';

  /// Construye una llave estable para guardar el ETag de un recurso.
  static String etag(String resourceKey) => '$etagNamespace.$resourceKey';
}
