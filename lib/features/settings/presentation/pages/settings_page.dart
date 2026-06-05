import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_vault/core/shared/widgets/button/app_button.dart';
import 'package:movie_vault/core/themes/theme_controller.dart';
import 'package:movie_vault/core/themes/theme_extensions.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    final colors = context.colors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text('Cuenta', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Obx(() {
              final session = authController.session.value;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: colors.primarySoft,
                  child: Icon(Icons.person_rounded, color: colors.primary),
                ),
                title: Text(session?.email ?? 'Sin sesión activa'),
                subtitle: Text(
                  session == null
                      ? 'Iniciá sesión para ver tu cuenta.'
                      : 'Usuario autenticado con Firebase',
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          Text('Apariencia', style: textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Obx(() {
              final isDarkMode = themeController.isDarkMode;

              return SwitchListTile(
                value: isDarkMode,
                onChanged: (value) =>
                    themeController.toggleDarkMode(enabled: value),
                secondary: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    key: ValueKey(isDarkMode),
                    color: isDarkMode ? colors.primary : colors.rating,
                  ),
                ),
                title: Text(isDarkMode ? 'Modo oscuro' : 'Modo claro'),
                subtitle: const Text('Alterná entre luna y sol.'),
              );
            }),
          ),
          const SizedBox(height: 24),
          Obx(() {
            return AppButton(
              label: 'Cerrar sesión',
              isLoading: authController.isSubmitting.value,
              onPressed: authController.logout,
            );
          }),
        ],
      ),
    );
  }
}
