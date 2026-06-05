import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_vault/core/errors/exceptions/exceptions.dart';
import 'package:movie_vault/features/auth/data/models/auth_session_model.dart';

class HiveAuthLocalDataSource {
  static const _boxName = 'auth_session_box';
  static const _sessionKey = 'current_session';

  Future<Box<dynamic>> get _box async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<dynamic>(_boxName);
    }

    return Hive.openBox<dynamic>(_boxName);
  }

  Future<void> saveSession(AuthSessionModel session) async {
    try {
      await (await _box).put(_sessionKey, session.toJson());
    } catch (_) {
      throw CacheException('No fue posible guardar la sesión local.');
    }
  }

  Future<AuthSessionModel?> readSession() async {
    try {
      final source = (await _box).get(_sessionKey);
      if (source is! Map) return null;

      final session = AuthSessionModel.fromJson(source);
      if (session.userId.isEmpty || session.email.isEmpty) return null;

      return session;
    } catch (_) {
      throw CacheException('No fue posible leer la sesión local.');
    }
  }

  Future<void> clearSession() async {
    try {
      await (await _box).delete(_sessionKey);
    } catch (_) {
      throw CacheException('No fue posible limpiar la sesión local.');
    }
  }
}
