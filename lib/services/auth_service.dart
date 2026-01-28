import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://diomisfrhfinohloejyx.supabase.co";
  static const String anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpb21pc2ZyaGZpbm9obG9lanl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0MzQxNzMsImV4cCI6MjA4NTAxMDE3M30.y1cFnb0TSLdiaZAAiOMJgmoLXgj4WSMvP5vO7SIZiOE";

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
