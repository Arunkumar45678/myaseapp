import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://YOUR_PROJECT_ID.supabase.co";
  static const String anonKey = "YOUR_PUBLIC_ANON_KEY";

  static Future<Map<String, dynamic>> login(String username, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/rest/v1/rpc/login_user"),
      headers: {
        "apikey": anonKey,
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "p_username": username,
        "p_password": password
      }),
    );

    return jsonDecode(res.body);
  }
}
