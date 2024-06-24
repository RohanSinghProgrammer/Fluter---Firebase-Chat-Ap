import 'package:chat_app/services/auth/auth_servie.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // text controller
  final TextEditingController _message = TextEditingController();

  // get services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // msg input focus
  final FocusNode _focusNode = FocusNode();

  // focus o input node
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(
      () {
        Future.delayed(const Duration(milliseconds: 500), () => _scrollDown());
      },
    );

    // scroll to bottom when come from different screen
    Future.delayed(const Duration(milliseconds: 500), () => _scrollDown());
  }

  // dispose all nodes
  @override
  void dispose() {
    super.dispose();
    _message.dispose();
    _focusNode.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // send message
  void _sendMessage(context) async {
    try {
      if (_message.text.isNotEmpty) {
        await _chatService.sendMessage(
          widget.receiverID,
          _message.text,
        );
        // clear message
        _message.clear();
        _scrollDown();
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
        title: Text(widget.receiverEmail),
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
                  focusNode: _focusNode,
                  controller: _message,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type a message',
                  ),
                )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                      onPressed: () => _sendMessage(context),
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                      )),
                )
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
        stream: _chatService.getMessages(widget.receiverID),
        builder: (context, snapshot) {
          // Error state
          if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          }
          // Waiting state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // No messages
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages'));
          }
          // return message list
          return ListView(
              controller: _scrollController,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList());
        });
  }

  // message Item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Check current User
    bool currentUser = data["senderID"] == _authService.getUser()!.uid;

    return Row(
      mainAxisAlignment:
          currentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: currentUser ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            data['message'],
            style: TextStyle(
                color: currentUser ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
