import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import '../services/captcha_service.dart';
import '../services/session_service.dart';
import 'home.dart';
import 'offline.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();
  final captcha = CaptchaService();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    captcha.generate();
  }

  /// Google login → go dashboard
  Future<void> googleLogin() async {
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
      );

      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        await SessionService.saveUser(user.id);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      showMsg(e.toString());
    }
  }

  /// Username/password login
  Future<void> login() async {
    FocusScope.of(context).unfocus();

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OfflineScreen()),
      );
      return;
    }

    if (usernameCtrl.text.isEmpty ||
        passwordCtrl.text.isEmpty ||
        !captcha.validate(captchaCtrl.text)) {
      showMsg("Invalid input or captcha");
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

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showMsg("Login failed");
      }
    } catch (e) {
      showMsg(e.toString());
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset("assets/images/logo.png", height: 110),

                  const SizedBox(height: 16),

                  const Text(
                    "Welcome to ASE",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    "Please sign up using the button below",
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: googleLogin,
                      icon: const Icon(Icons.login),
                      label: const Text("Sign in with Google"),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: usernameCtrl,
                    decoration:
                        const InputDecoration(labelText: "Username"),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: "Password"),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "Solve: ${captcha.a} ${captcha.operator} ${captcha.b} = ?",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: captchaCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Captcha"),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading
                          ? const CircularProgressIndicator(
                              color: Colors.white)
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
