# Responsive UI: phone and tablet only

This project targets responsive behavior for **phone and tablet**. Do not design desktop-first layouts unless the product explicitly changes scope.

## Current structure

```txt
lib/core/responsive/
  app_breakpoints.dart
  app_viewport_preset.dart
  responsive_scope.dart

lib/core/extensions/
  context_responsive_extension.dart

lib/core/shared/widgets/
  responsive_page_container.dart
  app_viewport_preview.dart
```

## Supported viewport classes

Use the existing semantic helpers:

- `context.isPhone`
- `context.isTablet`
- `context.isLandscape`
- `context.pageHorizontalPadding`
- `context.pageContentMaxWidth`
- `context.prefersRailNavigation`
- `context.prefersCompactRailNavigation`

`expanded` may exist internally as a safe fallback, but agents must not create desktop-specific features unless requested.

## Rules

- Use `ResponsivePageContainer` for standard scrollable pages.
- Use `core/responsive/app_breakpoints.dart` for breakpoints.
- Do not hardcode magic widths inside widgets.
- Do not create new breakpoint systems per feature.
- Prefer semantic decisions: phone/tablet, portrait/landscape, rail/bottom nav.
- Keep responsive logic in layout composition, not business widgets.
- Keep phone as the baseline layout; enhance tablet layout only where it improves readability.

## Navigation behavior

Use responsive helpers for navigation decisions:

| Context | Preferred navigation |
|---|---|
| Phone portrait | Bottom navigation |
| Phone landscape with low height | Compact navigation if needed |
| Tablet portrait/landscape | Navigation rail when available |

Do not let each page decide navigation strategy independently.

## Layout guidance

| Need | Rule |
|---|---|
| Page padding | Use `context.pageHorizontalPadding`. |
| Max content width | Use `context.pageContentMaxWidth`. |
| Scrollable page shell | Use `ResponsivePageContainer`. |
| Preview/testing viewport | Use `AppViewportPreset` / `AppViewportPreview` if available. |
| Phone/tablet branch | Use `context.isPhone` / `context.isTablet`. |

## What not to do

Avoid:

```dart
if (MediaQuery.of(context).size.width > 734) { ... }
```

Prefer:

```dart
if (context.isTablet) { ... }
```

or add a named breakpoint/helper in `core/responsive` if a new semantic case is truly needed.

## Agent checklist

Before finishing responsive work:

- [ ] Only phone/tablet behavior was added.
- [ ] No magic responsive numbers were added inside feature widgets.
- [ ] Existing `ResponsivePageContainer` and context responsive helpers were considered.
- [ ] Tablet layout improves readability instead of just stretching phone UI.
- [ ] Navigation behavior follows shared responsive helpers.
