// Contrato para almacenamiento simple no seguro.
// Ideal para configuraciones

abstract class KeyValueStorage {
  Future<void> writeString(String key, String value);
  Future<void> writeInt(String key, int value);
  Future<void> writeDouble(String key, double value);
  Future<void> writeBool(String key, bool value);
  Future<void> writeStringList(String key, List<String> value);

  String? readString(String key);
  int? readInt(String key);
  double? readDouble(String key);
  bool? readBool(String key);
  List<String>? readStringList(String key);
  dynamic read(String key);

  Future<void> remove(String key);
  Future<void> clear();
}
