import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_vault/core/constants/keys/network_header_keys.dart';
import 'package:movie_vault/core/logger/logger.dart';
import 'package:movie_vault/core/storage/services/session_storage_service.dart';

/// HTTP authentication interceptor.
///
/// Responsibilities:
/// - Adds `Authorization: Bearer <accessToken>` to protected requests.
/// - Detects `401 Unauthorized` responses.
/// - Refreshes the session through `POST auth/refresh`.
/// - Retries the original request once with the new access token.
/// - Clears session data when refresh is no longer possible.
///
/// This stays separate from `NetworkHeadersInterceptor` because headers, cache
/// metadata and authentication are different responsibilities.
class AuthInterceptor extends Interceptor {
  static const _refreshPath = 'auth/refresh';

  final Dio _dio;
  final SessionStorageService _sessionStorageService;
  final AppLogger _logger;

  /// In-flight refresh request shared by concurrent 401 failures.
  ///
  /// Without this, several expired requests could trigger several refresh calls
  /// at the same time, creating backend noise and token rotation problems.
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

    // Only 401 can trigger refresh. A login 400 must reach the repository so
    // the UI can show the correct invalid-credentials message.
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

      // Mark the retry so a second 401 cannot start an infinite refresh loop.
      requestOptions.extra[NetworkRequestKeys.skipAuthRefresh] = true;

      final retryResponse = await _dio.fetch<dynamic>(requestOptions);
      handler.resolve(retryResponse);
    } catch (refreshError, stackTrace) {
      _logger.warning('Session refresh was not possible.');
      _logger.error(
        'Refresh token failed.',
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

    // Login, register and refresh do not need an access token. This prevents
    // stale credentials from being sent to public/session endpoints.
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
        // Internal flags: keep refresh unauthenticated and prevent retry loops
        // if refresh itself fails.
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

/// Minimal refresh payload needed by the network layer to persist a session.
///
/// Auth feature models are intentionally not used here: `core/network` must not
/// depend on concrete feature packages.
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
