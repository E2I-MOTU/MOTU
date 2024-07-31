class NewsArticle {
  final String title;
  final String press;
  final String summary;
  final String link;

  NewsArticle({
    required this.title,
    required this.press,
    required this.summary,
    required this.link,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      press: json['publisher'] ?? 'No Publisher',
      summary: json['description'] ?? 'No Description',
      link: json['link'] ?? '',
    );
  }
}
