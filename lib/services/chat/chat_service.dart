import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:text_hub/models/message.dart';
class ChatService {

  // get instance of filestore

  final FirebaseFirestore _firestore= FirebaseFirestore.instance;

  // get user stream

  Stream<List<Map<String, dynamic>>> getUserStream(){
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc){
        // go through each  individual user
        final user =doc.data();

       // return user
        return user;
      }).toList();
    });
  }

  // send message
Future<void> sendMessage(String receiverID, String message) async{
    // get current user
  final String currentUserID= FirebaseAuth.instance.currentUser!.uid;
  final  String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  final Timestamp timestamp= Timestamp.now();

  // create a new message

  Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp
  );


  //construct chat room id for the two users (sorted to ensure uniqueness)
  List<String> ids = [currentUserID, receiverID];
  ids.sort(); // sort the ids to ensure uniqueness
  String chatRoomID =ids.join('_');


  // add new message to the database
  await _firestore
  .collection("chat_rooms")
  .doc(chatRoomID)
  .collection("messages")
  .add(newMessage.toMap());

}


  // receive message

  Stream<QuerySnapshot> getMessages(String userID, otherUserID){
    // construct chatroom id for the two user

    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

}

