import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService with ChangeNotifier {

  final List<Map<String, String>> _messages = [];
  final String _apiKey = dotenv.env['OPENAI_API_KEY']!;

  List<Map<String, String>> get messages => _messages;

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    _messages.add({'user': userMessage});
    notifyListeners();

    final botResponse = await _sendRequestToOpenAI(userMessage);

    _messages.add({'bot': botResponse});
    notifyListeners();
  }

  Future<String> _sendRequestToOpenAI(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': '너는 MOTU라는 경제 및 투자 교육용 어플리케이션의 교육용 챗봇이야. 사용자의 질문에 대해 정확하고 유익한 답변을 제공해. 올바른 투자 가치관을 가질 수 있도록 사용자를 도와줘.'},
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['choices'][0]['message']['content'].trim();
    } else {
      print('Failed to fetch response: ${response.statusCode}');
      print('Response body: ${response.body}');
      return 'Error: Unable to fetch response';
    }
  }
}
