import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASE Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionService.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color(0xFF0A1F44),
        child: ListView(
          children: const [
            DrawerHeader(
              child: Text(
                "ASE Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              title: Text("Home", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Profile", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),

      body: const DashboardScreen(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        backgroundColor: const Color(0xFF0A1F44),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
