import 'package:chat_app/widgets/textfied.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key, required this.onTap});

  final void Function() onTap;
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  void _handleSignUp() {
    print("Account Created!");
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
            "Let's create an account for you",
            style: TextStyle(fontSize: 18, color: Colors.grey[400]),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CustomTextField(controller: _username, label: "Username"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: _password,
                    label: "Password",
                    obscureText: true),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: _confirmPassword,
                    label: "Confirm password",
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
                    onPressed: () => _handleSignUp(),
                    child: const Text(
                      'Sign Up',
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
              'Already have an account? ',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(
              width: 4,
            ),
            InkWell(
              onTap: onTap,
              child: const Text(
                "Login Now",
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
