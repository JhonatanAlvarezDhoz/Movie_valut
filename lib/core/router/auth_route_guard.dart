import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/core/storage/services/session_storage_service.dart';

/// Guard mínimo de sesión para navegación.
///
/// GetX no debe hacer workflows de auth acá: solo decidir ruta inicial o
/// redirecciones simples en base a SessionStorage.
class AuthRouteGuard {
  const AuthRouteGuard(this._sessionStorageService);

  final SessionStorageService _sessionStorageService;

  Future<String> initialRoute() async {
    final hasValidSession = await _sessionStorageService.hasValidSession();
    return hasValidSession ? AppRoutes.home : AppRoutes.login;
  }
}
