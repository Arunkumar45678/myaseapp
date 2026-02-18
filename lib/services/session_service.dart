import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _storage = FlutterSecureStorage();

  /* ---------- SAVE USER ID ---------- */
  static Future<void> saveUser(String uid) async {
    await _storage.write(key: "uid", value: uid);
  }

  /* ---------- GET USER ID ---------- */
  static Future<String?> getUser() async {
    return await _storage.read(key: "uid");
  }

  /* ---------- CLEAR SESSION ---------- */
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
