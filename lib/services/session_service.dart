import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveUser(String userId) async {
    await _storage.write(key: "user_id", value: userId);
  }

  static Future<String?> getUser() async {
    return await _storage.read(key: "user_id");
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
