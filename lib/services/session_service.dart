import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionService {
  static const _s = FlutterSecureStorage();

  static Future<void> saveUid(String uid) async {
    await _s.write(key: "uid", value: uid);
  }

  static Future<String?> getUid() async {
    return await _s.read(key: "uid");
  }

  static Future<void> clear() async {
    await _s.deleteAll();
  }
}
