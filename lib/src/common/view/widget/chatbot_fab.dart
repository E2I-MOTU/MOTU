import 'package:flutter/material.dart';
import '../chat_page.dart';

class ChatbotFloatingActionButton extends StatelessWidget {
  final String heroTag;

  const ChatbotFloatingActionButton({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.0,
      height: 60.0,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatbotPage()),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 6.0,
        shape: const CircleBorder(),
        child: ClipOval(
          child: Image.asset(
            'assets/images/chatbot.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
