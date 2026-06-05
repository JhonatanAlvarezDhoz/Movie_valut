import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/core/network/api_response_envelope.dart';

void main() {
  test('ApiResponseEnvelope parses TMDB paginated success response', () {
    final envelope = ApiResponseEnvelope.fromJson({
      'page': 1,
      'results': [
        {'id': 1, 'title': 'Movie'},
      ],
      'total_pages': 5,
      'total_results': 100,
    });

    expect(envelope.page, 1);
    expect(envelope.results, hasLength(1));
    expect(envelope.totalPages, 5);
    expect(envelope.totalResults, 100);
    expect(envelope.toJson()['results'], envelope.results);
  });

  test(
    'ApiResponseEnvelope throws ParsingException when results is missing',
    () {
      expect(
        () => ApiResponseEnvelope.fromJson({'page': 1}),
        throwsA(isA<ParsingException>()),
      );
    },
  );
}
