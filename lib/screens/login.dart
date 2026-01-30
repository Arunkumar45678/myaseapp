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
  bool _obscurePassword = true;

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
        .showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: const Color(0xFF4CAF50), // Light green
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 16,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.white, // White card
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Logo with light blue accent
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 90,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Login Title
                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1C1C),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Sign in to continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Username Field
                  TextField(
                    controller: usernameCtrl,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF4CAF50)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  TextField(
                    controller: passwordCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF4CAF50)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF4CAF50),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Captcha Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Security Check",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Solve: ${captcha.a} ${captcha.operator} ${captcha.b} = ?",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: captchaCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: "Enter Result",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Login Button with Light Green
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50), // Light green
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Forgot Password Link
                  TextButton(
                    onPressed: () {
                      // Add forgot password functionality
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 16,
                      ),
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
