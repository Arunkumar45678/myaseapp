import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  final loginCtrl = TextEditingController();
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

  /* ================= GOOGLE LOGIN ================= */

  Future<void> googleLogin() async {
    try {
      setState(() => loading = true);

      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final res = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (res.user != null) {
        await _postLoginRoute();
      }
    } catch (e) {
      _show(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  /* ================= MANUAL LOGIN ================= */

  Future<void> manualLogin() async {
    if (int.tryParse(captchaCtrl.text) != (a - b)) {
      _show("Captcha incorrect");
      _genCaptcha();
      setState(() {});
      return;
    }

    setState(() => loading = true);

    try {
      final res = await supabase.rpc('login_user', params: {
        'login_input': loginCtrl.text.trim(),
        'password_input': passwordCtrl.text.trim(),
      });

      if (res == null) {
        _show("Invalid credentials");
        return;
      }

      await _postLoginRoute();
    } catch (e) {
      _show("Login failed");
    } finally {
      setState(() => loading = false);
    }
  }

  /* ================= ROUTING ================= */

  Future<void> _postLoginRoute() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final profile = await supabase
        .from('user_profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegistrationScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
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
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/logo.png", height: 80),
                const SizedBox(height: 16),

                const Text("Welcome to ASE",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : googleLogin,
                    child: const Text("Continue with Google"),
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const Text("OR login with Email / Phone"),
                const Divider(),

                const SizedBox(height: 12),

                TextField(
                  controller: loginCtrl,
                  decoration:
                      const InputDecoration(labelText: "Email or Mobile"),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Password"),
                ),

                const SizedBox(height: 12),

                Text("Solve: $a - $b = ?"),
                TextField(
                  controller: captchaCtrl,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: loading ? null : manualLogin,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("LOGIN"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
