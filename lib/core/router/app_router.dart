import 'package:get/get.dart';
import 'package:movie_vault/core/router/app_routes.dart';
import 'package:movie_vault/features/auth/presentation/pages/login_page.dart';
import 'package:movie_vault/features/auth/presentation/pages/register_page.dart';
import 'package:movie_vault/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:movie_vault/features/movies/presentation/pages/movies_home_page.dart';

abstract final class AppRouter {
  static const initialRoute = AppRoutes.login;

  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(name: AppRoutes.home, page: () => const MoviesHomePage()),
    GetPage(name: AppRoutes.movieDetail, page: () => const MovieDetailPage()),
  ];
}
