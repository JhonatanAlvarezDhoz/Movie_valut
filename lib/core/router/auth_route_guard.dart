import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/core/storage/services/session_storage_service.dart';

/// Minimal route decision helper based on session storage.
///
/// This guard must stay thin: it decides routes from session state only and
/// must not execute authentication workflows or HTTP requests.
class AuthRouteGuard {
  const AuthRouteGuard(this._sessionStorageService);

  final SessionStorageService _sessionStorageService;

  /// Returns the route that should be used for a stored valid/invalid session.
  Future<String> initialRoute() async {
    final hasValidSession = await _sessionStorageService.hasValidSession();
    return hasValidSession ? AppRoutes.home : AppRoutes.login;
  }
}
