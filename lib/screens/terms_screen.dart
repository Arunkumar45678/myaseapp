import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          '''
TERMS & CONDITIONS

1. Each user can register only once.
2. Mobile number, email, and village must be unique.
3. Users must provide correct information.
4. Misuse of the application may lead to account suspension.
5. Data is securely stored and used only for application purposes.

By continuing, you agree to these terms.
          ''',
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
