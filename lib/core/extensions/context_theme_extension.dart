import 'package:flutter/material.dart';
import 'package:movie_vault/core/themes/app_colors.dart';

/// Theme helpers exposed from [BuildContext].
///
/// Keeping these helpers under `core/extensions` makes theme access consistent
/// with the rest of the context extensions used by the app.
extension ContextThemeExtension on BuildContext {
  /// Resolved Material theme for the current subtree.
  ThemeData get theme => Theme.of(this);

  /// Resolved text styles for the current theme.
  TextTheme get appTextTheme => theme.textTheme;

  /// Semantic color palette registered in [ThemeData.extensions].
  AppColors get colors =>
      theme.extension<AppColors>() ??
      (throw StateError(
        'AppColors was not registered in ThemeData.extensions',
      ));

  /// Whether the resolved theme is currently dark.
  bool get isDarkMode => theme.brightness == Brightness.dark;
}
