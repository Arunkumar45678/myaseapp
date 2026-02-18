import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  final String uid;

  const HomeScreen({super.key, required this.uid});

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

  Future<void> _loadUserData() async {
    try {
      final res = await supabase
          .from('user_profiles')
          .select('full_name, username')
          .eq('id', widget.uid)
          .maybeSingle();

      if (res != null) {
        setState(() {
          userName = res['full_name'] ?? "";
          username = res['username'] ?? "";
        });
      }
    } catch (e) {
      print("LOAD USER ERROR: $e");
    }
  }

  Future<void> _logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    await supabase.auth.signOut();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _body() {
    if (index == 0) return DashboardScreen(uid: widget.uid);
    if (index == 1) return const Center(child: Text("Info Page"));
    return const Center(child: Text("Profile Page"));
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
          )
        ],
      ),

      drawer: Drawer(
        child: Column(
          children: [

            UserAccountsDrawerHeader(
              accountName: Text(
                  userName.isEmpty ? "Loading..." : userName),
              accountEmail: Text(username),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),

            ListTile(
              title: const Text("Home"),
              onTap: () {
                setState(() => index = 0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),

      body: _body(),

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
