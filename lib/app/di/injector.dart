import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_vault/features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import 'package:movie_vault/features/auth/data/datasources/hive_auth_local_data_source.dart';
import 'package:movie_vault/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:movie_vault/features/auth/domain/repositories/auth_repository.dart';
import 'package:movie_vault/features/auth/domain/usecases/get_current_session_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/login_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/logout_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:movie_vault/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';
import 'package:movie_vault/core/database/cache_refresh_policy.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movie_vault/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movie_vault/features/movies/domain/repositories/movies_repository.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movie_detail_use_case.dart';
import 'package:movie_vault/features/movies/domain/usecases/get_movies_use_case.dart';
import 'package:movie_vault/features/movies/presentation/controllers/movies_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_vault/core/logger/logger.dart';
import 'package:movie_vault/core/network/api_client.dart';
import 'package:movie_vault/core/network/dio_api_client.dart';
import 'package:movie_vault/core/network/init_dio.dart';
import 'package:movie_vault/core/storage/contracts/key_value_storage.dart';
import 'package:movie_vault/core/storage/contracts/object_serializer.dart';
import 'package:movie_vault/core/storage/serializers/json_serializer.dart';
import 'package:movie_vault/core/storage/services/app_storage_service.dart';
import 'package:movie_vault/core/storage/services/preferences_storage_service.dart';
import 'package:movie_vault/core/themes/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Global service locator used as the composition root.
final serviceLocator = GetIt.instance;

/// Builds the dependency graph from infrastructure to presentation.
///
/// Registration order matters:
/// 1. core services and clients;
/// 2. data sources;
/// 3. repositories;
/// 4. use cases;
/// 5. GetX controllers.
///
/// Keeping this graph centralized prevents widgets from creating Firebase,
/// Dio, Hive, storage or repository dependencies directly.
Future<void> initDependencies() async {
  if (serviceLocator.isRegistered<AppLogger>()) {
    return;
  }

  final preferences = await SharedPreferences.getInstance();

  serviceLocator
    ..registerLazySingleton<AppLogger>(AppLogger.new)
    ..registerLazySingleton<ObjectSerializer>(JsonSerializer.new)
    ..registerLazySingleton<KeyValueStorage>(
      () => PreferencesStorageService(preferences),
    )
    ..registerLazySingleton<AppStorageService>(
      () => AppStorageService(
        serviceLocator<KeyValueStorage>(),
        serviceLocator<ObjectSerializer>(),
      ),
    )
    ..registerLazySingleton<ThemeController>(
      () => ThemeController(serviceLocator<AppStorageService>()),
    )
    ..registerLazySingleton<Dio>(
      () => buildDio(logger: serviceLocator<AppLogger>()),
    )
    ..registerLazySingleton<ApiClient>(
      () => DioApiClient(serviceLocator<Dio>(), serviceLocator<AppLogger>()),
    )
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseAuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSource(serviceLocator<FirebaseAuth>()),
    )
    ..registerLazySingleton<HiveAuthLocalDataSource>(
      HiveAuthLocalDataSource.new,
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator<FirebaseAuthRemoteDataSource>(),
        localDataSource: serviceLocator<HiveAuthLocalDataSource>(),
      ),
    )
    ..registerLazySingleton<LoginUserUseCase>(
      () => LoginUserUseCase(serviceLocator<AuthRepository>()),
    )
    ..registerLazySingleton<RegisterUserUseCase>(
      () => RegisterUserUseCase(serviceLocator<AuthRepository>()),
    )
    ..registerLazySingleton<LogoutUserUseCase>(
      () => LogoutUserUseCase(serviceLocator<AuthRepository>()),
    )
    ..registerLazySingleton<GetCurrentSessionUseCase>(
      () => GetCurrentSessionUseCase(serviceLocator<AuthRepository>()),
    )
    ..registerLazySingleton<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(serviceLocator<AuthRepository>()),
    )
    ..registerFactory<AuthController>(
      () => AuthController(
        loginUserUseCase: serviceLocator<LoginUserUseCase>(),
        registerUserUseCase: serviceLocator<RegisterUserUseCase>(),
        logoutUserUseCase: serviceLocator<LogoutUserUseCase>(),
        getCurrentSessionUseCase: serviceLocator<GetCurrentSessionUseCase>(),
        resetPasswordUseCase: serviceLocator<ResetPasswordUseCase>(),
      ),
    )
    ..registerLazySingleton<CacheRefreshPolicy>(CacheRefreshPolicy.new)
    ..registerLazySingleton<MoviesRemoteDataSource>(
      () => MoviesRemoteDataSource(serviceLocator<ApiClient>()),
    )
    ..registerLazySingleton<MoviesLocalDataSource>(MoviesLocalDataSource.new)
    ..registerLazySingleton<MoviesRepository>(
      () => MoviesRepositoryImpl(
        remoteDataSource: serviceLocator<MoviesRemoteDataSource>(),
        localDataSource: serviceLocator<MoviesLocalDataSource>(),
        cacheRefreshPolicy: serviceLocator<CacheRefreshPolicy>(),
      ),
    )
    ..registerLazySingleton<GetMoviesUseCase>(
      () => GetMoviesUseCase(serviceLocator<MoviesRepository>()),
    )
    ..registerLazySingleton<GetMovieDetailUseCase>(
      () => GetMovieDetailUseCase(serviceLocator<MoviesRepository>()),
    )
    ..registerFactory<MoviesController>(
      () => MoviesController(
        getMoviesUseCase: serviceLocator<GetMoviesUseCase>(),
        getMovieDetailUseCase: serviceLocator<GetMovieDetailUseCase>(),
      ),
    );
}
