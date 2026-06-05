import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/features/movies/data/models/movie_page_model.dart';

void main() {
  test('MoviePageModel parses pagination metadata and category label', () {
    final page = MoviePageModel.fromJson({
      'page': 2,
      'total_pages': 10,
      'results': [
        {
          'id': 11,
          'title': 'Inception',
          'overview': 'Dreams inside dreams.',
          'poster_path': '/poster.jpg',
          'backdrop_path': '/backdrop.jpg',
          'release_date': '2010-07-16',
          'vote_average': 8.4,
        },
        {'id': 0, 'title': 'Invalid'},
      ],
    }, categoryLabel: 'Populares');

    expect(page.currentPage, 2);
    expect(page.totalPages, 10);
    expect(page.hasMorePages, isTrue);
    expect(page.movies, hasLength(1));
    expect(page.movies.first.categoryLabel, 'Populares');
  });
}
