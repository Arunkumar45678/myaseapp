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
  bool loading = false;

  final supabase = Supabase.instance.client;

  /* ============================
     GOOGLE SIGN-IN
     ============================ */
  Future<void> googleLogin() async {
    try {
      setState(() => loading = true);

      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      if (response.user != null) {
        await handlePostLogin();
      }
    } catch (e) {
      show(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  /* ============================
     POST LOGIN ROUTER (IMPORTANT)
     ============================ */
  Future<void> handlePostLogin() async {
    final user = supabase.auth.currentUser!;

    final profile = await supabase
        .from('user_profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    if (profile == null) {
      // FIRST TIME USER → REGISTRATION
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const RegistrationScreen(),
        ),
      );
    } else {
      // ALREADY REGISTERED → DASHBOARD
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  void show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /* ============================
     UI
     ============================ */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 80,
                ),
                const SizedBox(height: 16),

                const Text(
                  "Welcome to ASE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Sign in to continue",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : googleLogin,
                    icon: const Icon(Icons.login),
                    label: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Continue with Google"),
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
