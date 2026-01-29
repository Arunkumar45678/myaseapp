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

      themeMode: ThemeMode.dark,

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF146FC9),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF146FC9),
          secondary: Color(0xFF146FC9),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF146FC9),
            foregroundColor: Colors.white,
          ),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),

      home: const LoginScreen(),
    );
  }
}

