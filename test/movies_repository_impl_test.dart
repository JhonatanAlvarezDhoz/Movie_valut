import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_vault/core/database/cache_refresh_policy.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/network/api_client.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_remote_data_source.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/data/repositories/movies_repository_impl.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

void main() {
  late Directory tempDir;
  late MoviesLocalDataSource localDataSource;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp(
      'movie_vault_repo_hive_test_',
    );
    Hive.init(tempDir.path);
  });

  setUp(() async {
    localDataSource = MoviesLocalDataSource();
    final box = await Hive.openBox<dynamic>('movies_cache_box');
    await box.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('returns cached first page when network fails offline', () async {
    await localDataSource.saveMovies(
      MovieCategory.popular,
      [_movie(id: 10)],
      currentPage: 1,
      totalPages: 4,
    );

    final box = await Hive.openBox<dynamic>('movies_cache_box');
    await box.put('fetched_at.popular', DateTime.utc(2020).toIso8601String());

    final repository = MoviesRepositoryImpl(
      remoteDataSource: MoviesRemoteDataSource(_OfflineApiClient()),
      localDataSource: localDataSource,
      cacheRefreshPolicy: const CacheRefreshPolicy(),
    );

    final page = await repository.getMovies(MovieCategory.popular);

    expect(page.movies, hasLength(1));
    expect(page.movies.first.id, 10);
    expect(page.currentPage, 1);
    expect(page.totalPages, 4);
  });
}

MovieModel _movie({required int id}) {
  return MovieModel(
    id: id,
    title: 'Cached movie',
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    releaseDate: '2026-01-01',
    voteAverage: 8,
    categoryLabel: MovieCategory.popular.label,
  );
}

class _OfflineApiClient implements ApiClient {
  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    throw NetworkException('Sin conexión.');
  }

  @override
  Future<dynamic> patch(String path, {data}) => throw UnimplementedError();

  @override
  Future<dynamic> post(String path, {data}) => throw UnimplementedError();

  @override
  Future<dynamic> uploadImage(String path, String filePath) {
    throw UnimplementedError();
  }
}
