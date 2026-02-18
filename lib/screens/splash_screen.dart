import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';
import 'home.dart';
import 'registration_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = supabase.auth.currentUser;

    /// 🔴 NOT LOGGED IN → LOGIN
    if (user == null) {
      _go(const LoginScreen());
      return;
    }

    /// 🔴 CHECK PROFILE EXISTS
    final profile = await supabase
        .from('user_profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();

    /// 🔴 FIRST LOGIN → REGISTRATION
    if (profile == null) {
      _go(const RegistrationScreen());
    } 
    
    /// 🔴 REGISTERED → HOME (PASS UID)
    else {
      _go(HomeScreen(uid: user.id));
    }
  }

  void _go(Widget page) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
