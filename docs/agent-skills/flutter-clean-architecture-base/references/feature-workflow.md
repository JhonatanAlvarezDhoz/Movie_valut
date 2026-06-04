# New feature workflow

A feature is a vertical slice of business capability. Start from domain intent, then wire data and presentation.

## Steps

1. Define domain entity.
2. Define repository interface in domain.
3. Define usecase returning `Result<T>` or the project's equivalent.
4. Add request/response models in data if backend is involved.
5. Add datasource for remote/local/platform access.
6. Implement repository.
7. Add endpoint-specific error mapper if needed.
8. Add state/controller/bloc/notifier according to the project stack.
9. Build page and small widgets.
10. Register DI.
11. Add route if there is a screen.
12. Add tests for behavior and mapping.

## Layer responsibilities

| Layer | Can know | Must not know |
|---|---|---|
| Presentation | UI framework, state manager, domain usecases/entities | Dio, JSON, SQL, secure storage, endpoint paths |
| Domain | Entities, repository contracts, usecase orchestration | Flutter, Dio, database, API response models |
| Data | API models, datasources, repository implementations | BuildContext, widgets, localized UI strings |
| Core | Reusable infrastructure | Feature-specific business workflows |

## Naming

- Entity: `User`, `Movement`, `SecuritySetting`.
- Repository interface: `<Feature>Repository`.
- Repository impl: `<Feature>RepositoryImpl`.
- Usecase: `<Verb><Thing>UseCase`.
- Remote datasource: `<Feature>RemoteDataSource` / `Api<Feature>RemoteDataSource`.
- Local datasource: `<Feature>LocalDataSource` / `Drift<Feature>LocalDataSource`.
- Error mapper: `<Endpoint>ErrorMapper` or `<Feature>ErrorMapper`.
