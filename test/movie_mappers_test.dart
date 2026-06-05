import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/features/movies/data/models/cast_member_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_detail_model.dart';
import 'package:movie_vault/features/movies/data/models/movie_model.dart';
import 'package:movie_vault/features/movies/domain/entities/movie_category.dart';

void main() {
  test('MovieModel maps TMDB movie JSON and preserves category label', () {
    final movie = MovieModel.fromJson({
      'id': 7,
      'title': 'Seven',
      'overview': 'Overview',
      'poster_path': '/poster.jpg',
      'backdrop_path': '/backdrop.jpg',
      'release_date': '1995-09-22',
      'vote_average': 8.3,
    }, categoryLabel: MovieCategory.popular.label);

    expect(movie.id, 7);
    expect(movie.title, 'Seven');
    expect(movie.categoryLabel, MovieCategory.popular.label);
    expect(movie.toJson()['category_label'], MovieCategory.popular.label);
  });

  test('CastMemberModel maps TMDB credits JSON', () {
    final cast = CastMemberModel.fromJson({
      'id': 1,
      'name': 'Actor',
      'character': 'Character',
      'profile_path': '/profile.jpg',
    });

    expect(cast.id, 1);
    expect(cast.name, 'Actor');
    expect(cast.character, 'Character');
  });

  test('MovieDetailModel maps genres and limits cast', () {
    final fallback = MovieModel.fromJson({
      'id': 9,
      'title': 'Fallback',
      'overview': 'Old overview',
      'release_date': '2026-01-01',
      'vote_average': 7,
    }, categoryLabel: MovieCategory.nowPlaying.label);

    final detail = MovieDetailModel.fromJson({
      'id': 9,
      'title': 'Remote title',
      'overview': 'Remote overview',
      'genres': [
        {'id': 1, 'name': 'Action'},
        {'id': 2, 'name': 'Drama'},
      ],
      'credits': {
        'cast': List.generate(
          12,
          (index) => {
            'id': index + 1,
            'name': 'Actor $index',
            'character': 'Role $index',
          },
        ),
      },
    }, fallbackMovie: fallback);

    expect(detail.movie.title, 'Remote title');
    expect(detail.movie.categoryLabel, MovieCategory.nowPlaying.label);
    expect(detail.genres, ['Action', 'Drama']);
    expect(detail.cast, hasLength(10));
  });
}
