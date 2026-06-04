import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_vault/core/constants/keys/network_header_keys.dart';
import 'package:movie_vault/core/logger/logger.dart';
import 'package:movie_vault/core/storage/services/session_storage_service.dart';

/// Interceptor responsable de autenticación HTTP.
///
/// Responsabilidades:
/// - Agregar `Authorization: Bearer <accessToken>` a requests protegidas.
/// - Detectar respuestas `401 Unauthorized`.
/// - Renovar la sesión con `POST auth/refresh` usando el refresh token.
/// - Reintentar UNA vez la request original con el nuevo access token.
/// - Limpiar sesión si el refresh token ya no sirve.
///
/// Importante: esto vive separado de `NetworkHeadersInterceptor` porque ETags,
/// content-type y autenticación son responsabilidades distintas. Mezclarlas
/// haría que la capa de red sea más difícil de mantener y testear.
class AuthInterceptor extends Interceptor {
  static const _refreshPath = 'auth/refresh';

  final Dio _dio;
  final SessionStorageService _sessionStorageService;
  final AppLogger _logger;

  /// Guarda el refresh en curso para evitar disparar múltiples refresh token
  /// si varias requests protegidas fallan con 401 al mismo tiempo.
  ///
  /// Sin esto, 5 requests vencidas podrían enviar 5 refresh simultáneos.
  /// Eso es ruido para el backend y puede invalidar tokens dependiendo de la
  /// estrategia de rotación.
  Future<_RefreshResult?>? _refreshInFlight;

  AuthInterceptor(this._dio, this._sessionStorageService, this._logger);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_shouldSkipAuth(options)) {
      handler.next(options);
      return;
    }

    final accessToken = await _sessionStorageService.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers[NetworkHeaderKeys.authorization] =
          '${NetworkHeaderKeys.bearerPrefix} $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;
    final requestOptions = err.requestOptions;

    // Solo el 401 intenta refresh. Un 400 de login, por ejemplo, debe llegar
    // al repositorio para mostrar "Invalid email or password" correctamente.
    if (statusCode != HttpStatus.unauthorized ||
        _shouldSkipRefresh(requestOptions)) {
      handler.next(err);
      return;
    }

    try {
      final refreshResult = await _refreshSession();

      if (refreshResult == null) {
        await _sessionStorageService.clearSession();
        handler.next(err);
        return;
      }

      requestOptions.headers[NetworkHeaderKeys.authorization] =
          '${NetworkHeaderKeys.bearerPrefix} ${refreshResult.accessToken}';

      // Marcamos el retry para que, si vuelve a fallar con 401, NO intente
      // refrescar otra vez y crear un loop infinito.
      requestOptions.extra[NetworkRequestKeys.skipAuthRefresh] = true;

      final retryResponse = await _dio.fetch<dynamic>(requestOptions);
      handler.resolve(retryResponse);
    } catch (refreshError, stackTrace) {
      _logger.warning('No fue posible refrescar la sesión.');
      _logger.error(
        'Refresh token falló.',
        error: refreshError,
        stackTrace: stackTrace,
      );

      await _sessionStorageService.clearSession();
      handler.next(err);
    }
  }

  bool _shouldSkipAuth(RequestOptions options) {
    if (options.extra[NetworkRequestKeys.skipAuth] == true) {
      return true;
    }

    final path = _normalizePath(options.path);

    // Login, registro y refresh no necesitan access token. Esto evita mandar
    // credenciales viejas a endpoints públicos/de sesión.
    return path == 'auth/login' ||
        path == 'auth/register' ||
        path == _refreshPath;
  }

  bool _shouldSkipRefresh(RequestOptions options) {
    final path = _normalizePath(options.path);

    return options.extra[NetworkRequestKeys.skipAuthRefresh] == true ||
        path == _refreshPath ||
        path == 'auth/logout';
  }

  Future<_RefreshResult?> _refreshSession() {
    final currentRefresh = _refreshInFlight;
    if (currentRefresh != null) {
      return currentRefresh;
    }

    final refresh = _requestRefreshSession();
    _refreshInFlight = refresh;

    return refresh.whenComplete(() {
      _refreshInFlight = null;
    });
  }

  Future<_RefreshResult?> _requestRefreshSession() async {
    final refreshToken = await _sessionStorageService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    final response = await _dio.post<dynamic>(
      _refreshPath,
      data: {'refreshToken': refreshToken},
      options: Options(
        // Estos flags son internos: evitan que el request de refresh se
        // autentique con un access token vencido y evitan loops si falla.
        extra: const {
          NetworkRequestKeys.skipAuth: true,
          NetworkRequestKeys.skipAuthRefresh: true,
        },
      ),
    );

    final refreshResult = _parseRefreshResponse(response.data);
    if (refreshResult == null) {
      return null;
    }

    await _sessionStorageService.saveAccessToken(refreshResult.accessToken);
    await _sessionStorageService.saveRefreshToken(refreshResult.refreshToken);
    await _sessionStorageService.saveSessionExpiresAt(refreshResult.expiresAt);

    return refreshResult;
  }

  _RefreshResult? _parseRefreshResponse(dynamic source) {
    if (source is! Map<String, dynamic>) {
      return null;
    }

    final isSuccess = source['isSuccess'] as bool? ?? false;
    final data = source['data'];

    if (!isSuccess || data is! Map<String, dynamic>) {
      return null;
    }

    final accessToken = data['accessToken'] as String? ?? '';
    final refreshToken = data['refreshToken'] as String? ?? '';
    final userId = data['userId'] as String? ?? '';
    final email = data['email'] as String? ?? '';
    final expiresAt = DateTime.tryParse(data['expiresAt'] as String? ?? '');

    if (accessToken.isEmpty ||
        refreshToken.isEmpty ||
        userId.isEmpty ||
        email.isEmpty ||
        expiresAt == null) {
      return null;
    }

    return _RefreshResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      email: email,
      expiresAt: expiresAt,
    );
  }

  String _normalizePath(String path) {
    return path.startsWith('/') ? path.substring(1) : path;
  }
}

/// Resultado mínimo que necesita la capa de red para persistir la nueva sesión.
///
/// No usamos modelos del feature `auth` acá para evitar que `core/network`
/// dependa de `features/auth`. Esa separación importa: core debe ser base,
/// no conocer features concretos.
class _RefreshResult {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String email;
  final DateTime expiresAt;

  const _RefreshResult({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.email,
    required this.expiresAt,
  });
}
