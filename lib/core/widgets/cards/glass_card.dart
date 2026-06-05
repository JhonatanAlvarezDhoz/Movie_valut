import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_vault/core/themes/app_colors.dart';

/// Card reusable con estética glassmorphism.
///
/// Centraliza blur, borde y transparencia para que formularios y bloques de
/// autenticación mantengan una misma identidad visual sin duplicar estilos.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 28,
    this.blurSigma = 18,
    this.opacity = 0.72,
    this.width,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blurSigma;
  final double opacity;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final radius = BorderRadius.circular(borderRadius);

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: colors.surface.withValues(alpha: opacity),
            border: Border.all(color: colors.border.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.10),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
