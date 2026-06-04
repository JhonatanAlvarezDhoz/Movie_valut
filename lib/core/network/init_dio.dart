import 'dart:io';

import 'package:dio/dio.dart';
import 'package:movie_valut/core/config/app_config.dart';
import 'package:movie_valut/core/logger/log_interceptor.dart';
import 'package:movie_valut/core/logger/logger.dart';
import 'package:movie_valut/core/network/interceptors/network_headers_interceptor.dart';
import 'package:movie_valut/core/network/interceptors/tmdb_auth_interceptor.dart';

Dio buildDio({required AppLogger logger}) {
  return Dio(
      BaseOptions(
        baseUrl: AppConfig.tmdbApiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) {
          if (status == null) return false;
          return status >= HttpStatus.ok && status < HttpStatus.multipleChoices;
        },
      ),
    )
    ..interceptors.addAll([
      NetworkHeadersInterceptor(logger),
      const TmdbAuthInterceptor(),
      LoggingInterceptor(logger),
    ]);
}
