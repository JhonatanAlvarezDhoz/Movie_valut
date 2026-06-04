/// Llaves de headers y extras usados por la capa de red.
///
/// Aquí centralizamos tanto nombres HTTP como flags internos
/// para que interceptores y clientes no dependan de literales repetidos.
abstract final class NetworkHeaderKeys {
  static const ifNoneMatch = 'If-None-Match';
  static const etag = 'etag';
  static const contentType = 'Content-Type';
  static const authorization = 'Authorization';
  static const applicationJsonUtf8 = 'application/json; charset=utf-8';
  static const bearerPrefix = 'Bearer';
}

/// Llaves internas para `RequestOptions.extra`.
abstract final class NetworkRequestKeys {
  static const etagStorageKeyOverride = 'etag_storage_key_override';
  static const skipDefaultJsonContentType = 'skip_default_json_content_type';
  static const skipAuth = 'skip_auth';
  static const skipAuthRefresh = 'skip_auth_refresh';
}
