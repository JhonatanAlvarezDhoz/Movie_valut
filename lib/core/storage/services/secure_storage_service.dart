import 'package:movie_valut/core/storage/contracts/secure_key_value_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Adaptador concreto de FlutterSecureStorage.
///
/// Esta clase encapsula la librería externa.
class SecureStorageService implements SecureKeyValueStorage {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  @override
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) async {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
