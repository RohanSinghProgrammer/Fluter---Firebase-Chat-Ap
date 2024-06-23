import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  // get fireStore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get user streams
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // send message

  // receive message
}
