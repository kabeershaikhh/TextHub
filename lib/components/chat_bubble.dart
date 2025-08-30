import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({
      super.key,
      required this.message,
      required this.isCurrentUser
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:15, bottom: 15, left: 20, right: 20),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      decoration: BoxDecoration(
        color: isCurrentUser ? Color.fromRGBO(3, 155, 229,1) : Color.fromRGBO(215, 248, 255, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message,
      style: TextStyle(
        color: isCurrentUser ? Colors.white : Colors.black,
      ),
      ),
    );
  }
}
