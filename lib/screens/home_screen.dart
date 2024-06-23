import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/auth/auth_servie.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flutter X Firebase Chat App',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: _buildUserList(context),
    );
  }

  // ? User List
  Widget _buildUserList(BuildContext context) {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          // Error
          if (snapshot.hasError) {
            return const Text("Error!");
          }
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }

          // Return View
          return ListView(
            children: snapshot.data!
                .map((user) => _builtUser(user, context))
                .toList(),
          );
        });
  }

  // ? Single User
  Widget _builtUser(Map<String, dynamic> user, BuildContext context) {
    if (user["email"] != _authService.getUser()?.email) {
      return UserTile(
        text: user["email"],
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverEmail: user["email"],
              ),
            )),
      );
    } else {
      return const SizedBox(); // Returns nothing
    }

    // return const Text("Hello");
  }
}
