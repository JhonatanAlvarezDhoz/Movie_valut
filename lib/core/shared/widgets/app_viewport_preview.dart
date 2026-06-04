import 'package:movie_vault/core/responsive/app_viewport_preset.dart';
import 'package:movie_vault/core/responsive/responsive_scope.dart';
import 'package:movie_vault/core/themes/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Wrapper global que permite usar el viewport real o un preset de preview.
///
/// Esto hace posible alternar dentro de la app entre:
/// - celular portrait
/// - celular landscape
/// - tablet portrait
/// - tablet landscape
///
/// sin depender únicamente del simulador o del dispositivo físico.
class AppViewportPreview extends StatelessWidget {
  const AppViewportPreview({
    super.key,
    required this.preset,
    required this.child,
  });

  final AppViewportPreset preset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (preset.isSystem) {
      return ResponsiveScope(
        data: ResponsiveData(
          size: mediaQuery.size,
          orientation: mediaQuery.orientation,
          isPreview: false,
        ),
        child: child,
      );
    }

    final previewSize = preset.logicalSize!;
    final colors = context.colors;
    final previewMediaQuery = mediaQuery.copyWith(size: previewSize);

    return ColoredBox(
      // Fondo neutro fuera del frame para que el viewport de preview se perciba.
      color: colors.background,
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            width: previewSize.width,
            height: previewSize.height,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colors.border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: MediaQuery(
              data: previewMediaQuery,
              child: ResponsiveScope(
                data: ResponsiveData(
                  size: previewSize,
                  orientation: preset.orientation,
                  isPreview: true,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
