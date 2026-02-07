import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';
import 'terms_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();

  String? gender;
  bool acceptTerms = false;
  bool loading = false;

  int a = 0, b = 0;

  @override
  void initState() {
    super.initState();
    final r = Random();
    a = r.nextInt(9) + 1;
    b = r.nextInt(a);
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!acceptTerms) {
      _show("Accept terms & conditions");
      return;
    }
    if (int.tryParse(captchaCtrl.text) != (a - b)) {
      _show("Captcha incorrect");
      return;
    }

    setState(() => loading = true);

    try {
      final user = supabase.auth.currentUser!;
      await supabase.rpc('register_user', params: {
        'uid': user.id,
        'email': user.email,
        'name': nameCtrl.text.trim(),
        'gender': gender,
        'mobile': mobileCtrl.text.trim(),
        'password': passwordCtrl.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      _show("Registration failed");
    } finally {
      setState(() => loading = false);
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final email = supabase.auth.currentUser?.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mandatory Registration"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text("Email: $email"),

                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (v) =>
                      v!.isEmpty ? "Name required" : null,
                ),

                TextFormField(
                  controller: mobileCtrl,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(labelText: "Mobile"),
                  validator: (v) =>
                      v!.length != 10 ? "Invalid mobile" : null,
                ),

                TextFormField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration:
                      const InputDecoration(labelText: "Password"),
                  validator: (v) =>
                      v!.length < 6 ? "Min 6 characters" : null,
                ),

                Row(children: [
                  Radio(
                      value: "Male",
                      groupValue: gender,
                      onChanged: (v) => setState(() => gender = v)),
                  const Text("Male"),
                  Radio(
                      value: "Female",
                      groupValue: gender,
                      onChanged: (v) => setState(() => gender = v)),
                  const Text("Female"),
                ]),

                Text("Solve: $a - $b = ?"),
                TextField(controller: captchaCtrl),

                CheckboxListTile(
                  value: acceptTerms,
                  onChanged: (v) => setState(() => acceptTerms = v!),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TermsScreen()),
                      );
                    },
                    child: const Text("Accept Terms & Conditions"),
                  ),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("SUBMIT"),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
