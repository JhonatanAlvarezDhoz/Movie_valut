# Revisión final — Movie Vault

Basada en `docs/agent-skills/flutter-clean-architecture-base/references/review-checklist.md`.

## Arquitectura

- [x] UI depende de GetX controllers/usecases, no de repositories/datasources.
- [x] Domain no importa Flutter, Dio, Hive, Firebase ni modelos JSON.
- [x] Data no usa `BuildContext` ni widgets.
- [x] Dependencias registradas en `lib/app/di/injector.dart`.

## Features

- [x] Auth separado en `presentation`, `domain`, `data`.
- [x] Movies separado en `presentation`, `domain`, `data`.
- [x] Widgets reutilizables movidos a `core/shared/widgets`.
- [x] Widgets específicos de películas permanecen en `features/movies/presentation/widgets`.

## Auth / sesión / storage

- [x] Login/register llaman Firebase primero.
- [x] Hive solo guarda sesión después de éxito remoto.
- [x] Session storage queda encapsulado detrás de datasources/repository.
- [x] Logout mapea errores controlados.

## Errores

- [x] Infra/data arroja `AppException` controladas.
- [x] Usecases transforman excepciones con `ExceptionMapper`.
- [x] Presentation consume `ResultSuccess` / `ResultFailure`.
- [x] UI muestra mensajes claros desde `Failure.message`.

## Network / offline

- [x] Features usan `ApiClient`, no Dio directamente.
- [x] TMDB endpoints están en datasource/category, no en UI.
- [x] Repository coordina TMDB + Hive + fallback offline.
- [x] Cache local deduplica por TMDB id.
- [x] Paginación mantiene `currentPage` y `totalPages`.

## UI / responsive

- [x] App restringida a portrait.
- [x] No se usa `Image.network`; se usa `CachedRemoteImage`.
- [x] Loading/error states usan widgets compartidos.
- [x] Páginas principales tienen estados loading, empty y error.

## Validación

- [x] `dart format lib test`
- [x] `flutter analyze`
- [x] `flutter test`
