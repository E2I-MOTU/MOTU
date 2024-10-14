import 'package:html/parser.dart' as html_parser;
import 'package:html_unescape/html_unescape.dart';

class NewsArticle {
  final String title;
  final String summary;
  final String link;

  NewsArticle({
    required this.title,
    required this.summary,
    required this.link,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    String parseHtmlString(String htmlString) {
      final document = html_parser.parse(htmlString);
      final String parsedString = document.body?.text ?? '';
      return unescape.convert(parsedString);
    }

    return NewsArticle(
      title: parseHtmlString(json['title'] ?? 'No Title'),
      summary: parseHtmlString(json['description'] ?? 'No Description'),
      link: json['link'] ?? '',
    );
  }
}
