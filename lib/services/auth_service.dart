import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final SupabaseClient _supabase =
      Supabase.instance.client;

  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    try {
      print("➡️ RPC CALL START");
      print("USERNAME: $username");
      print("PASSWORD: $password");

      final res = await _supabase.rpc(
        'login_user',
        params: {
          'p_username': username,
          'p_password': password,
        },
      );

      print("⬅️ RAW RPC RESPONSE: $res");
      print("⬅️ RESPONSE TYPE: ${res.runtimeType}");

      if (res == null) {
        throw Exception("RPC returned NULL");
      }

      if (res is List && res.isNotEmpty) {
        final row = Map<String, dynamic>.from(res.first);
        print("✅ PARSED ROW: $row");
        return row;
      }

      if (res is Map<String, dynamic>) {
        print("✅ DIRECT MAP RESPONSE");
        return res;
      }

      throw Exception("Unexpected RPC response format: $res");
    } catch (e, stack) {
      print("❌ AUTH SERVICE ERROR: $e");
      print("❌ STACK TRACE: $stack");
      rethrow;
    }
  }
}
