import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login.dart';
import 'dashboard.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen({super.key, required this.uid});

  @override
  State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final supabase=Supabase.instance.client;

  int index=0;
  String name="";
  String username="";

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async{

    final res=await supabase
        .from('user_profiles')
        .select('full_name,username')
        .eq('id',widget.uid)
        .maybeSingle();

    if(res!=null){
      setState((){
        name=res['full_name']??"User";
        username=res['username']??"";
      });
    }
  }

  Future<void> _logout() async{
    try{ await GoogleSignIn().signOut(); }catch(_){}
    await supabase.auth.signOut();

    if(!mounted)return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder:(_)=>const LoginScreen()),
      (_)=>false,
    );
  }

  Widget _body(){
    switch(index){
      case 0: return DashboardScreen(uid:widget.uid);
      case 1: return const Center(child:Text("Info Page"));
      case 2: return const Center(child:Text("Profile Page"));
      default:return DashboardScreen(uid:widget.uid);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:const Text("ASE Dashboard"),
        actions:[
          IconButton(icon:const Icon(Icons.logout),onPressed:_logout)
        ],
      ),

      drawer:Drawer(
        child:Column(
          children:[

            /// HEADER (dark background, white text)
            Container(
              width:double.infinity,
              padding:const EdgeInsets.only(top:50,bottom:20),
              color:const Color(0xFF0A1F44),
              child:Column(
                children:[
                  const CircleAvatar(
                    radius:38,
                    backgroundColor:Colors.white,
                    child:Icon(Icons.person,size:40,color:Colors.grey),
                  ),
                  const SizedBox(height:10),
                  Text(
                    name.isEmpty?"Loading...":name,
                    style:const TextStyle(
                      color:Colors.white,
                      fontSize:18,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height:4),
                  Text(
                    username,
                    style:const TextStyle(color:Colors.white70),
                  ),
                ],
              ),
            ),

            ListTile(
              leading:const Icon(Icons.home),
              title:const Text("Home"),
              onTap:(){
                setState(()=>index=0);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading:const Icon(Icons.person),
              title:const Text("Profile"),
              onTap:(){
                setState(()=>index=2);
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading:const Icon(Icons.logout),
              title:const Text("Logout"),
              onTap:_logout,
            ),
          ],
        ),
      ),

      body:_body(),

      bottomNavigationBar:BottomNavigationBar(
        currentIndex:index,
        onTap:(i)=>setState(()=>index=i),
        items:const[
          BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),
          BottomNavigationBarItem(icon:Icon(Icons.info),label:"Info"),
          BottomNavigationBarItem(icon:Icon(Icons.person),label:"Profile"),
        ],
      ),
    );
  }
}
