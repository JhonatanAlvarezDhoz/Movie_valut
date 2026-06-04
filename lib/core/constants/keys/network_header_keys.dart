abstract final class NetworkHeaderKeys {
  static const contentType = 'Content-Type';
  static const authorization = 'Authorization';
  static const applicationJsonUtf8 = 'application/json; charset=utf-8';
  static const bearerPrefix = 'Bearer';
}

abstract final class NetworkRequestKeys {
  static const skipDefaultJsonContentType = 'skip_default_json_content_type';
  static const skipAuth = 'skip_auth';
  static const skipAuthRefresh = 'skip_auth_refresh';
}
