// Contrato para almacenamiento seguro de pares clave-valor.
// Se usa para secretos como tokens o identificadores sensibles.

abstract class SecureKeyValueStorage {
  Future<void> write({required String key, required String value});
  Future<String?> read(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
}
