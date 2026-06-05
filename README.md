# Movie Vault

Aplicación Flutter para prueba técnica: autenticación con Firebase, consumo de TMDB, cache local con Hive, GetX para estado/navegación y arquitectura feature-first + Clean Architecture.

## Stack

- Flutter stable 3.41.6
- Dart 3.11.4
- Firebase Authentication
- TMDB API vía Dio
- Hive / Hive Flutter para cache y sesión local
- GetX para controladores, estado y navegación
- GetIt como composition root/DI
- cached_network_image mediante wrapper compartido

## Manual de ejecución

### 1. Verificar versión de Flutter

La entrega fue preparada para ejecutarse con Flutter stable `3.41.6`:

```sh
flutter --version
```

La salida esperada debe indicar:

```txt
Flutter 3.41.6 • channel stable
```

### 2. Configurar variables de entorno

Renombrá o copiá el archivo `.env.template` como `.env` en la raíz del proyecto:

```sh
cp .env.template .env
```

Luego completá el `.env` con las credenciales de TMDB proporcionadas en el correo donde se envía la prueba técnica:

```env
apiUrlTMDB=https://api.themoviedb.org/3
accessTokenTMDB=TOKEN_PROPORCIONADO
keyApiTMDB=API_KEY_PROPORCIONADA
ImageBaseOriginalUrlTMDB=https://image.tmdb.org/t/p/original
ImageBaseUpdateSizeUrlTMDB=https://image.tmdb.org/t/p/w500
```

> La app usa `accessTokenTMDB` como primera opción. Si no existe, usa `keyApiTMDB` como fallback.

### 3. Agregar configuración de Firebase

Los archivos de configuración de Firebase no están versionados. Serán enviados en un `.zip` adjunto en el correo de entrega de la prueba técnica.

Copiá cada archivo en su ubicación correspondiente:

```txt
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
lib/firebase_options.dart
```

Sin estos archivos, Firebase Authentication no podrá inicializarse correctamente.

### 4. Instalar dependencias

```sh
flutter pub get
```

### 5. Ejecutar la app

Con un emulador o dispositivo conectado:

```sh
flutter run
```

### 6. Validar antes de entregar

```sh
dart format lib test
flutter analyze
flutter test
```

## Arquitectura

La app sigue una estructura feature-first con separación por capas:

```txt
lib/
  app/                 # App root, bindings e inyección de dependencias
  core/                # Infraestructura reutilizable: network, errors, storage, theme, router, widgets
  features/
    auth/              # Firebase Auth + sesión local
    movies/            # TMDB + cache Hive + detalle + paginación
    settings/          # Cuenta, logout y preferencias de apariencia
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

El archivo `.env` no se versiona. Usá `.env.template` como base y completá los valores reales entregados por correo. Las claves leídas por `AppConfig` son:

```env
apiUrlTMDB=
accessTokenTMDB=
keyApiTMDB=
ImageBaseOriginalUrlTMDB=
ImageBaseUpdateSizeUrlTMDB=
```

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

### Settings

- Visualización de la cuenta autenticada.
- Cierre de sesión.
- Cambio entre modo claro y oscuro desde Ajustes.
- Persistencia local de la preferencia de tema.

### UI compartida

- `AppButton`
- `AppLoader`
- `AppLoadingView`
- `AppErrorView`
- `CachedRemoteImage`
- `CustomTextFormField`
- `PasswordField`
- `AuthBackground`
- `GlassCard`

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
