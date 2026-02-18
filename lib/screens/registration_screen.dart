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
  final usernameCtrl = TextEditingController();

  String? gender;
  String? district;
  String? mandal;
  String? village;
  String? villageCode;

  List<String> districts = [];
  List<String> mandals = [];
  List<String> villages = [];

  bool acceptTerms = false;
  bool loading = false;

  int a = 0, b = 0;

  @override
  void initState() {
    super.initState();
    _genCaptcha();
    _loadDistricts();
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

  /* ---------------- LOAD DISTRICTS ---------------- */
  Future<void> _loadDistricts() async {
    final res = await supabase.rpc('get_districts');
    districts = List<String>.from(res.map((e) => e['district']));
    setState(() {});
  }

  /* ---------------- LOAD MANDALS ---------------- */
  Future<void> _loadMandals(String d) async {
    final res =
        await supabase.rpc('get_mandals', params: {'p_district': d});

    mandals = List<String>.from(res.map((e) => e['mandal']));
    villages.clear();
    village = null;
    usernameCtrl.clear();
    setState(() {});
  }

  /* ---------------- LOAD VILLAGES ---------------- */
  Future<void> _loadVillages(String m) async {
    final res = await supabase.rpc('get_villages', params: {
      'p_district': district,
      'p_mandal': m
    });

    villages = List<String>.from(res.map((e) => e['village']));
    usernameCtrl.clear();
    setState(() {});
  }

  /* ---------------- GET VILLAGE CODE ---------------- */
  Future<void> _loadVillageCode(String v) async {
    final res = await supabase.rpc('get_villages', params: {
      'p_district': district,
      'p_mandal': mandal
    });

    final selected =
        res.firstWhere((e) => e['village'] == v, orElse: () => null);

    if (selected != null) {
      villageCode = selected['village_code'];
      usernameCtrl.text = villageCode ?? "";
    }

    setState(() {});
  }

  /* ---------------- SUBMIT ---------------- */
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (gender == null) {
      _show("Select gender");
      return;
    }

    if (!acceptTerms) {
      _show("Accept Terms & Conditions");
      return;
    }

    if (int.tryParse(captchaCtrl.text) != (a - b)) {
      _show("Captcha incorrect");
      _genCaptcha();
      setState(() {});
      return;
    }

    if (villageCode == null) {
      _show("Village code not found");
      return;
    }

    setState(() => loading = true);

    try {
      final user = supabase.auth.currentUser!;

      await supabase.rpc('register_user', params: {
        'uid': user.id,
        'email': user.email,
        'username': villageCode,
        'password_input': passwordCtrl.text.trim(),
        'full_name': nameCtrl.text.trim(),   // ✅ fixed param
        'gender': gender,
        'mobile': mobileCtrl.text.trim(),
        'district': district,
        'mandal': mandal,
        'village': village,
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        final uid = supabase.auth.currentUser!.id;

MaterialPageRoute(
  builder: (_) => HomeScreen(uid: uid),
),

      );
    } catch (e) {
      _show(e.toString()); // show real DB error
    } finally {
      if (mounted) setState(() => loading = false);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: Colors.white,
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    Text("Email: $email"),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: nameCtrl,
                      decoration: _input("Full Name"),
                      validator: (v) =>
                          v!.isEmpty ? "Name required" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: mobileCtrl,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: _input("Mobile Number"),
                      validator: (v) =>
                          v!.length != 10 ? "Invalid mobile" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration: _input("Password"),
                      validator: (v) =>
                          v!.length < 6 ? "Min 6 characters" : null,
                    ),
                    const SizedBox(height: 12),

                    /// Gender
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text("Male"),
                            value: "Male",
                            groupValue: gender,
                            onChanged: (v) =>
                                setState(() => gender = v as String),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text("Female"),
                            value: "Female",
                            groupValue: gender,
                            onChanged: (v) =>
                                setState(() => gender = v as String),
                          ),
                        ),
                      ],
                    ),

                    DropdownButtonFormField(
                      decoration: _input("District"),
                      value: district,
                      items: districts
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        district = v;
                        _loadMandals(v!);
                      },
                      validator: (v) =>
                          v == null ? "Select district" : null,
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      decoration: _input("Mandal"),
                      value: mandal,
                      items: mandals
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        mandal = v;
                        _loadVillages(v!);
                      },
                      validator: (v) =>
                          v == null ? "Select mandal" : null,
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField(
                      decoration: _input("Village"),
                      value: village,
                      items: villages
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) {
                        village = v;
                        _loadVillageCode(v!);
                      },
                      validator: (v) =>
                          v == null ? "Select village" : null,
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: usernameCtrl,
                      readOnly: true,
                      decoration: _input("Username"),
                    ),

                    const SizedBox(height: 12),
                    Text("Solve: $a - $b = ?"),

                    TextField(
                      controller: captchaCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _input("Captcha"),
                    ),

                    CheckboxListTile(
                      value: acceptTerms,
                      onChanged: (v) =>
                          setState(() => acceptTerms = v!),
                      title: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TermsScreen()),
                        ),
                        child: const Text(
                          "Accept Terms & Conditions",
                          style: TextStyle(
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : submit,
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text("SUBMIT"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
