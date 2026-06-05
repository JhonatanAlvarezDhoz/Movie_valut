import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_vault/features/movies/data/datasources/movies_local_data_source.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

void main() {
  late Directory tempDir;
  late MoviesLocalDataSource dataSource;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('movie_vault_hive_test_');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    dataSource = MoviesLocalDataSource();
    final box = await Hive.openBox<dynamic>('movies_cache_box');
    await box.clear();
  });

  tearDownAll(() async {
    await Hive.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('saveMovies avoids duplicated movies by TMDB id', () async {
    await dataSource.saveMovies(
      MovieCategory.popular,
      [
        _movie(id: 1, title: 'First version'),
        _movie(id: 1, title: 'Updated version'),
        _movie(id: 2, title: 'Second movie'),
      ],
      currentPage: 1,
      totalPages: 3,
    );

    final cache = await dataSource.readMovies(MovieCategory.popular);

    expect(cache, isNotNull);
    expect(cache!.movies, hasLength(2));
    expect(cache.movies.map((movie) => movie.id), [1, 2]);
    expect(cache.movies.first.title, 'Updated version');
    expect(cache.currentPage, 1);
    expect(cache.totalPages, 3);
  });
}

MovieModel _movie({required int id, required String title}) {
  return MovieModel(
    id: id,
    title: title,
    overview: 'Overview',
    posterPath: '/poster.jpg',
    backdropPath: '/backdrop.jpg',
    releaseDate: '2026-01-01',
    voteAverage: 8,
    categoryLabel: MovieCategory.popular.label,
  );
}
