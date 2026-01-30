import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();
  static const _key = "user_session";

  static Future<void> saveUser(String userId) async {
    await _storage.write(key: _key, value: userId);
  }

  static Future<String?> getUser() async {
    return await _storage.read(key: _key);
  }

  static Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}
