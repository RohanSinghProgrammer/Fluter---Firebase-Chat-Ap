import 'package:chat_app/auth/auth_servie.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logOut() async {
    final authService = AuthService();
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(onPressed: _logOut, icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
