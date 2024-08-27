import 'package:flutter/material.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';
import '../../provider/chat_provider.dart';

class ChatbotScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: Text('MOTU CHATBOT'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chat_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChatService>(
                builder: (context, chatService, child) {
                  return ListView.builder(
                    itemCount: chatService.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatService.messages[index];
                      final isUser = message.containsKey('user');
                      return Align(
                        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Container(
                                width: screenWidth * 0.1,
                                height: screenWidth * 0.1,
                                margin: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Image.asset(
                                  'assets/images/character/chatbot_profile.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 30.0),
                                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? ColorTheme.colorPrimary20
                                      : ColorTheme.colorNeutral,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  isUser ? message['user']! : message['bot']!,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: '메시지를 입력하세요',
                        filled: true,
                        fillColor: ColorTheme.colorNeutral,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: ColorTheme.colorPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_upward),
                      color: Colors.white,
                      onPressed: () {
                        final text = _controller.text;
                        if (text.isNotEmpty) {
                          Provider.of<ChatService>(context, listen: false).sendMessage(text);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
