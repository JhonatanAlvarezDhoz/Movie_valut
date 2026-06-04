import 'package:movie_vault/core/extensions/context_responsive_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Contenedor base para páginas scrollables con ancho y padding adaptativos.
///
/// Evita repetir `SafeArea + ListView + ConstrainedBox + padding` en cada
/// feature, y permite que todas respondan igual a phone, tablet y landscape.
class ResponsivePageContainer extends StatelessWidget {
  const ResponsivePageContainer({
    super.key,
    required this.children,
    this.bottomSpacing = 30,
  });

  final List<Widget> children;
  final double bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.pageContentMaxWidth),
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              context.pageHorizontalPadding.w,
              20.h,
              context.pageHorizontalPadding.w,
              bottomSpacing.h,
            ),
            children: children,
          ),
        ),
      ),
    );
  }
}
