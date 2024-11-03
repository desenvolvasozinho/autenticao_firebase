import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.popAndPushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            logout();
          },
          child: const Text('Home page ( Deslogar )'),
        ),
      ),
    );
  }
}
