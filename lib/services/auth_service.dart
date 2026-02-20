import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  /// Manual login → returns UID or null
  static Future<String?> login(String username, String password) async {
    final uid = await _supabase.rpc(
      'login_user',
      params: {
        'username_input': username,
        'password_input': password,
      },
    );

    if (uid == null) return null;
    return uid.toString();
  }
}
