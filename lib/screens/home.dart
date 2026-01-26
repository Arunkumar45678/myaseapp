import 'package:flutter/material.dart';
import '../services/session_service.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await SessionService.logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
          },
          child: Text("Logout"),
        ),
      ),
    );
  }
}
