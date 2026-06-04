import 'dart:convert';

import 'package:movie_valut/core/storage/contracts/object_serializer.dart';

/// Implementación de serialización usando JSON.
class JsonSerializer implements ObjectSerializer {
  const JsonSerializer();

  @override
  String encode(Object value) {
    return jsonEncode(value);
  }

  @override
  T decode<T>(String source, T Function(Map<String, dynamic>) fromJson) {
    final decoded = jsonDecode(source) as Map<String, dynamic>;
    return fromJson(decoded);
  }
}
