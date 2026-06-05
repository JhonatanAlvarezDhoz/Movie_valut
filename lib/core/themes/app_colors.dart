import 'package:flutter/material.dart';

/// Paleta semántica central de la app.
///
/// En lugar de usar colores sueltos por toda la UI, exponemos tokens con
/// intención de negocio y diseño para una app de películas:
/// `rating`, `favorite`, `success`, `error`, `surface`, etc.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color surface;
  final Color card;
  final Color border;

  final Color primary;
  final Color primarySoft;

  final Color success;
  final Color error;
  final Color rating;
  final Color favorite;

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;

  const AppColors({
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.primary,
    required this.primarySoft,
    required this.success,
    required this.error,
    required this.rating,
    required this.favorite,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
  });

  /// Permite crear variantes sin mutar la instancia actual.
  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? card,
    Color? border,
    Color? primary,
    Color? primarySoft,
    Color? success,
    Color? error,
    Color? rating,
    Color? favorite,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      card: card ?? this.card,
      border: border ?? this.border,
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      success: success ?? this.success,
      error: error ?? this.error,
      rating: rating ?? this.rating,
      favorite: favorite ?? this.favorite,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
    );
  }

  /// Flutter usa este `lerp` para animar transiciones entre tema claro/oscuro.
  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }

    return AppColors(
      background: Color.lerp(background, other.background, t) ?? background,
      surface: Color.lerp(surface, other.surface, t) ?? surface,
      card: Color.lerp(card, other.card, t) ?? card,
      border: Color.lerp(border, other.border, t) ?? border,
      primary: Color.lerp(primary, other.primary, t) ?? primary,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t) ?? primarySoft,
      success: Color.lerp(success, other.success, t) ?? success,
      error: Color.lerp(error, other.error, t) ?? error,
      rating: Color.lerp(rating, other.rating, t) ?? rating,
      favorite: Color.lerp(favorite, other.favorite, t) ?? favorite,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textSecondary:
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
    );
  }
}
