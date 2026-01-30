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
          seedColor: const Color(0xFF4CAF50), // Light green as primary
          primary: const Color(0xFF4CAF50), // Light green
          secondary: const Color(0xFF2196F3), // Blue
          background: const Color(0xFFE3F2FD), // Light blue background
        ),

        scaffoldBackgroundColor: const Color(0xFFF5F9FF),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE3F2FD), // Light blue
          foregroundColor: Color(0xFF1C1C1C),
          elevation: 2,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF4CAF50)),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50), // Light green
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF4CAF50),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFBBDEFB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF4CAF50), // Light green border when focused
              width: 2,
            ),
          ),
          labelStyle: const TextStyle(
            color: Colors.blueGrey,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF4CAF50),
          ),
        ),

        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(8),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFFE3F2FD), // Light blue
          selectedItemColor: const Color(0xFF4CAF50), // Light green
          unselectedItemColor: Colors.blueGrey[600],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 8,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}
