import 'package:chat_app/modals/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get fireStore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create RoomID
  String createRoomId(String currentUserId, String receiverUid) {
    List<String> ids = [currentUserId, receiverUid];
    ids.sort();
    String chatRoomId = ids.join('_');
    return chatRoomId;
  }

  // get user streams
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverUid, msg) async {
    // get current user details
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserId,
        message: msg,
        receiverID: receiverUid,
        senderEmail: currentUserEmail,
        timeStamp: timestamp);

    // construct chat room ID's for two users
    String chatRoomId = createRoomId(currentUserId, receiverUid);

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // receive message
  Stream<QuerySnapshot> getMessages(String receiverUid) {
    final String currentUserId = _auth.currentUser!.uid;

    // construct chat room ID's for two users
    String chatRoomId = createRoomId(currentUserId, receiverUid);

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection('messages')
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
}
