# Networking, errors, and Result

Networking is infrastructure. Keep it centralized, predictable, and invisible to UI/domain.

## Golden path

```txt
UI
  → State manager
  → UseCase
  → Repository interface
  → Repository implementation
  → DataSource
  → ApiClient
  → Dio / HTTP package
```

Rules:

- UI never calls `ApiClient`, Dio, or endpoint paths directly.
- Domain never imports Dio, HTTP responses, API models, database/cache types, or Flutter UI.
- Data sources are the boundary where transport responses become data models.
- Repositories coordinate remote/local sources and map data models to domain entities.
- Usecases return `Result<T>` or the project's equivalent success/failure wrapper.

## Core network responsibilities

| Component | Responsibility |
|---|---|
| `ApiClient` | Project HTTP abstraction. Features depend on this, never Dio directly. |
| `DioApiClient` or equivalent | Transport implementation, retry rules, basic transport exception mapping. |
| `ApiResponseEnvelope` | Parse and validate backend envelope: `statusCode`, `message`, `isSuccess`, `data`. |
| Auth interceptor | Add bearer token, refresh on `401`, retry original request once, clear session on refresh failure. |
| Headers/cache interceptor | Default content type, ETags, cache headers, request metadata. |
| Logging interceptor | Log request/response/errors without owning business behavior. |

## Dio/client rules

If the project uses Dio, keep Dio inside `core/network`.

Recommended behavior:

- Accept `2xx` status codes.
- Accept `304 Not Modified` only when the app supports ETag/cache.
- Do not retry `4xx` client errors; those must reach data/repository mapping.
- Retry transient network/server failures with a small bounded retry count.
- Map network failures to controlled exceptions such as `NetworkException`.
- Map `5xx` to controlled server exceptions.
- Never expose raw `DioException` to domain or presentation.

## Interceptor order

Use a deliberate order. Example:

```txt
NetworkHeadersInterceptor
AuthInterceptor
LoggingInterceptor
```

Why:

1. Headers/cache are applied first.
2. Auth adds or refreshes credentials.
3. Logging observes the final request/response.

Do not mix responsibilities. Auth, cache headers, and logging are separate concerns.

## Auth and refresh token

Auth interceptor responsibilities:

- Add `Authorization: Bearer <accessToken>` to protected requests.
- Skip auth for public/session endpoints such as:
  - `auth/login`
  - `auth/register`
  - `auth/refresh`
- On `401`, call refresh once using the refresh token.
- Persist new tokens only through the session storage abstraction.
- Retry the original request once.
- Prevent infinite loops using request metadata/flags.
- Clear session and force login if refresh fails.

Do not implement refresh token logic inside feature repositories, pages, blocs, notifiers, or route guards.

## ETags and cache headers

ETags are for cacheable reads only.

Rules:

- Apply `If-None-Match` only to `GET` requests.
- Save returned `ETag` only from `GET` responses.
- Do not touch local cache/DB/SyncMetadataStore for `POST auth/login` or `POST auth/register`.
- A `304` response must be represented explicitly, for example `{ notModified: true }`, so the datasource/repository can read local data.

This rule is critical: login/register must be remote-first and must not depend on local persistence.

## Content-Type and uploads

Default JSON content type can be centralized in the headers interceptor.

Rules:

- Apply JSON content type by default.
- Do not override explicit content type.
- Do not force JSON content type for multipart/form-data uploads.
- Provide a request metadata flag for exceptional cases, for example `skipDefaultJsonContentType`.

## Backend envelope

When the backend uses an envelope like:

```json
{
  "statusCode": 200,
  "message": "OK",
  "isSuccess": true,
  "data": {}
}
```

Datasources must:

1. Parse the envelope.
2. Check `isSuccess`.
3. Validate the shape of `data`.
4. Convert `data` to a response model.
5. Throw controlled parsing/server exceptions when shape is unexpected.

Do not parse envelope in widgets or state managers.

## GET response shape

If `ApiClient.get` returns cache metadata, document and handle it explicitly.

Example shape:

```dart
{
  'data': response.data,
  'notModified': false,
}
```

For `304`:

```dart
{
  'notModified': true,
}
```

Datasource/repository must decide whether to parse remote data or use local cached data.

## POST/PATCH with response body

Use this when the backend returns useful data.

```txt
Request model → ApiClient.post/patch → envelope → response model → domain entity → ResultSuccess(entity)
```

Rules:

- Request model serializes payload.
- Datasource sends request through `ApiClient`.
- Datasource parses envelope/body into response model.
- Repository maps response model to domain entity.
- Usecase wraps success in `ResultSuccess`.

## POST/PATCH without response body

Use this when the backend only confirms success.

Rules:

- Use `Future<void>` in repository/usecase when the UI only needs success/failure.
- Use a small domain success type only if UI needs metadata.
- Still validate status/envelope before returning success.
- Usecase returns `ResultSuccess<void>` or project equivalent.

## Error mapping boundaries

Keep mapping responsibilities separated:

1. Network/client layer maps transport errors into base exceptions.
2. Endpoint mapper maps backend `code/message/status/data` into controlled `AppException`.
3. Usecase maps exceptions into `Failure` through the global exception mapper.
4. UI renders `Failure.message` or localizes known failure codes.

Mapper in data returns/throws exceptions, not failures.

## Endpoint error mappers

Extract to `features/<feature>/data/mappers/` when:

- The repository has more than 2-3 endpoint-specific error branches.
- Multiple endpoints in the feature share backend codes.
- Error mapping needs `statusCode + message + data.code + traceId`.
- The same mapping needs tests.

Naming:

```txt
features/<feature>/data/mappers/<endpoint>_error_mapper.dart
features/<feature>/data/mappers/<feature>_error_mapper.dart
```

## Local/offline coordination

Repositories may coordinate remote and local sources.

Rules:

- Remote datasource knows HTTP only.
- Local datasource/store knows Drift/Hive/Isar/SQLite only.
- Repository decides offline fallback and cache updates.
- Domain receives entities, never DB rows or response DTOs.
- Sync metadata/ETags live in dedicated stores, not UI.

## Agent anti-regression checklist

Before finishing network work, verify:

- [ ] No Dio import outside `core/network` unless the project explicitly allows it for infrastructure.
- [ ] No endpoint path hardcoded in UI.
- [ ] Login/register do not touch local DB/cache before remote response.
- [ ] Auth interceptor skips login/register/refresh.
- [ ] Refresh retries the original request once and cannot loop forever.
- [ ] Tokens are persisted only through session storage.
- [ ] ETags are GET-only.
- [ ] Multipart upload does not get forced JSON content type.
- [ ] Datasources validate envelope/data shape.
- [ ] Endpoint-specific backend errors are mapped in data mappers when non-trivial.
- [ ] Usecases return `Result`, not raw exceptions.
