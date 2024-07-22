import '../model/news_article.dart';

class NewsController {
  List<NewsArticle> _allArticles = [
    NewsArticle(
      title: 'Breaking News: Flutter is amazing!',
      description: 'Flutter continues to gain popularity...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Technology',
    ),
    NewsArticle(
      title: 'Latest Updates in Technology',
      description: 'New advancements in technology are changing...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Technology',
    ),
    // Add more articles as needed
    NewsArticle(
      title: 'Breaking News: Flutter is amazing!',
      description: 'Flutter continues to gain popularity...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Science',
    ),
    NewsArticle(
      title: 'Latest Updates in Technology',
      description: 'New advancements in technology are changing...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Science',
    ),
    NewsArticle(
      title: 'Latest Updates in Technology',
      description: 'New advancements in technology are changing...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Business',
    ),
    NewsArticle(
      title: 'Latest Updates in Technology',
      description: 'New advancements in technology are changing...',
      imageUrl: 'https://via.placeholder.com/150',
      topic: 'Technology',
    ),
  ];

  List<NewsArticle> getArticlesByTopic(String topic) {
    return _allArticles.where((article) => article.topic == topic).toList();
  }

  List<NewsArticle> get allArticles => _allArticles;
}
