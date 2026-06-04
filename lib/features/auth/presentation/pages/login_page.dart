import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/router/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: FilledButton(
          onPressed: () => Get.offAllNamed(AppRoutes.home),
          child: const Text('Continuar'),
        ),
      ),
    );
  }
}
