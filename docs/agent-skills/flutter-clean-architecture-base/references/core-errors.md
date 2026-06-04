# Core errors, exceptions, failures, and Result

Errors are architecture boundaries. Do not treat them as strings thrown randomly across the app.

## Current structure

```txt
lib/core/errors/
  exceptions/
    exception.dart
    exceptions.dart
  failures/
    failure.dart
    failures.dart
  handler/
    error_handler.dart
  mapper/
    mapper_error.dart
  result.dart
```

## Responsibility map

| File/folder | Responsibility |
|---|---|
| `exceptions/` | Controlled technical/backend/local exceptions thrown by infrastructure/data. |
| `failures/` | User-facing/domain-facing failures consumed by usecases, state, and UI. |
| `mapper/mapper_error.dart` | Global `Exception → Failure` mapping. |
| `handler/error_handler.dart` | Centralized fallback handling/logging for uncaught errors. |
| `result.dart` | Explicit success/failure wrapper returned by usecases. |

## Flow

```txt
Dio / backend / cache / parser
  → AppException subtype
  → ExceptionMapper
  → Failure subtype
  → ResultFailure
  → State failure
  → UI message
```

## Exceptions

Exceptions belong to infrastructure/data boundaries.

Use controlled exceptions such as:

- `NetworkException`
- `ServerException`
- `ValidationException`
- `UnauthorizedException`
- `ConflictException`
- `ParsingException`
- `NotModifiedException`
- `CacheException`

Rules:

- Do not throw generic `Exception('...')` when an `AppException` subtype exists.
- Add a new exception only when it represents a reusable error category.
- Endpoint-specific backend codes usually map to existing exception types with specific messages/codes.
- Raw `DioException`, SQL exceptions, parsing errors, or storage exceptions must not reach presentation.

## Failures

Failures are what usecases expose to presentation through `ResultFailure`.

Use failures such as:

- `NetworkFailure`
- `ServerFailure`
- `ValidationFailure`
- `UnauthorizedFailure`
- `ConflictFailure`
- `CacheFailure`
- `UnknownFailure`

Rules:

- UI should consume failures, not exceptions.
- Bloc/controller/notifier should not catch `DioException`.
- Do not create a failure for every backend message. Prefer stable failure categories plus message/code.

## ExceptionMapper

`ExceptionMapper` maps controlled exceptions to failures.

Rules:

- Keep this mapper global and generic.
- Do not put endpoint-specific backend codes here.
- Add mapping here only when a new reusable `AppException` subtype is introduced.
- Unknown/unmapped exceptions become `UnknownFailure`.

## Endpoint mappers vs core mapper

| Mapper | Location | Converts |
|---|---|---|
| Endpoint mapper | `features/<feature>/data/mappers/` | Backend response/code/message → `AppException` |
| Core exception mapper | `core/errors/mapper/mapper_error.dart` | `AppException` → `Failure` |

Endpoint mappers must return or throw exceptions, not failures.

Correct:

```dart
return ValidationException('password.too_common');
```

Incorrect:

```dart
return ValidationFailure('password.too_common');
```

## Result

Usecases expose `Result<T>` so presentation does not need try/catch.

Pattern:

```dart
Future<Result<MyEntity>> call() async {
  try {
    final value = await _repository.doWork();
    return ResultSuccess(value);
  } catch (error) {
    if (error is Exception) {
      return ResultFailure(ExceptionMapper.map(error));
    }

    return const ResultFailure(UnknownFailure());
  }
}
```

Rules:

- Repositories may throw controlled exceptions.
- Usecases catch exceptions and return `Result`.
- UI/state managers switch on `ResultSuccess` / `ResultFailure`.
- Do not return nullable data to represent errors.

## Agent warning signs

Stop and refactor if you see:

- `DioException` caught in UI/state.
- `throw Exception(...)` in data/core where controlled exception exists.
- `Failure` returned from datasource/repository error mapper.
- Backend error codes inside Bloc/page.
- Endpoint-specific mapping added to `core/errors/mapper/mapper_error.dart`.
- Usecase returning raw entity and forcing Bloc/UI to catch errors.
