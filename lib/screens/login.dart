import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../services/captcha_service.dart';
import 'home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final captchaCtrl = TextEditingController();
  final captcha = CaptchaService();

  @override
  void initState() {
    super.initState();
    captcha.generate();
  }

  Future<void> login() async {
    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      show("No Internet Connection");
      return;
    }

    if (!captcha.validate(captchaCtrl.text)) {
      show("Captcha incorrect");
      setState(() => captcha.generate());
      return;
    }

    final res = await AuthService.login(usernameCtrl.text, passwordCtrl.text);

    if (res["status"] == true) {
      await SessionService.saveUser(res["user_id"]);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      show(res["message"]);
    }
  }

  void show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MyAseApp Login")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: usernameCtrl, decoration: InputDecoration(labelText: "Username")),
          TextField(controller: passwordCtrl, obscureText: true, decoration: InputDecoration(labelText: "Password")),
          SizedBox(height: 10),
          Text("Solve: ${captcha.a} ${captcha.operator} ${captcha.b} = ?"),
          TextField(controller: captchaCtrl, keyboardType: TextInputType.number),
          SizedBox(height: 20),
          ElevatedButton(onPressed: login, child: Text("Login")),
        ]),
      ),
    );
  }
}
