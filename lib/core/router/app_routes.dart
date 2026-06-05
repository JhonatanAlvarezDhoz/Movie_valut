/// Centralized route names used by GetX navigation.
///
/// Widgets must reference these constants instead of hardcoded route strings.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const movieDetail = '/movies/:movieId';
  static const settings = '/settings';
  static const account = '/account';
}
