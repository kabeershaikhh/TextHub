import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:text_hub/components/chat_bubble.dart';
import 'package:text_hub/services/auth/auth_service.dart';
import 'package:text_hub/services/chat/chat_service.dart';


class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
   ChatPage({super.key,
              required this.receiverEmail,
              required this.receiverID

  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController= TextEditingController();

  // auth and chat service
  final AuthService _authService= AuthService();
  final ChatService _chatService= ChatService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        // cause a delay so that the keyboard has to show up

        //then the amount of remaining space will be calculated

        //then scroll down
        Future.delayed(const Duration(milliseconds: 500),()=>
          scrollDown(),
            );
      }
    });

    //  wait a bit for listview to be built, then scroll to bottom
    Future.delayed(const Duration(milliseconds: 500),
          ()=> scrollDown(),
    );

  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async{
    // if there is something inside text field
    if(_messageController.text.isNotEmpty){
      // send the message
      await _chatService.sendMessage(widget.receiverID,_messageController.text);

      // clear the text of controller
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // display all messages
        Expanded(
          child: _buildMessageList(),
        ),

          // send message field
          _buildUserInput(),
        ],
      ),

    );
  }

  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser!.uid;
    return StreamBuilder(

      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot){

        // error
        if(snapshot.hasError){
          return const Text("Error");
        }

        // loading
        if(snapshot.connectionState== ConnectionState.waiting){
          return const Text("Loading...");
        }

        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );

  }

  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data= doc.data() as Map<String, dynamic>;

    // if current user
    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser!.uid;

      var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft  ;


    // print message on right side if user is CURRENT USER

    return Container(
        alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data["message"],
              isCurrentUser: isCurrentUser),
        ],
      ),

      );
  }

  // build user input
  Widget _buildUserInput() {
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: myFocusNode,
              controller: _messageController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color.fromRGBO(3,155, 229, 1)),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Type a message",
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: Container(
              padding: const EdgeInsets.only(bottom: 20,right: 12,left: 12, top:20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(3,155, 229, 1),
                // borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
