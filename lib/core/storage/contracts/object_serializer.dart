/// Contrato para serializar y deserializar objetos.
///
/// Ayuda a no acoplar la lógica de JSON directamente al servicio de storage.
abstract class ObjectSerializer {
  String encode(Object value);
  T decode<T>(String source, T Function(Map<String, dynamic> json) fromJson);
}
