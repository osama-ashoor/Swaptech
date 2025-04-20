import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatscreenLogic with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to get the chatroom ID
  String getChatroomId(String senderId, String receiverId) {
    List<String> ids = [senderId, receiverId]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  // Function to add a new chatroom
  Future<void> addChat(
      String currentUserId,
      String otherUserId,
      String currentUserName,
      String otherUserName,
      String currenUserSpecialization,
      String otherUserSpecialization) async {
    List<String> ids = [currentUserId, otherUserId]..sort();
    String chatroomId = '${ids[0]}_${ids[1]}';
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .get()
          .timeout(
            const Duration(seconds: 5),
          );

      if (docSnapshot.exists) {
      } else {
        await _firestore.collection('chatrooms').doc(chatroomId).set({
          'createdAt': FieldValue.serverTimestamp(),
          'users': [currentUserId, otherUserId],
          'typingStatus': {currentUserId: false, otherUserId: false},
          'lastMessage': '',
          'lastMessageSender': '',
          'lastMessageTime': FieldValue.serverTimestamp(),
          'chatroomId': chatroomId,
          'displayNames': {
            currentUserId: otherUserName,
            otherUserId: currentUserName,
          },
          'specializations': {
            currentUserId: otherUserSpecialization,
            otherUserId: currenUserSpecialization,
          },
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  // Function to add message to a chatroom
  Future<void> addMessage(
      String senderId, String chatroomId, String message) async {
    CollectionReference messagesRef = _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages');
    await _firestore.collection('chatrooms').doc(chatroomId).update({
      'lastMessage': message,
      'lastMessageSender': senderId,
      'lastMessageTime': FieldValue.serverTimestamp()
    });
    await messagesRef.add({
      'senderId': senderId,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
      'read': false,
    });
  }

  // Function to get messages from a chatroom
  Stream<QuerySnapshot> getMessages(String chatroomId, String senderId) {
    return _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((querySnapshot) {
      for (var message in querySnapshot.docs) {
        if (!message['read'] && message['senderId'] != senderId) {
          _firestore
              .collection('chatrooms')
              .doc(chatroomId)
              .collection('messages')
              .doc(message.id)
              .update({'read': true});
        }
      }
      return querySnapshot;
    });
  }

  // // Function to get typing status from a chatroom
  // Stream<DocumentSnapshot> getTypingStatus(String chatroomId) {
  // }

  // Function to update typing status in a chatroom
  Future<void> updateTypingStatus(
      String chatroomId, String userId, bool isTyping) async {
    await _firestore.collection('chatrooms').doc(chatroomId).update({
      'typingStatus.$userId': isTyping,
    });
  }

  //get chatrooms
  Stream<QuerySnapshot> getChatrooms(String userId) {
    return _firestore
        .collection('chatrooms')
        .where('users', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true) // ترتيب تنازلي
        .snapshots();
  }
}
