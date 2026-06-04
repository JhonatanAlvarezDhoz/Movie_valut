# Core structure

Use `core/` for cross-cutting infrastructure, not feature-specific business logic.

## Suggested layout

```txt
lib/core/
  constants/
  database/
  errors/
    exceptions/
    failures/
    mappers/
  extensions/
  l10n/
  network/
    interceptors/
  router/
  shared/
    widgets/
      button/
      fields/
      header/
  storage/
  sync/
  themes/
  utils/
```

## Rules

- `core/network` owns HTTP client, interceptors, envelope parsing helpers, and transport concerns.
- `core/storage` owns secure/session/local preference services.
- `core/database` owns database setup and generic DAOs/stores.
- `core/errors` owns base exceptions, failures, and global exception-to-failure mapping.
- `core/shared/widgets` owns reusable visual components only.
- Avoid dumping feature-specific constants into core unless they are genuinely shared.

## Composition root

Use a single DI entry point such as:

```txt
lib/app/di/injector.dart
```

Register dependencies from infrastructure inward:

1. Core services.
2. Datasources.
3. Repositories.
4. Usecases.
5. Presentation state objects/controllers/blocs.

Prefer named required constructors so DI is self-documenting.
