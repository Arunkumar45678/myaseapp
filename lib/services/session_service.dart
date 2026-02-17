import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();
  static const _key = "uid";

  static Future<void> saveUser(String uid) async {
    await _storage.write(key: _key, value: uid);
    print("SESSION SAVED UID = $uid");
  }

  static Future<String?> getUser() async {
    final uid = await _storage.read(key: _key);
    print("SESSION READ UID = $uid");
    return uid;
  }

  static Future<void> clear() async {
    await _storage.delete(key: _key);
    print("SESSION CLEARED");
  }
}
