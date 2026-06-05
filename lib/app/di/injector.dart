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
import 'package:movie_vault/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_vault/core/logger/logger.dart';
import 'package:movie_vault/core/network/api_client.dart';
import 'package:movie_vault/core/network/dio_api_client.dart';
import 'package:movie_vault/core/network/init_dio.dart';
import 'package:movie_vault/core/storage/contracts/key_value_storage.dart';
import 'package:movie_vault/core/storage/contracts/object_serializer.dart';
import 'package:movie_vault/core/storage/contracts/secure_key_value_storage.dart';
import 'package:movie_vault/core/storage/serializers/json_serializer.dart';
import 'package:movie_vault/core/storage/services/app_storage_service.dart';
import 'package:movie_vault/core/storage/services/preferences_storage_service.dart';
import 'package:movie_vault/core/storage/services/secure_storage_service.dart';
import 'package:movie_vault/core/storage/services/session_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

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
    ..registerLazySingleton<SecureKeyValueStorage>(
      () => const SecureStorageService(FlutterSecureStorage()),
    )
    ..registerLazySingleton<SessionStorageService>(
      () => SessionStorageService(serviceLocator<SecureKeyValueStorage>()),
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
    ..registerFactory<AuthController>(
      () => AuthController(
        loginUserUseCase: serviceLocator<LoginUserUseCase>(),
        registerUserUseCase: serviceLocator<RegisterUserUseCase>(),
        logoutUserUseCase: serviceLocator<LogoutUserUseCase>(),
        getCurrentSessionUseCase: serviceLocator<GetCurrentSessionUseCase>(),
      ),
    );
}
