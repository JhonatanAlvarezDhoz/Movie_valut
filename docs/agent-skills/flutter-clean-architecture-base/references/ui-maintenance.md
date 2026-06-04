# UI maintenance and visual consistency

The UI must look like one product, not like a collection of isolated screens. Preserve the design system before creating new visual patterns.

## Current UI foundations

```txt
lib/core/themes/
  app_colors.dart
  app_text_theme.dart
  app_theme.dart
  dark_colors.dart
  light_colors.dart
  theme_extensions.dart

lib/core/shared/widgets/
  button/
  fields/
  header/
  responsive_page_container.dart
  section_card.dart
  custom_text.dart
```

## Theme rules

Use theme tokens, not raw visual decisions.

Preferred:

```dart
context.colors.primary
context.colors.card
context.colors.border
context.textTheme.titleMedium
```

Avoid:

```dart
Color(0xFF123456)
TextStyle(fontSize: 17, color: Colors.blue)
```

Rules:

- Use `context.colors` for semantic colors.
- Use `context.textTheme` for typography.
- Add new color tokens only when the intent is reusable app-wide.
- Keep light/dark support intact.
- Do not hardcode colors inside feature widgets unless it is a temporary visual debug aid.

## Visual language

Keep consistency with the existing app style:

- rounded borders;
- soft borders using theme border color;
- card/surface separation;
- clear pressed/disabled/loading states;
- reusable fields/buttons/headers;
- phone/tablet responsive limits.

## Shared first

Before creating UI, inspect:

```txt
lib/core/shared/widgets/
```

Use existing widgets when possible:

- buttons;
- form fields;
- headers;
- section cards;
- responsive page containers;
- navigation widgets;
- skeletons/loaders if available.

If a new widget is reusable app-wide, place it in `core/shared/widgets/<category>/`.
If it knows feature data/business meaning, keep it in the feature.

## Page structure

Pages should compose, not contain everything.

Preferred structure:

```txt
pages/account_page.dart              # Bloc wiring, listeners, top-level layout
widgets/account_content.dart         # Main composition
widgets/account_personal_section.dart
widgets/account_sensitive_section.dart
widgets/skeletons/account_skeleton.dart
```

Rules:

- Keep pages focused on wiring and layout.
- Move sections/cards/forms to widgets.
- Avoid files that become difficult to scan.
- Keep feature-specific UI in the feature folder.

## Forms

Forms must be clear and user-safe.

Rules:

- Use shared fields from `core/shared/widgets/fields` first.
- Keep validation near form composition or validators, not inside random widgets.
- Show success/failure feedback when mutations complete.
- Do not make optional backend fields required in UI unless product says so.
- Prefer dedicated fields for dates, passwords, dropdowns, and editable profile values.

## Loading, empty, error, and success states

Every async screen should define visible states:

| State | UI expectation |
|---|---|
| Loading | Skeleton or loader aligned with final layout. |
| Empty | Helpful empty state with next action when available. |
| Failure | Human message and retry/recovery path. |
| Success mutation | Confirmation feedback such as snackbar/toast/banner. |

Do not show snackbars/dialogs during build. Use listener/effect mechanisms.

## Spacing and sizing

- Prefer existing shared layout widgets.
- Use responsive helpers for page padding/max width.
- Keep spacing consistent within a screen.
- Avoid arbitrary one-off numbers unless they match an existing pattern.
- Do not stretch content edge-to-edge on tablet.

## Icons and affordances

Rules:

- Icons must have enough contrast against their background.
- Clickable/tappable widgets need visible feedback (`InkWell`, button state, etc.).
- Disabled/loading states must communicate that the action is unavailable.
- Avoid unclear icons without labels when the action is not obvious.

## Agent checklist

Before finishing UI work:

- [ ] Existing shared widgets were checked first.
- [ ] New reusable widgets were placed in `core/shared/widgets`.
- [ ] Theme tokens are used instead of raw colors/text styles.
- [ ] Light/dark mode remains safe.
- [ ] Phone/tablet responsive behavior is respected.
- [ ] Loading/empty/error/success states are covered when applicable.
- [ ] Files remain readable and split by responsibility.
- [ ] UI feedback is triggered through listeners/effects, not during build.
