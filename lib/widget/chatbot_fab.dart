import 'package:flutter/material.dart';
import '../view/learning/chat_screen.dart';

class ChatbotFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotScreen()),
          );
        },
        child: ClipOval(
          child: Image.asset(
            'assets/images/chatbot.png',
            fit: BoxFit.cover,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 6.0,
        shape: const CircleBorder(),
      ),
    );
  }
}
