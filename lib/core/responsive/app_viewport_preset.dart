import 'package:flutter/material.dart';

/// Presets de preview permitidos para una app portrait-only.
///
/// Mantenemos phone/tablet porque eso sí cambia composición y ancho útil, pero
/// no exponemos landscape: si la app está bloqueada en portrait, el responsive
/// no debería sugerir layouts que el producto no soporta.
enum AppViewportPreset { system, phonePortrait, tabletPortrait }

extension AppViewportPresetX on AppViewportPreset {
  String get storageValue => name;

  bool get isSystem => this == AppViewportPreset.system;

  Orientation get orientation => Orientation.portrait;

  Size? get logicalSize {
    switch (this) {
      case AppViewportPreset.system:
        return null;
      case AppViewportPreset.phonePortrait:
        return const Size(390, 844);
      case AppViewportPreset.tabletPortrait:
        return const Size(820, 1180);
    }
  }

  String get label {
    switch (this) {
      case AppViewportPreset.system:
        return 'Sistema';
      case AppViewportPreset.phonePortrait:
        return 'Teléfono vertical';
      case AppViewportPreset.tabletPortrait:
        return 'Tablet vertical';
    }
  }
}

AppViewportPreset appViewportPresetFromStorage(String? value) {
  return AppViewportPreset.values.firstWhere(
    (preset) => preset.name == value,
    orElse: () => AppViewportPreset.system,
  );
}
