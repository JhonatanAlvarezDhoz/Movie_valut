import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/widgets/loaders/app_loader.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authController.checkSessionAndRedirect();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_creation_outlined, size: 64),
            SizedBox(height: 16),
            Text('Movie Vault'),
            SizedBox(height: 24),
            AppLoader(),
          ],
        ),
      ),
    );
  }
}
