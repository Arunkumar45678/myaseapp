import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../services/session_service.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();

  bool loading = false;

  late int a;
  late int b;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final rand = Random();
    a = rand.nextInt(9) + 1;
    b = rand.nextInt(9) + 1;
    if (b > a) {
      final t = a;
      a = b;
      b = t;
    }
  }

  bool _validateCaptcha() {
    return int.tryParse(captchaCtrl.text) == (a - b);
  }

  // ==============================
  // NATIVE GOOGLE SIGN-IN
  // ==============================
  Future<void> nativeGoogleLogin() async {
    try {
      setState(() => loading = true);

      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final res =
          await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (res.user != null) {
        await SessionService.saveUser(res.user!.id);
        _goHome();
      }
    } catch (e) {
      _show(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  // ==============================
  // USERNAME / PASSWORD LOGIN
  // ==============================
  Future<void> login() async {
    if (!_validateCaptcha()) {
      _show("Captcha incorrect");
      setState(() => _generateCaptcha());
      return;
    }

    setState(() => loading = true);

    try {
      final res = await AuthService.login(
        usernameCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (res['status'] == true) {
        await SessionService.saveUser(res['user_id']);
        _goHome();
      } else {
        _show("Invalid credentials");
      }
    } catch (e) {
      _show(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO
                  Image.asset(
                    "assets/images/logo.png",
                    height: 90,
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Welcome to ASE",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Please sign up using the button below",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // GOOGLE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: loading ? null : nativeGoogleLogin,
                      icon: const Icon(Icons.login),
                      label: const Text("Continue with Google"),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text("or login here"),

                  const SizedBox(height: 8),

                  const Divider(),

                  const SizedBox(height: 16),

                  // USERNAME
                  TextField(
                    controller: usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // PASSWORD
                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // CAPTCHA TEXT
                  Text(
                    "Solve: $a - $b = ?",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: captchaCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Captcha",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // LOGIN BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
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
