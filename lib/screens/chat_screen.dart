import 'package:chat_app/services/auth/auth_servie.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen(
      {super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID;

  // text controller
  final TextEditingController _message = TextEditingController();

  // get services
  final ChatService _chatService = ChatService();

  // send message
  void _sendMessage(context) async {
    try {
      if (_message.text.isNotEmpty) {
        await _chatService.sendMessage(
          receiverID,
          _message.text,
        );
        // clear message
        _message.clear();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 4),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _message,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type a message',
                  ),
                )),
                IconButton(
                    onPressed: () => _sendMessage(context),
                    icon: const Icon(Icons.arrow_upward))
              ],
            ),
          )
        ],
      ),
    );
  }

// Message List
  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(receiverID),
        builder: (context, snapshot) {
          // Error state
          if (snapshot.hasError) {
            return const Text('Error');
          }
          // Waiting state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          // No messages
          if (snapshot.data!.docs.isEmpty) {
            return const Text('No messages');
          }
          // return message list
          return ListView(
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  // message Item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Text(data['message']);
  }
}
