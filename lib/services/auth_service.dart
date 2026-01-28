import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase =
      Supabase.instance.client;

  static Future<Map<String, dynamic>> login(
      String username, String password) async {

    final response = await _supabase.rpc(
      'login_user',
      params: {
        'p_username': username,
        'p_password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      return response;
    } else {
      throw Exception("Invalid response from server");
    }
  }
}
