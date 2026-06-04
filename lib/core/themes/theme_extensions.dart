import 'package:movie_vault/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Atajos de acceso al tema desde cualquier `BuildContext`.
///
/// Esto evita llamadas repetitivas como `Theme.of(context)` o tener que castear
/// manualmente la extensión de colores cada vez.
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  /// Devuelve la paleta semántica activa del tema actual.
  AppColors get colors =>
      theme.extension<AppColors>() ??
      (throw StateError('AppColors no fue registrado en ThemeData.extensions'));

  /// Indica si el tema resuelto actualmente es oscuro.
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
