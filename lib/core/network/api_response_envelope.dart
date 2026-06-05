import 'package:movie_vault/core/errors/exceptions/exceptions.dart';

/// Paginated API response envelope.
///
/// TMDB list endpoints return this shape:
///
/// ```json
/// {
///   "page": 1,
///   "results": [],
///   "total_pages": 10,
///   "total_results": 200
/// }
/// ```
///
/// Data sources use this class only to validate the transport shape before
/// passing the payload to feature-specific models.
class ApiResponseEnvelope {
  const ApiResponseEnvelope({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  /// Current page returned by the API.
  final int page;

  /// Raw result list. Feature models decide how each item is parsed.
  final List<dynamic> results;

  /// Total pages available for the current query.
  final int totalPages;

  /// Total results available for the current query.
  final int totalResults;

  factory ApiResponseEnvelope.fromJson(Map<String, dynamic> json) {
    final results = json['results'];
    if (results is! List) {
      throw ParsingException('TMDB did not return a valid results list.');
    }

    return ApiResponseEnvelope(
      page: (json['page'] as num?)?.toInt() ?? 1,
      results: results,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      totalResults: (json['total_results'] as num?)?.toInt() ?? results.length,
    );
  }

  /// Converts the validated envelope back to JSON for feature model factories.
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'results': results,
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}
