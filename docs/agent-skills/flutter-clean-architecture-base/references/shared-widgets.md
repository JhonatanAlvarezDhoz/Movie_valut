# Shared widgets and reusable UI

Before creating a new widget, inspect the project shared widget catalog.

Common location:

```txt
lib/core/shared/widgets/
  button/
  fields/
  header/
  skeletons/
  layout/
```

## Decision rule

| Widget type | Location |
|---|---|
| Used by one feature only | `features/<feature>/presentation/widgets/` |
| Used or clearly reusable by multiple features | `core/shared/widgets/<category>/` |
| Visual primitive such as field, button, header, container, loader | `core/shared/widgets/` |
| Feature-specific card/section with business copy/data | Feature widget folder |

## Requirements for shared widgets

Shared widgets must be:

- feature-agnostic;
- configurable through constructor parameters;
- visually aligned with the app theme;
- free of hardcoded business text/data;
- free of repository/usecase/bloc dependencies;
- documented by clear naming and simple parameters.

## What not to put in shared

Do not move a widget to shared if it knows about:

- a specific feature entity such as `Movement`, `User`, `Invoice`;
- endpoint payloads or response models;
- business rules;
- feature-specific localized copy;
- navigation to a specific feature route.

Instead, split it:

- shared visual shell in `core/shared/widgets`;
- feature adapter/composition in `features/<feature>/presentation/widgets`.

## Agent workflow

When adding UI:

1. Search `core/shared/widgets` first.
2. Reuse existing widgets if they match the visual pattern.
3. If a new widget is app-wide reusable, create it in shared immediately.
4. If uncertain, keep it in the feature until a second usage appears.
5. Never duplicate buttons, fields, headers, loaders, or page containers without checking shared first.
