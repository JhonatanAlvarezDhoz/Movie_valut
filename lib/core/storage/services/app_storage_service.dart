import 'package:movie_valut/core/storage/contracts/key_value_storage.dart';
import 'package:movie_valut/core/storage/contracts/object_serializer.dart';

/// Fachada de almacenamiento simple para configuraciones y objetos livianos.
/// pero SOLO para storage simple, no para persistencia estructurada del dominio.
class AppStorageService {
  final KeyValueStorage _keyValueStorage;

  final ObjectSerializer _serializer;

  const AppStorageService(this._keyValueStorage, this._serializer);

  Future<void> saveString(String key, String value) async {
    await _keyValueStorage.writeString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await _keyValueStorage.writeInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await _keyValueStorage.writeDouble(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    await _keyValueStorage.writeBool(key, value);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await _keyValueStorage.writeStringList(key, value);
  }

  String? getString(String key) => _keyValueStorage.readString(key);
  int? getInt(String key) => _keyValueStorage.readInt(key);
  double? getDouble(String key) => _keyValueStorage.readDouble(key);
  bool? getBool(String key) => _keyValueStorage.readBool(key);
  List<String>? getStringList(String key) =>
      _keyValueStorage.readStringList(key);
  dynamic get(String key) => _keyValueStorage.read(key);

  Future<void> remove(String key) async {
    await _keyValueStorage.remove(key);
  }

  Future<void> clear() async {
    await _keyValueStorage.clear();
  }

  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final encoded = _serializer.encode(object);
    await _keyValueStorage.writeString(key, encoded);
  }

  T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final source = _keyValueStorage.readString(key);
    if (source == null) return null;

    return _serializer.decode<T>(source, fromJson);
  }
}
