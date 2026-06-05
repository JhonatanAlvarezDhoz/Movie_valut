import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: const Text('Cerrar sesión'),
            onTap: authController.logout,
          ),
        ],
      ),
    );
  }
}
