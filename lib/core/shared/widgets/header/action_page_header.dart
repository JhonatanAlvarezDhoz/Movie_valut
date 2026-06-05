import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_vault/core/shared/widgets/custom_text.dart';
import 'package:movie_vault/core/extensions/context_theme_extension.dart';

/// Header reutilizable para páginas internas.
///
///
/// Título centrado y una acción derecha opcional que puede hacer shake
/// para guiar al usuario cuando intenta editar una sección bloqueada.
class ActionPageHeader extends StatefulWidget {
  const ActionPageHeader({
    super.key,
    required this.title,
    required this.onBackTap,
    this.trailing,
  });

  final String title;
  final VoidCallback onBackTap;

  /// Acción derecha opcional: editar, guardar, abrir menú, etc.
  ///
  /// Si se omite, se reserva el mismo ancho del botón de regreso para mantener
  /// el título visualmente centrado.
  final Widget? trailing;

  @override
  State<ActionPageHeader> createState() => ActionPageHeaderState();
}

class ActionPageHeaderState extends State<ActionPageHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _shakeAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: 0, end: -7), weight: 1),
        TweenSequenceItem(tween: Tween(begin: -7, end: 7), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 7, end: -5), weight: 2),
        TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 2),
        TweenSequenceItem(tween: Tween(begin: 5, end: 0), weight: 1),
      ],
    ).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  /// Sacude la acción derecha opcional, útil para indicar dónde habilitar edición.
  void shakeTrailing() {
    if (widget.trailing == null) {
      return;
    }

    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Material(
          color: colors.surface,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: widget.onBackTap,
            child: SizedBox(
              width: 38.w,
              height: 38.w,
              child: Icon(
                Icons.chevron_left_rounded,
                color: colors.textPrimary,
                size: 24.sp,
              ),
            ),
          ),
        ),
        Expanded(
          child: CustomText(
            text: widget.title,
            style: context.appTextTheme.titleMedium,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (widget.trailing == null)
          SizedBox(width: 38.w, height: 38.w)
        else
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value, 0),
                child: child,
              );
            },
            child: widget.trailing,
          ),
      ],
    );
  }
}
