import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_valut/core/logger/logger.dart';
import 'package:movie_valut/core/network/api_client.dart';
import 'package:movie_valut/core/network/dio_api_client.dart';
import 'package:movie_valut/core/network/init_dio.dart';
import 'package:movie_valut/core/storage/contracts/key_value_storage.dart';
import 'package:movie_valut/core/storage/contracts/object_serializer.dart';
import 'package:movie_valut/core/storage/contracts/secure_key_value_storage.dart';
import 'package:movie_valut/core/storage/serializers/json_serializer.dart';
import 'package:movie_valut/core/storage/services/app_storage_service.dart';
import 'package:movie_valut/core/storage/services/preferences_storage_service.dart';
import 'package:movie_valut/core/storage/services/secure_storage_service.dart';
import 'package:movie_valut/core/storage/services/session_storage_service.dart';
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
    );
}
