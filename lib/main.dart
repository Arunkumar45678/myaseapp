import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://diomisfrhfinohloejyx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRpb21pc2ZyaGZpbm9obG9lanl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njk0MzQxNzMsImV4cCI6MjA4NTAxMDE3M30.y1cFnb0TSLdiaZAAiOMJgmoLXgj4WSMvP5vO7SIZiOE',
  );

  runApp(const MyAseApp());
}

class MyAseApp extends StatelessWidget {
  const MyAseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyAseApp',

      theme: ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF146FC9),
  ),

  scaffoldBackgroundColor: const Color(0xFFF5F6FA),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.black26),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.black26),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFF146FC9),
        width: 2,
      ),
    ),
  ),
),
      home: const LoginScreen(),
    );
  }
}

