import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/auth_service.dart';
import '../services/captcha_service.dart';
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

  Future<void> login() async {
    FocusScope.of(context).unfocus();

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OfflineScreen()),
      );
      return;
    }

    if (usernameCtrl.text.isEmpty) {
      showMsg("Enter username");
      return;
    }

    if (passwordCtrl.text.isEmpty) {
      showMsg("Enter password");
      return;
    }

    if (!captcha.validate(captchaCtrl.text)) {
      showMsg("Captcha incorrect");
      setState(() => captcha.generate());
      return;
    }

    setState(() => loading = true);

    try {
      final res = await AuthService.login(
        usernameCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if (res['status'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        showMsg(res['message'] ?? "Login failed");
      }
    } catch (_) {
      showMsg("Server error");
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Logo
                Image.asset(
                  "assets/images/logo.png",
                  height: 140,
                ),

                const SizedBox(height: 8),

                const Text(
                  "ASE",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),

                const Text(
                  "Sample Text",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Please enter User Name"),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: usernameCtrl,
                  decoration: InputDecoration(
                    hintText: "Enter your User Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Please enter Password"),
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "********",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Solve: ${captcha.a} ${captcha.operator} ${captcha.b} = ?",
                ),

                const SizedBox(height: 6),

                TextField(
                  controller: captchaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Captcha answer",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB53045),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: loading ? null : login,
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 18),
                          ),
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
