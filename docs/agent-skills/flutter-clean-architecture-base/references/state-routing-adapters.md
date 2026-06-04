# State management and routing adapters

This skill is package-agnostic. Respect the project's chosen tools.

## State manager adaptation

| Stack | Presentation unit | Dependency rule |
|---|---|---|
| Bloc/Cubit | `Bloc`, `Cubit`, `Event`, `State` | Bloc depends on usecases only. |
| Riverpod | `Notifier`, `AsyncNotifier`, providers | Providers expose usecases/controllers, not datasources to UI. |
| Provider/ChangeNotifier | `ChangeNotifier` | Notifier depends on usecases only. |
| GetX | Controller | Controller depends on usecases only; avoid global business state. |
| Vanilla | `ValueNotifier`/controller | Controller depends on usecases only. |

## State conventions

Every async flow needs clear states:

- initial/idle
- loading/submitting
- loaded/success
- failure

For mutations, prefer explicit flags or states that do not destroy loaded data.
Example: loaded data + `isSubmitting` + optional success/failure message.

## Routing adaptation

| Router | Rule |
|---|---|
| GoRouter | Route constants separate from route tree. Guards redirect based on domain/session state. |
| AutoRoute | Keep route declarations centralized. Do not inject feature internals into route config. |
| Navigator 1.0 | Keep route names/constants centralized. Avoid hardcoded strings in widgets. |

Route guards may check session/security state, but must not contain business workflows or direct HTTP calls.
