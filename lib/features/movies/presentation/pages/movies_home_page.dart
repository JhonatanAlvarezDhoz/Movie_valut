import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/router/app_routes.dart';

class MoviesHomePage extends StatelessWidget {
  const MoviesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Vault'),
        actions: [
          IconButton(
            tooltip: 'Cuenta',
            onPressed: () => Get.toNamed(AppRoutes.account),
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Ajustes',
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(child: Text('Películas TMDB pendiente')),
      ),
    );
  }
}
