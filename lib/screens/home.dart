import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';
import 'dashboard.dart';
import '../services/session_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final supabase = Supabase.instance.client;

  int index = 0;
  String userName = "";
  String username = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /* ---------------- LOAD USER DATA ---------------- */

  Future<void> _loadUserData() async {

    final authUser = supabase.auth.currentUser;
    String? uid;

    if (authUser != null) {
      uid = authUser.id;
    } else {
      uid = await SessionService.getUser();
    }

    if (uid == null) return;

    final res = await supabase
        .from('user_profiles')
        .select('full_name, username')
        .eq('id', uid)
        .maybeSingle();

    if (res != null) {
      setState(() {
        userName = res['full_name'] ?? "";
        username = res['username'] ?? "";
      });
    }
  }

  /* ---------------- LOGOUT ---------------- */

  Future<void> _logout() async {

    try { await GoogleSignIn().signOut(); } catch (_) {}

    await supabase.auth.signOut();
    await SessionService.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  /* ---------------- BODY ---------------- */

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

  /* ---------------- UI ---------------- */

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

      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              accountName: Text(
                userName.isEmpty ? "Loading..." : userName,
              ),
              accountEmail: Text(username),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 30),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                setState(() => index = 0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                setState(() => index = 2);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),

      body: _getBody(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "Info"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
