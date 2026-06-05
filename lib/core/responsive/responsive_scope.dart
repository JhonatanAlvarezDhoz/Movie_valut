import 'package:flutter/material.dart';
import 'package:movie_vault/core/responsive/app_breakpoints.dart';

/// Modelo inmutable con información responsive calculada para una app
/// portrait-only.
///
/// La UI solo debe adaptar phone/tablet. No diseñamos ramas landscape porque el
/// producto bloquea orientación vertical desde el arranque y plataformas.
class ResponsiveData {
  const ResponsiveData({
    required this.size,
    required this.orientation,
    required this.isPreview,
  });

  final Size size;
  final Orientation orientation;
  final bool isPreview;

  double get width => size.width;
  double get height => size.height;
  double get shortestSide => size.shortestSide;

  bool get isPortrait => true;

  AppViewportClass get viewportClass {
    if (width <= AppBreakpoints.phoneMaxWidth) {
      return AppViewportClass.phone;
    }

    if (width <= AppBreakpoints.tabletMaxWidth) {
      return AppViewportClass.tablet;
    }

    return AppViewportClass.expanded;
  }

  bool get isPhone => viewportClass == AppViewportClass.phone;
  bool get isTablet => viewportClass == AppViewportClass.tablet;
  bool get isExpanded => viewportClass == AppViewportClass.expanded;

  /// En portrait-only, la navegación lateral solo tiene sentido para tablet o
  /// ancho expandido. Phone usa bottom navigation o navegación normal.
  bool get prefersRailNavigation => isTablet || isExpanded;

  double get contentMaxWidth {
    switch (viewportClass) {
      case AppViewportClass.phone:
        return AppBreakpoints.phoneContentMaxWidth;
      case AppViewportClass.tablet:
        return AppBreakpoints.tabletContentMaxWidth;
      case AppViewportClass.expanded:
        return AppBreakpoints.expandedContentMaxWidth;
    }
  }

  double get horizontalPadding {
    if (isExpanded) {
      return 32;
    }

    if (isTablet) {
      return 24;
    }

    return 20;
  }
}

class ResponsiveScope extends InheritedWidget {
  const ResponsiveScope({super.key, required this.data, required super.child});

  final ResponsiveData data;

  static ResponsiveData of(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<ResponsiveScope>();

    if (inherited != null) {
      return inherited.data;
    }

    final mediaQuery = MediaQuery.of(context);
    return ResponsiveData(
      size: mediaQuery.size,
      orientation: Orientation.portrait,
      isPreview: false,
    );
  }

  @override
  bool updateShouldNotify(covariant ResponsiveScope oldWidget) {
    return oldWidget.data != data;
  }
}
