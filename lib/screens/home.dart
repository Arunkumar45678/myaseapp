import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  /* ================= LOGOUT ================= */
  Future<void> _logout() async {
    // Sign out from Google
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    // Sign out from Supabase
    await Supabase.instance.client.auth.signOut();

    // Redirect to login
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  /* ================= BODY ================= */
  Widget _getBody() {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const Center(child: Text("Info Page"));
      case 2:
        return const Center(child: Text("Profile Page"));
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ASE Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      /* ================= DRAWER ================= */
      drawer: Drawer(
        backgroundColor: const Color(0xFF0A1F44),
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "ASE Menu",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              title: const Text("Home",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => index = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Profile",
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => index = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Logout",
                  style: TextStyle(color: Colors.white)),
              onTap: _logout,
            ),
          ],
        ),
      ),

      /* ================= BODY ================= */
      body: _getBody(),

      /* ================= BOTTOM NAV ================= */
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        backgroundColor: const Color(0xFF0A1F44),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: "Info"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
