import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cuenta')),
      body: Center(
        child: Obx(() {
          final session = authController.session.value;
          return Text(session?.email ?? 'Sin sesión activa');
        }),
      ),
    );
  }
}
