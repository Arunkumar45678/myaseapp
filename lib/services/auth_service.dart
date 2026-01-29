import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  static Future<Map<String, dynamic>> login(
      String username, String password) async {

    final res = await _supabase.rpc(
      'login_user',
      params: {
        'p_username': username,
        'p_password': password,
      },
    );

    if (res is List && res.isNotEmpty) {
      return Map<String, dynamic>.from(res.first);
    }

    throw Exception("Invalid server response");
  }
}
