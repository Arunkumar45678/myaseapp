import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';
import 'registration_screen.dart';
import '../services/session_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final supabase = Supabase.instance.client;

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();

  bool loading = false;
  int a = 0, b = 0;

  @override
  void initState() {
    super.initState();
    _genCaptcha();
  }

  void _genCaptcha() {
    final r = Random();
    a = r.nextInt(9) + 1;
    b = r.nextInt(a);
  }

  InputDecoration _input(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  /* ================= GOOGLE LOGIN ================= */

  Future<void> googleLogin() async {
    try {
      setState(() => loading = true);

      print("GOOGLE LOGIN START");

      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) {
        print("Google cancelled");
        return;
      }

      final auth = await googleUser.authentication;

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: auth.idToken!,
        accessToken: auth.accessToken,
      );

      print("Google auth success");

      final user = supabase.auth.currentUser!;
      print("SUPABASE UID: ${user.id}");

      final profile = await supabase
          .from('user_profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        print("NO PROFILE → go to registration");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RegistrationScreen()),
        );
      } else {
        print("PROFILE FOUND → go to dashboard");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }

    } catch (e) {
      print("GOOGLE LOGIN ERROR: $e");
      _show("Google login failed");
    } finally {
      setState(() => loading = false);
    }
  }

  /* ================= MANUAL LOGIN DEBUG ================= */

  Future<void> manualLogin() async {

    final uname = usernameCtrl.text.trim();
    final pass = passwordCtrl.text.trim();

    if (uname.isEmpty || pass.isEmpty) {
      _show("Enter username & password");
      return;
    }

    if (int.tryParse(captchaCtrl.text) != (a - b)) {
      _show("Captcha incorrect");
      _genCaptcha();
      setState(() {});
      return;
    }

    setState(() => loading = true);

    try {

      print("----- MANUAL LOGIN DEBUG START -----");
      print("USERNAME: $uname");
      print("PASSWORD LENGTH: ${pass.length}");

      /// 1️⃣ Check username exists
      final userCheck = await supabase
          .from('user_profiles')
          .select('id, username')
          .eq('username', uname)
          .maybeSingle();

      print("DB LOOKUP RESULT: $userCheck");

      if (userCheck == null) {
        _show("Username not found");
        return;
      }

      /// 2️⃣ Call RPC
      final result = await supabase.rpc(
        'login_user',
        params: {
          'username_input': uname,
          'password_input': pass,
        },
      );

      print("RPC RESULT: $result");

      if (result == null) {
        _show("Wrong password OR RPC returned NULL");
        return;
      }

      /// 3️⃣ Save UID locally
      final uid = result.toString();
      print("UID FROM RPC: $uid");

      await SessionService.saveUser(uid);
      print("UID SAVED LOCALLY");

      /// 4️⃣ Navigate
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

      print("----- LOGIN SUCCESS -----");

    } catch (e) {
      print("MANUAL LOGIN ERROR: $e");
      _show("Login error: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset("assets/images/logo.png", height: 70),

                  const SizedBox(height: 12),

                  const Text(
                    "Welcome to ASE",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),
                  const Text("Sign in to continue"),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : googleLogin,
                      child: const Text("Continue with Google"),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  const Text("OR login with Username"),
                  const Divider(),

                  const SizedBox(height: 10),

                  TextField(
                    controller: usernameCtrl,
                    decoration: _input("Username"),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: _input("Password"),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Solve: $a - $b = ?",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  TextField(
                    controller: captchaCtrl,
                    decoration: _input("Captcha"),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : manualLogin,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("LOGIN"),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
