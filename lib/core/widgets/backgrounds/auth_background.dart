import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_vault/core/themes/app_colors.dart';

/// Fondo cinematográfico reusable para Splash, Login y Register.
///
/// No usa imágenes: combina gradientes, glows con blur y un CustomPainter sutil
/// para dar textura premium sin saturar la interfaz.
class AuthBackground extends StatelessWidget {
  const AuthBackground({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
    this.maxContentWidth = 440,
    this.enableScroll = true,
    this.centerContent = true,
    this.glowIntensity = 1,
    this.blurSigma = 64,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double maxContentWidth;
  final bool enableScroll;
  final bool centerContent;
  final double glowIntensity;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.background,
            Color.lerp(colors.background, colors.primarySoft, 0.20)!,
            colors.background,
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _GlowCircle(
            alignment: const Alignment(-1.15, -0.92),
            size: 280,
            color: colors.primary,
            blurSigma: blurSigma,
            opacity: 0.28 * glowIntensity,
          ),
          _GlowCircle(
            alignment: const Alignment(1.10, -0.24),
            size: 240,
            color: colors.favorite,
            blurSigma: blurSigma,
            opacity: 0.16 * glowIntensity,
          ),
          _GlowCircle(
            alignment: const Alignment(0.72, 1.05),
            size: 340,
            color: colors.primarySoft,
            blurSigma: blurSigma,
            opacity: 0.32 * glowIntensity,
          ),
          CustomPaint(painter: _CinemaPatternPainter(colors: colors)),
          SafeArea(
            child: Padding(
              padding: padding,
              child: _AuthContentFrame(
                maxContentWidth: maxContentWidth,
                enableScroll: enableScroll,
                centerContent: centerContent,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthContentFrame extends StatelessWidget {
  const _AuthContentFrame({
    required this.child,
    required this.maxContentWidth,
    required this.enableScroll,
    required this.centerContent,
  });

  final Widget child;
  final double maxContentWidth;
  final bool enableScroll;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final framedChild = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: child,
      ),
    );

    if (!enableScroll) {
      return centerContent
          ? framedChild
          : Align(alignment: Alignment.topCenter, child: framedChild);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: centerContent
                ? framedChild
                : Align(alignment: Alignment.topCenter, child: framedChild),
          ),
        );
      },
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.alignment,
    required this.size,
    required this.color,
    required this.blurSigma,
    required this.opacity,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final double blurSigma;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: opacity.clamp(0, 1)),
          ),
        ),
      ),
    );
  }
}

class _CinemaPatternPainter extends CustomPainter {
  const _CinemaPatternPainter({required this.colors});

  final AppColors colors;

  @override
  void paint(Canvas canvas, Size size) {
    _drawDiagonalLines(canvas, size);
    _drawFilmStrip(canvas, size);
    _drawSoftVignette(canvas, size);
  }

  void _drawDiagonalLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colors.primary.withValues(alpha: 0.055)
      ..strokeWidth = 1;

    for (var x = -size.height; x < size.width; x += 34) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  void _drawFilmStrip(Canvas canvas, Size size) {
    final stripPaint = Paint()
      ..color = colors.textPrimary.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final perforationPaint = Paint()
      ..color = colors.textPrimary.withValues(alpha: 0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.save();
    canvas.translate(size.width * 0.64, size.height * 0.05);
    canvas.rotate(-math.pi / 9);

    final strip = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, 112, size.height * 0.82),
      const Radius.circular(18),
    );
    canvas.drawRRect(strip, stripPaint);

    for (var y = 18.0; y < size.height * 0.78; y += 34) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(10, y, 14, 18),
          const Radius.circular(3),
        ),
        perforationPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(88, y, 14, 18),
          const Radius.circular(3),
        ),
        perforationPaint,
      );
    }

    canvas.restore();
  }

  void _drawSoftVignette(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.92,
        colors: [Colors.transparent, colors.background.withValues(alpha: 0.58)],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _CinemaPatternPainter oldDelegate) {
    return oldDelegate.colors != colors;
  }
}
