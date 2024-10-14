import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/features/learning/column/view/widget/article_list_builder.dart';
import 'package:motu/src/features/learning/column/view/widget/recommended_article_builder.dart'; // 새로 추가된 import
import 'package:motu/src/features/learning/column/view/widget/skeleton.dart';
import '../model/article.dart';

class ArticleListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ArticleListScreen({super.key});

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
        title: const Text('경제꿀팁'),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Article>>(
        future: fetchArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found.'));
          } else {
            final articles = snapshot.data!;
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
                          child: SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return const AspectRatio(
                                  aspectRatio: 2.6 / 3,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 15.0),
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
                      return const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Center(
                              child: Text('No recommendations available.')),
                        ),
                      );
                    } else {
                      final recommendedArticles = snapshot.data!;
                      return buildRecommendedArticles(
                          context, recommendedArticles); // 호출 수정
                    }
                  },
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 30.0, right: 16.0, left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
