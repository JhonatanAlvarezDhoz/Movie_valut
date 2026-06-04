# Review checklist

Before finishing, verify:

## Architecture

- [ ] UI depends on state/usecases, not repositories or datasources.
- [ ] Domain has no Flutter, Dio, database, or storage imports.
- [ ] Data has no BuildContext/widgets/l10n UI concerns.
- [ ] Dependencies are registered in the composition root.

## Feature quality

- [ ] Files are small enough to read.
- [ ] Widgets are split by responsibility.
- [ ] Existing `core/shared/widgets` were checked before creating new UI.
- [ ] Reusable UI lives in `core/shared/widgets/<category>/`.
- [ ] Feature-specific widgets remain inside the feature.
- [ ] Request/response models are not used as domain entities unless intentionally trivial.

## Auth/session/storage

- [ ] Login/register call remote first and do not depend on local DB/cache.
- [ ] Tokens are stored only through the session storage abstraction.
- [ ] Secure secrets use secure storage; non-sensitive preferences use preferences storage.
- [ ] Refresh token logic is centralized in the auth/network interceptor or session service.
- [ ] Local persistence is hidden behind datasources/stores and does not leak Drift/Hive/Isar to domain or UI.

## Core errors

- [ ] Infrastructure/data throws controlled `AppException` subtypes, not generic exceptions.
- [ ] Endpoint-specific backend codes stay in feature `data/mappers/`, not core mapper.
- [ ] `ExceptionMapper` only maps reusable exceptions to failures.
- [ ] Usecases expose `Result<T>` and presentation consumes failures, not exceptions.

## Networking/errors

- [ ] Endpoints use the project ApiClient abstraction.
- [ ] Dio/HTTP package details do not leak outside infrastructure/data boundaries.
- [ ] Public auth endpoints skip bearer auth and refresh logic.
- [ ] Refresh retries once and cannot loop forever.
- [ ] ETags/cache metadata are GET-only and never block login/register.
- [ ] Multipart requests are not forced to JSON content type.
- [ ] Envelope/body/no-body cases are handled explicitly.
- [ ] Endpoint-specific errors are mapped in data mappers when non-trivial.
- [ ] Usecases return Result or the project equivalent.

## Responsive UI

- [ ] Responsive behavior targets phone/tablet only unless scope changed.
- [ ] Breakpoints/helpers come from `core/responsive`, not magic numbers in widgets.
- [ ] Standard pages use or consider `ResponsivePageContainer`.
- [ ] Tablet/landscape behavior improves readability and navigation.

## State/UI

- [ ] Loading, success, and failure are represented in state.
- [ ] Mutations do not wipe already loaded screen data unnecessarily.
- [ ] Navigation side effects use listener/effect mechanisms, not build methods.

## Validation

- [ ] Behavior changes have tests or a clear reason why not.
- [ ] Analyzer/formatter expectations are respected.
- [ ] Docs or agent guidelines are updated when a convention changes.
