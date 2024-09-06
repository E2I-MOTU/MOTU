import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/view/article/widget/article_list_builder.dart';
import 'package:motu/view/article/widget/recommended_article_builder.dart'; // 새로 추가된 import
import 'package:motu/view/article/widget/skeleton.dart';
import '../../model/article_data.dart';
import 'article_detail_screen.dart';

class ArticleListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Article>> fetchArticles() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('financial_column').get();
      return querySnapshot.docs
          .map((doc) => Article.fromFirestore(doc))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Article>> fetchRandomArticles(int count) async {
    try {
      List<Article> articles = await fetchArticles();
      articles.shuffle();
      return articles.take(count).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('경제꿀팁'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Skeleton(height: 200, width: double.infinity),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found.'));
          } else {
            final articles = snapshot.data!;
            return CustomScrollView(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder<List<Article>>(
                  future: fetchRandomArticles(4),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return AspectRatio(
                                  aspectRatio: 2.6 / 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Skeleton(height: 200, width: 180),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: 200,
                          child: Center(child: Text('No recommendations available.')),
                        ),
                      );
                    } else {
                      final recommendedArticles = snapshot.data!;
                      return buildRecommendedArticles(context, recommendedArticles); // 호출 수정
                    }
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 30.0, right: 16.0, left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "경제/금융 상식",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final article = articles[index];
                      return articleListBuilder(context, article);
                    },
                    childCount: articles.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
