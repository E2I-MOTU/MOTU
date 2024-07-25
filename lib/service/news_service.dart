import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../model/news_article.dart';

class NewsController {
  final String clientId = dotenv.env['YOUR_CLIENT_ID']!;
  final String clientSecret = dotenv.env['YOUR_CLIENT_SECRET']!;

  Future<List<NewsArticle>> fetchNews(String topic) async {
    final response = await http.get(
      Uri.parse('https://openapi.naver.com/v1/search/news.json?query=$topic&display=10&sort=date'),
      headers: {
        'X-Naver-Client-Id': clientId,
        'X-Naver-Client-Secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> articlesJson = data['items'];

      return articlesJson.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      print('Failed to load news. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load news');
    }
  }
}
