import 'package:chat_app/auth/auth_servie.dart';
import 'package:chat_app/widgets/textfied.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, required this.onTap});

  final void Function() onTap;
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _handleLogin(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(_email.text, _password.text);
    } catch (e) {
      print("Error");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.message,
            size: 60,
            color: Colors.blue,
          ),
          const SizedBox(height: 10),
          Text(
            "Hi, you have been missed",
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomTextField(controller: _email, label: "Email"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: _password,
                    label: "Password",
                    obscureText: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Adjust as desired
                      ),
                    ),
                    onPressed: () => _handleLogin(context),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              'Don\'t have an account? ',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(
              width: 4,
            ),
            InkWell(
              onTap: onTap,
              child: const Text(
                "Register Now",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            )
          ])
        ],
      ),
    );
  }
}
