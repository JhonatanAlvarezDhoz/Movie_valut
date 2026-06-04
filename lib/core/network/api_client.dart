/// Abstraction to avoid coupling with Dio
abstract class ApiClient {
  Future<dynamic> get(String path, {Map<String, dynamic>? query});
  Future<dynamic> post(String path, {dynamic data});
  Future<dynamic> patch(String path, {dynamic data});
  Future<dynamic> uploadImage(String path, String filePath);
}
