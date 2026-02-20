import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';
import 'home.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final supabase = Supabase.instance.client;

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();

  bool loading=false;
  int a=0,b=0;

  @override
  void initState(){
    super.initState();
    _gen();
  }

  void _gen(){
    final r=Random();
    a=r.nextInt(9)+1;
    b=r.nextInt(a);
  }

  InputDecoration _input(String label)=>InputDecoration(
    labelText:label,
    filled:true,
    fillColor:Colors.white,
    border:OutlineInputBorder(borderRadius:BorderRadius.circular(12)),
  );

  /* ---------- GOOGLE LOGIN ---------- */
  Future<void> googleLogin() async{
    try{
      setState(()=>loading=true);

      final googleUser=await GoogleSignIn(scopes:['email']).signIn();
      if(googleUser==null) return;

      final auth=await googleUser.authentication;

      await supabase.auth.signInWithIdToken(
        provider:OAuthProvider.google,
        idToken:auth.idToken!,
        accessToken:auth.accessToken,
      );

      final user=supabase.auth.currentUser!;

      final profile=await supabase
          .from('user_profiles')
          .select('id')
          .eq('id',user.id)
          .maybeSingle();

      if(!mounted)return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:(_)=>profile==null
              ? const RegistrationScreen()
              : HomeScreen(uid:user.id),
        ),
      );

    }catch(e){
      _show("Google login failed");
    }finally{
      setState(()=>loading=false);
    }
  }

  /* ---------- MANUAL LOGIN ---------- */
  Future<void> manualLogin() async{

    if(usernameCtrl.text.isEmpty||passwordCtrl.text.isEmpty){
      _show("Enter username & password");
      return;
    }

    if(int.tryParse(captchaCtrl.text)!=(a-b)){
      _show("Captcha incorrect");
      _gen(); setState((){});
      return;
    }

    setState(()=>loading=true);

    try{
      final uid=await AuthService.login(
        usernameCtrl.text.trim(),
        passwordCtrl.text.trim(),
      );

      if(uid==null){
        _show("Invalid username or password");
        return;
      }

      if(!mounted)return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:(_)=>HomeScreen(uid:uid),
        ),
      );

    }catch(e){
      _show("Login failed");
    }finally{
      setState(()=>loading=false);
    }
  }

  void _show(String m){
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content:Text(m)));
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:const Color(0xFFF5F7FA),
      body:Center(
        child:SingleChildScrollView(
          padding:const EdgeInsets.all(16),
          child:Card(
            color:Colors.white,
            elevation:10,
            shape:RoundedRectangleBorder(
                borderRadius:BorderRadius.circular(16)),
            child:Padding(
              padding:const EdgeInsets.all(20),
              child:Column(
                mainAxisSize:MainAxisSize.min,
                children:[

                  Image.asset("assets/images/logo.png",height:70),
                  const SizedBox(height:10),
                  const Text("Welcome to ASE",
                      style:TextStyle(
                          fontSize:20,fontWeight:FontWeight.bold)),
                  const SizedBox(height:6),
                  const Text("Please sign in"),

                  const SizedBox(height:16),

                  SizedBox(
                    width:double.infinity,
                    child:ElevatedButton(
                      onPressed:loading?null:googleLogin,
                      child:const Text("Continue with Google"),
                    ),
                  ),

                  const SizedBox(height:12),
                  const Divider(),
                  const Text("OR login with Username"),
                  const Divider(),

                  const SizedBox(height:10),

                  TextField(controller:usernameCtrl,decoration:_input("Username")),
                  const SizedBox(height:12),
                  TextField(controller:passwordCtrl,obscureText:true,decoration:_input("Password")),
                  const SizedBox(height:12),

                  Text("Solve: $a - $b = ?",
                      style:const TextStyle(fontWeight:FontWeight.bold)),

                  const SizedBox(height:6),
                  TextField(
                      controller:captchaCtrl,
                      keyboardType:TextInputType.number,
                      decoration:_input("Captcha")),

                  const SizedBox(height:16),

                  SizedBox(
                    width:double.infinity,
                    child:ElevatedButton(
                      onPressed:loading?null:manualLogin,
                      child:loading
                          ?const CircularProgressIndicator(color:Colors.white)
                          :const Text("LOGIN"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
