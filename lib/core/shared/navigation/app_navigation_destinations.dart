import 'package:flutter/material.dart';

/// Modelo visual común para los destinos principales de navegación.
class AppNavigationDestination {
  const AppNavigationDestination({required this.label, required this.icon});

  final String label;
  final IconData icon;
}

/// Construye la lista única de destinos para bottom nav y navigation rail.
List<AppNavigationDestination> buildAppNavigationDestinations(
  BuildContext context,
) {
  return <AppNavigationDestination>[
    AppNavigationDestination(label: 'Home', icon: Icons.swap_horiz_rounded),
    AppNavigationDestination(
      label: "Favorite",
      icon: Icons.notifications_rounded,
    ),
    AppNavigationDestination(label: "Profile", icon: Icons.settings_rounded),
  ];
}
