import 'package:get/get.dart';
import 'package:movie_vault/app/di/injector.dart';
import 'package:movie_vault/core/themes/theme_controller.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movie_vault/features/movies/presentation/controllers/movies_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ThemeController>(
      serviceLocator<ThemeController>(),
      permanent: true,
    );
    Get.put<AuthController>(serviceLocator<AuthController>(), permanent: true);
    Get.lazyPut<MoviesController>(
      () => serviceLocator<MoviesController>(),
      fenix: true,
    );
  }
}
