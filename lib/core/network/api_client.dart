/// HTTP boundary used by data sources.
///
/// Features depend on this abstraction instead of Dio so transport details stay
/// inside `core/network`. Data sources receive decoded response bodies and are
/// responsible for validating endpoint-specific shapes.
abstract class ApiClient {
  /// Executes a GET request and returns the decoded response body.
  Future<dynamic> get(String path, {Map<String, dynamic>? query});

  /// Executes a POST request and returns the decoded response body.
  Future<dynamic> post(String path, {dynamic data});

  /// Executes a PATCH request and returns the decoded response body.
  Future<dynamic> patch(String path, {dynamic data});

  /// Uploads a local image file using multipart/form-data.
  Future<dynamic> uploadImage(String path, String filePath);
}
