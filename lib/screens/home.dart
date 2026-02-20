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

  int index = 0;

  Future<void> _logout() async {
    try { await GoogleSignIn().signOut(); } catch (_) {}
    await Supabase.instance.client.auth.signOut();

    if(!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Widget _body(){
    switch(index){
      case 0: return DashboardScreen(uid: widget.uid);
      case 1: return const Center(child:Text("Info Page"));
      case 2: return const Center(child:Text("Profile Page"));
      default: return DashboardScreen(uid: widget.uid);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar(
        title: const Text("ASE Dashboard"),
        actions:[
          IconButton(icon:const Icon(Icons.logout),onPressed:_logout)
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [

            const DrawerHeader(
  decoration: BoxDecoration(color: Color(0xFF0A1F44)),
  child: Text(
    "ASE Menu",
    style: TextStyle(color: Colors.white, fontSize: 22),
  ),
)

            ListTile(
              title: const Text("Home"),
              onTap: (){
                setState(()=>index=0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: const Text("Profile"),
              onTap: (){
                setState(()=>index=2);
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

      body:_body(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex:index,
        onTap:(i)=>setState(()=>index=i),
        items: const [
          BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),
          BottomNavigationBarItem(icon:Icon(Icons.info),label:"Info"),
          BottomNavigationBarItem(icon:Icon(Icons.person),label:"Profile"),
        ],
      ),
    );
  }
}
