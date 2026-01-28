import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://diomisfrhfinohloejyx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpb21pc2ZyaGZpbm9obG9lanl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0MzQxNzMsImV4cCI6MjA4NTAxMDE3M30.y1cFnb0TSLdiaZAAiOMJgmoLXgj4WSMvP5vO7SIZiOE',
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
