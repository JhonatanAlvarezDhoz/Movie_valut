import 'package:movie_vault/core/themes/app_colors.dart';
import 'package:movie_vault/core/themes/app_text_theme.dart';
import 'package:movie_vault/core/themes/dark_colors.dart';
import 'package:movie_vault/core/themes/light_colors.dart';
import 'package:flutter/material.dart';

/// Fábrica central de `ThemeData` para modo claro y oscuro.
///
/// Aquí se transforma la paleta semántica en componentes concretos de Material:
/// botones, inputs, app bar, chips, divisores, etc.
abstract final class AppTheme {
  static ThemeData get light =>
      _buildTheme(brightness: Brightness.light, colors: lightAppColors);

  static ThemeData get dark =>
      _buildTheme(brightness: Brightness.dark, colors: darkAppColors);

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppColors colors,
  }) {
    // Generamos un `ColorScheme` base de Material 3 y luego lo ajustamos
    // con los tokens propios de la aplicación.
    final baseScheme = ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
    );

    final colorScheme = baseScheme.copyWith(
      primary: colors.primary,
      onPrimary: Colors.white,
      secondary: colors.rating,
      onSecondary: brightness == Brightness.dark
          ? colors.background
          : Colors.white,
      error: colors.error,
      onError: Colors.white,
      surface: colors.surface,
      onSurface: colors.textPrimary,
      outline: colors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      dividerColor: colors.border,
      cardColor: colors.card,
      splashColor: colors.primary.withValues(alpha: 0.08),
      highlightColor: colors.primary.withValues(alpha: 0.04),
      textTheme: buildAppTextTheme(colors),
      // Registramos la paleta custom para poder leerla luego con `context.colors`.
      extensions: <ThemeExtension<dynamic>>[colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textMuted,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.border,
          disabledForegroundColor: colors.textMuted,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: brightness == Brightness.light
            ? colors.surface
            : colors.card,
        selectedColor: colors.primarySoft,
        side: BorderSide(color: colors.border),
        labelStyle: TextStyle(color: colors.textSecondary),
        secondaryLabelStyle: TextStyle(
          color: brightness == Brightness.light
              ? colors.primary
              : colors.textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }
}
