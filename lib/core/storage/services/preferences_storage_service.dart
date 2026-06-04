import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie_valut/core/storage/contracts/key_value_storage.dart';

/// Implementación concreta de SharedPreferences.
///
/// Solo maneja almacenamiento simple no sensible.
class PreferencesStorageService implements KeyValueStorage {
  final SharedPreferences _preferences;

  const PreferencesStorageService(this._preferences);

  @override
  Future<void> writeString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  @override
  Future<void> writeInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  @override
  Future<void> writeDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  @override
  Future<void> writeStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  @override
  String? readString(String key) => _preferences.getString(key);

  @override
  int? readInt(String key) => _preferences.getInt(key);

  @override
  double? readDouble(String key) => _preferences.getDouble(key);

  @override
  bool? readBool(String key) => _preferences.getBool(key);

  @override
  List<String>? readStringList(String key) => _preferences.getStringList(key);

  @override
  dynamic read(String key) => _preferences.get(key);

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }
}
