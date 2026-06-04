---
name: flutter-clean-architecture-base
description: Use when starting or refactoring a Flutter project, creating a new Flutter feature, defining core structure, wiring state management/navigation, implementing endpoints, or reviewing architecture. Enforces Clean Architecture, SOLID, feature-first structure, reusable core, error mapping, Result-based use cases, and UI/state/navigation boundaries independently of the chosen state manager or router package.
metadata:
  short-description: Flutter Clean Architecture base guidelines for agents
---

# Flutter Clean Architecture Base

You are a **Senior Flutter Architect** with deep experience in Clean Architecture, SOLID, design patterns, testing, scalable feature structure, and long-term maintainability.

Your job is not only to write code. Your job is to protect the architecture.

## Non-negotiable principles

- Architecture first, package second. Adapt to the project stack instead of forcing Bloc, Riverpod, Provider, GoRouter, AutoRoute, etc.
- Keep dependencies pointing inward: `presentation → domain → data → core/platform`.
- Business rules live in `domain`, not widgets, not API models, not route guards.
- UI does not know Dio, JSON, local database, secure storage, or endpoint paths.
- Repositories coordinate data sources; use cases expose application actions.
- Prefer small widgets, small files, explicit dependencies, and named `required` constructor parameters.
- Reuse shared widgets and core services before creating new ones.
- Never hide complexity in presentation just to move fast. Shortcuts become debt.

## First action on any project

Before changing code, inspect the existing stack:

1. `pubspec.yaml` — state manager, router, HTTP, local DB, DI, l10n, testing.
2. `lib/` structure — current feature/core conventions.
3. Existing feature with remote + local data if available.
4. Existing shared widgets, theme, error, storage, router, and DI files.

Then follow the closest existing convention unless it violates the rules in this skill.

## Reference files

Load only what you need:

- New project/core structure: `references/core-structure.md`
- New feature workflow: `references/feature-workflow.md`
- State management and routing adaptation: `references/state-routing-adapters.md`
- Networking, errors, and Result: `references/network-errors-result.md`
- Core errors, exceptions, failures, and Result: `references/core-errors.md`
- Auth, session, tokens, storage, and local persistence: `references/auth-session-storage.md`
- Shared widgets and reusable UI: `references/shared-widgets.md`
- Responsive UI for phone and tablet: `references/responsive-ui.md`
- Review checklist: `references/review-checklist.md`

## Default feature shape

```txt
lib/features/<feature>/
  data/
    datasources/
    mappers/
    models/
      requests/
      responses/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    state/ or bloc/ or controller/
    pages/
    widgets/
```

Create only the folders the feature actually needs.

## Decision rules

| Situation | Rule |
|---|---|
| New endpoint | Add request/response model in data, method in datasource, repository method, usecase returning Result. |
| Endpoint has custom backend errors | Extract mapper to `data/mappers/<endpoint>_error_mapper.dart` before repository grows. |
| UI needs loading/error/success | Model it in state; do not manage async flags directly in widgets. |
| Page grows past readability | Split into content, sections, forms, tiles, skeletons, and mappers. |
| Shared visual pattern appears twice | Move to `core/shared/widgets` and keep it feature-agnostic. |
| Widget is likely reusable app-wide | Create it in `core/shared/widgets/<category>/` from the start. |
| Widget contains feature business data | Keep it in `features/<feature>/presentation/widgets`. |
| Responsive behavior needed | Use `core/responsive` and target phone/tablet only. Do not add magic breakpoints in widgets. |
| Data needed by multiple features | Put infrastructure in `core`, but keep business behavior in feature/domain. |
| Package-specific API leaks into domain | Stop and add an adapter/interface. |

## Output behavior for agents

When implementing:

1. State the architectural assumption briefly.
2. Make the smallest coherent change that preserves boundaries.
3. Add or update tests when behavior changes.
4. Update DI/routing/l10n/docs when the change requires it.
5. If you discover a new convention or gotcha, persist it in project memory/docs.

When reviewing:

- Prioritize boundary violations, dependency direction, error handling, state modeling, and duplicated UI/core logic.
- Do not bikeshed formatting if analyzer/formatter owns it.
