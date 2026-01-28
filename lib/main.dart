import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://diomisfrhfinohloejyx.supabase.co',
    anonKey: 'sb_publishable_r1xOPpLNLfmmZH8L7TaRKQ_4dABy1c4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyAseApp',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}
