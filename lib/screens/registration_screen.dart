import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';

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
  final captchaCtrl = TextEditingController();

  String? gender;
  String? district;
  String? mandal;
  String? village;

  List<String> districts = [];
  List<String> mandals = [];
  List<String> villages = [];

  bool acceptedTerms = false;
  bool loading = false;
  String? mobileError;

  int a = 0, b = 0;

  @override
  void initState() {
    super.initState();
    generateCaptcha();
    loadDistricts();
  }

  void generateCaptcha() {
    final r = Random();
    a = r.nextInt(9) + 1;
    b = r.nextInt(a);
  }

  /* =========================
     LOAD DROPDOWNS
     ========================= */

  Future<void> loadDistricts() async {
    final res = await supabase
        .from('villages')
        .select('district')
        .order('district');

    districts = res.map<String>((e) => e['district'] as String).toSet().toList();
    setState(() {});
  }

  Future<void> loadMandals(String dist) async {
    mandals.clear();
    villages.clear();
    mandal = null;
    village = null;

    final res = await supabase
        .from('villages')
        .select('mandal')
        .eq('district', dist);

    mandals = res.map<String>((e) => e['mandal'] as String).toSet().toList();
    setState(() {});
  }

  Future<void> loadVillages(String man) async {
    villages.clear();
    village = null;

    final res = await supabase
        .from('villages')
        .select('village')
        .eq('district', district!)
        .eq('mandal', man);

    villages = res.map<String>((e) => e['village'] as String).toList();
    setState(() {});
  }

  /* =========================
     VALIDATIONS
     ========================= */

  Future<void> checkMobile(String mobile) async {
    if (mobile.length != 10) return;

    final res = await supabase
        .from('user_profiles')
        .select('id')
        .eq('mobile', mobile)
        .maybeSingle();

    setState(() {
      mobileError = res != null ? "Mobile number already registered" : null;
    });
  }

  /* =========================
     SUBMIT
     ========================= */

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!acceptedTerms) {
      show("Accept Terms & Conditions");
      return;
    }
    if (int.tryParse(captchaCtrl.text) != (a - b)) {
      show("Captcha incorrect");
      generateCaptcha();
      setState(() {});
      return;
    }

    setState(() => loading = true);

    try {
      final user = supabase.auth.currentUser!;

      await supabase.from('user_profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name': nameCtrl.text.trim(),
        'gender': gender,
        'mobile': mobileCtrl.text.trim(),
        'district': district,
        'mandal': mandal,
        'village': village,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      show(e.toString());
    } finally {
      setState(() => loading = false);
    }
  }

  void show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  /* =========================
     UI
     ========================= */

  @override
  Widget build(BuildContext context) {
    final email = supabase.auth.currentUser?.email ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Mandatory Registration")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [

            TextFormField(
              initialValue: email,
              readOnly: true,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 12),

            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Full Name"),
              validator: (v) => v!.isEmpty ? "Name required" : null,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text("Male"),
                    value: "Male",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v as String),
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text("Female"),
                    value: "Female",
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v as String),
                  ),
                ),
              ],
            ),

            TextFormField(
              controller: mobileCtrl,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Mobile Number",
                errorText: mobileError,
              ),
              onChanged: checkMobile,
              validator: (v) => v!.length != 10 ? "Invalid mobile" : null,
            ),

            DropdownButtonFormField(
              value: district,
              hint: const Text("Select District"),
              items: districts.map((e) =>
                DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {
                district = v;
                loadMandals(v!);
              },
              validator: (v) => v == null ? "Required" : null,
            ),

            DropdownButtonFormField(
              value: mandal,
              hint: const Text("Select Mandal"),
              items: mandals.map((e) =>
                DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {
                mandal = v;
                loadVillages(v!);
              },
              validator: (v) => v == null ? "Required" : null,
            ),

            DropdownButtonFormField(
              value: village,
              hint: const Text("Select Village"),
              items: villages.map((e) =>
                DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => village = v,
              validator: (v) => v == null ? "Required" : null,
            ),

            const SizedBox(height: 12),

            Text("Solve: $a - $b = ?"),
            TextField(controller: captchaCtrl),

            CheckboxListTile(
              value: acceptedTerms,
              onChanged: (v) => setState(() => acceptedTerms = v!),
              title: const Text("I accept Terms & Conditions"),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: loading ? null : submit,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("SUBMIT"),
            ),
          ]),
        ),
      ),
    );
  }
}
