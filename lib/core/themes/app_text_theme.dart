import 'package:movie_valut/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

/// Construye la jerarquía tipográfica base usando la paleta activa.
///
/// De esta forma los estilos de texto ya salen listos con los colores correctos
/// según el modo actual.
TextTheme buildAppTextTheme(AppColors colors) {
  return TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
      height: 1.15,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
      height: 1.2,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: colors.textPrimary,
      height: 1.25,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.3,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.3,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: colors.textPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: colors.textSecondary,
      height: 1.45,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: colors.textMuted,
      height: 1.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: colors.textPrimary,
      height: 1.2,
    ),
  );
}
