/// Breakpoints centralizados de la aplicación.
///
/// Tenerlos en un solo lugar evita números mágicos repetidos y facilita ajustar
/// la estrategia responsive con el tiempo.
abstract final class AppBreakpoints {
  static const phoneMaxWidth = 599.0;
  static const tabletMaxWidth = 1023.0;

  static const phoneContentMaxWidth = 560.0;
  static const tabletContentMaxWidth = 860.0;
  static const expandedContentMaxWidth = 1120.0;
}

/// Clasificación semántica del viewport actual.
enum AppViewportClass { phone, tablet, expanded }
