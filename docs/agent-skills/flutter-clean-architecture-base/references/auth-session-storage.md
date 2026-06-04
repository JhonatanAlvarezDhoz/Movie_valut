# Auth, session, storage, and local persistence

Auth and persistence are security-sensitive. Do not improvise them inside widgets, blocs, controllers, or feature repositories.

## Login/register flow

Login and register must be remote-first:

```txt
Login/Register UI
  → Auth state manager
  → Auth usecase
  → Auth repository
  → Auth remote datasource
  → ApiClient
  → SessionStorageService saves session
```

Rules:

- `auth/login` and `auth/register` must not depend on Drift/Hive/Isar/cache to complete.
- Save tokens only after a successful remote response.
- After saving session, navigate or load profile according to the project flow.
- Profile loading must not block session persistence unless the product explicitly requires it.
- Do not read/write tokens directly from UI or state managers.

## Token storage

Use one session abstraction, commonly:

```txt
core/storage/services/session_storage_service.dart
```

It owns:

- access token
- refresh token
- expiration metadata
- current session state
- session cleanup
- refresh-session persistence

Never scatter token logic across repositories, blocs, route guards, or widgets.

## SecureStorage vs SharedPreferences

| Data | Storage |
|---|---|
| Access token | Secure storage/session service |
| Refresh token | Secure storage/session service |
| Security flags tied to session | Secure storage or session service |
| Theme, language, onboarding flag | SharedPreferences/preferences service |
| Cached business data | Local database through datasource/store |
| ETags/cache metadata | Local store/database, isolated from login/register |

If data can grant access or impersonate a user, treat it as secret.

## Refresh token

Refresh must be centralized, usually in:

```txt
core/network/interceptors/auth_interceptor.dart
```

Rules:

- Ignore auth/refresh handling for public endpoints: login, register, refresh.
- On protected request with expired/invalid access token, refresh once.
- Persist the new session through `SessionStorageService`.
- Retry the original request after refresh.
- If refresh fails, clear session and force login.
- Avoid infinite retry loops.

## Route guards

Route guards can check session status, but must not perform full business workflows.

Allowed:

- Is there a valid/recoverable session?
- Is biometric unlock required?
- Should user be redirected to login?

Not allowed:

- Calling login/register endpoints.
- Parsing backend responses.
- Writing tokens directly.
- Running feature-specific usecases unrelated to navigation.

## Local persistence: Drift, Hive, Isar, SQLite

The app must be persistence-package agnostic outside data/core infrastructure.

```txt
Feature repository
  → Feature local datasource/store interface
  → Drift/Hive/Isar implementation
```

Rules:

- Domain must not import Drift/Hive/Isar/SQLite types.
- Presentation must not import Drift/Hive/Isar/SQLite types.
- Repositories may coordinate local + remote, but package-specific code stays in datasources/stores.
- Migration from one DB package to another should mainly touch `core/database`, stores, and local datasources.

## Offline-first feature flow

For features that support offline mode:

1. Try local data first when the screen needs immediate content.
2. Fetch remote when network is available.
3. Save remote response locally.
4. Return domain entities to the usecase/UI.
5. Keep sync metadata in a dedicated sync store/service.

Do not mix sync metadata into UI widgets.

## Agent warning signs

Stop and refactor if you see:

- Token read/write outside `SessionStorageService`.
- Login blocked because local DB/cache failed.
- Drift/Hive/Isar imports in domain or presentation.
- Refresh token logic duplicated in repositories.
- Route guard doing HTTP calls directly.
- SharedPreferences used for secrets.
