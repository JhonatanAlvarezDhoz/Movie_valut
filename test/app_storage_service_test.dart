import 'package:flutter_test/flutter_test.dart';
import 'package:movie_vault/core/storage/contracts/key_value_storage.dart';
import 'package:movie_vault/core/storage/serializers/json_serializer.dart';
import 'package:movie_vault/core/storage/services/app_storage_service.dart';

void main() {
  late _FakeKeyValueStorage storage;
  late AppStorageService service;

  setUp(() {
    storage = _FakeKeyValueStorage();
    service = AppStorageService(storage, const JsonSerializer());
  });

  test('saves and reads primitive values', () async {
    await service.saveString('name', 'Movie Vault');
    await service.saveInt('page', 2);
    await service.saveDouble('rating', 8.5);
    await service.saveBool('dark_mode', true);
    await service.saveStringList('genres', ['Action', 'Drama']);

    expect(service.getString('name'), 'Movie Vault');
    expect(service.getInt('page'), 2);
    expect(service.getDouble('rating'), 8.5);
    expect(service.getBool('dark_mode'), isTrue);
    expect(service.getStringList('genres'), ['Action', 'Drama']);
  });

  test('saves and reads JSON objects through serializer', () async {
    await service.saveObject('profile', {
      'id': 'user-1',
      'email': 'user@test.com',
    });

    final profile = service.getObject<_Profile>(
      'profile',
      (json) =>
          _Profile(id: json['id'] as String, email: json['email'] as String),
    );

    expect(profile, isNotNull);
    expect(profile!.id, 'user-1');
    expect(profile.email, 'user@test.com');
  });

  test('remove and clear delete stored values', () async {
    await service.saveString('first', 'value-1');
    await service.saveString('second', 'value-2');

    await service.remove('first');

    expect(service.getString('first'), isNull);
    expect(service.getString('second'), 'value-2');

    await service.clear();

    expect(service.getString('second'), isNull);
  });
}

class _Profile {
  const _Profile({required this.id, required this.email});

  final String id;
  final String email;
}

class _FakeKeyValueStorage implements KeyValueStorage {
  final values = <String, Object>{};

  @override
  Future<void> writeString(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> writeInt(String key, int value) async {
    values[key] = value;
  }

  @override
  Future<void> writeDouble(String key, double value) async {
    values[key] = value;
  }

  @override
  Future<void> writeBool(String key, bool value) async {
    values[key] = value;
  }

  @override
  Future<void> writeStringList(String key, List<String> value) async {
    values[key] = List<String>.from(value);
  }

  @override
  String? readString(String key) => values[key] as String?;

  @override
  int? readInt(String key) => values[key] as int?;

  @override
  double? readDouble(String key) => values[key] as double?;

  @override
  bool? readBool(String key) => values[key] as bool?;

  @override
  List<String>? readStringList(String key) {
    final value = values[key];
    return value is List<String> ? List<String>.from(value) : null;
  }

  @override
  dynamic read(String key) => values[key];

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }
}
