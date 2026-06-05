import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';
import 'package:movie_vault/core/themes/theme_extensions.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      _authController.checkSessionAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 64,
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text('Movie Vault', style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Tu catálogo de películas', style: textTheme.bodyMedium),
            const SizedBox(height: 24),
            const AppLoader(),
          ],
        ),
      ),
    );
  }
}
