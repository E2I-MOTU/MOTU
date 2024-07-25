import 'package:flutter/material.dart';

class ArticleListScreen extends StatelessWidget {
  final List<NewsArticle> articles = [
    NewsArticle(
      title: '뉴스 제목 1',
      description: '뉴스 설명 1',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    NewsArticle(
      title: '뉴스 제목 2',
      description: '뉴스 설명 2',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    NewsArticle(
      title: '뉴스 제목 3',
      description: '뉴스 설명 3',
      imageUrl: 'https://via.placeholder.com/150',
    ),
    NewsArticle(
      title: '뉴스 제목 4',
      description: '뉴스 설명 4',
      imageUrl: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('뉴스 목록'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "회원님을 위한 추천 컨텐츠",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(4, (index) {
                  return AspectRatio(
                    aspectRatio: 2.6 / 3,
                    child: Container(
                      margin: const EdgeInsets.only(right: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final article = articles[index];
                return NewsCard(article: article);
              },
              childCount: articles.length,
            ),
          ),
        ],
      ),
    );
  }
}

class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

class NewsCard extends StatelessWidget {
  final NewsArticle article;

  NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: Image.network(article.imageUrl, width: 100, fit: BoxFit.cover),
        title: Text(article.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(article.description),
      ),
    );
  }
}
