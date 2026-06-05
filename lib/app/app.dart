import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_vault/app/bindings/initial_binding.dart';
import 'package:movie_vault/app/di/injector.dart';
import 'package:movie_vault/core/responsive/app_viewport_preset.dart';
import 'package:movie_vault/core/router/app_router.dart';
import 'package:movie_vault/core/shared/widgets/app_viewport_preview.dart';
import 'package:movie_vault/core/themes/app_theme.dart';
import 'package:movie_vault/core/themes/app_theme_mode.dart';
import 'package:movie_vault/core/themes/theme_controller.dart';

/// Root widget and application shell.
///
/// This is intentionally small: it wires global concerns such as responsive
/// preview, routing, theme mode and GetX bindings. Feature workflows stay in
/// their own controllers/use cases.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = serviceLocator<ThemeController>();

    return ScreenUtilInit(
      // Design baseline used by shared spacing/typography helpers.
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movie Vault',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeController.mode.value.themeMode,
            // InitialBinding registers global controllers after GetX starts.
            initialBinding: InitialBinding(),
            initialRoute: AppRouter.initialRoute,
            getPages: AppRouter.pages,
            builder: (context, child) {
              return AppViewportPreview(
                preset: AppViewportPreset.system,
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }
}
