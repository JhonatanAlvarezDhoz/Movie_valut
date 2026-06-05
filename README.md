# Movie Vault

Aplicación Flutter para prueba técnica: autenticación con Firebase, consumo de TMDB, cache local con Hive, GetX para estado/navegación y arquitectura feature-first + Clean Architecture.

## Stack

- Flutter 3.x+
- Firebase Authentication
- TMDB API vía Dio
- Hive / Hive Flutter para cache y sesión local
- GetX para controladores, estado y navegación
- GetIt como composition root/DI
- cached_network_image mediante wrapper compartido

## Arquitectura

La app sigue una estructura feature-first con separación por capas:

```txt
lib/
  app/                 # App root, bindings e inyección de dependencias
  core/                # Infraestructura reutilizable: network, errors, storage, theme, router, widgets
  features/
    auth/              # Firebase Auth + sesión local
    movies/            # TMDB + cache Hive + detalle + paginación
    settings/          # Logout/configuración simple
    splash/            # Resolución inicial de sesión
    user/              # Cuenta actual
```

Reglas principales:

- `presentation` depende de controladores/usecases, no de Dio, Hive ni Firebase.
- `domain` no importa Flutter, Dio, Hive ni modelos JSON.
- `data` convierte Firebase/TMDB/Hive en entidades de dominio.
- Los usecases devuelven `Result<T>`.
- Los errores fluyen como `AppException → ExceptionMapper → Failure → ResultFailure`.
- Las imágenes remotas se renderizan con `CachedRemoteImage`, no con `Image.network`.

## Variables de entorno

El archivo `.env` debe existir en la raíz y contener las claves de TMDB usadas por `AppConfig`:

```env
apiUrlTMDB=...
accessTokenTMDB=...
keyApiTMDB=...
ImageBaseOriginalUrlTMDB=...
ImageBaseUpdateSizeUrlTMDB=...
```

> No subas tokens reales a repositorios públicos.

## Funcionalidad implementada

### Auth

- Registro con correo/contraseña.
- Login con Firebase Authentication.
- Logout.
- Validación de formularios.
- Sesión local con Hive después de autenticación remota exitosa.
- Splash decide si ir a login o home según sesión.

### Movies

- Categorías TMDB:
  - Populares
  - En cartelera
  - Próximas
- Cache local por categoría con Hive.
- Refresh cada 12 horas.
- Fallback offline para la primera página cacheada.
- Paginación por categoría.
- Deduplicación por `movie.id`.
- Detalle con poster Hero, backdrop, descripción, géneros y elenco.

### UI compartida

- `AppButton`
- `AppLoader`
- `AppLoadingView`
- `AppErrorView`
- `CachedRemoteImage`
- `CustomTextFormField`
- `PasswordField`
- `ResponsivePageContainer`

## Comandos de validación

Este proyecto no requiere build para revisar la entrega. Usá:

```sh
dart format lib test
flutter analyze
flutter test
```

## Tests relevantes

- Usecases de auth.
- Usecases de movies.
- Mappers/modelos TMDB.
- `ExceptionMapper`.
- Deduplicación Hive.
- Fallback offline de repository.
- Política de refresh de cache.

## Decisiones técnicas

- Login/register son remote-first: Hive no autentica usuarios, solo persiste sesión después del éxito remoto.
- TMDB no usa ETag en esta app; el refresh se controla con una política local de 12 horas.
- La paginación vive en dominio como `MoviePage`, no como estado accidental de la UI.
- El repository coordina remote/local/offline; la UI solo consume estado y mensajes.
- La app está restringida a portrait.
