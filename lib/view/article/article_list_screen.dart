import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/view/article/widget/article_list_builder.dart';
import '../../model/article_data.dart';

import 'article_detail_screen.dart';

class ArticleListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Article>> fetchArticles() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('financial_column').get();
      return querySnapshot.docs.map((doc) => Article.fromFirestore(doc)).toList();
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
            return Center(child: CircularProgressIndicator());
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
                            fontSize: 20,
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
                        child: Container(
                          height: 200,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      );
                    } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: 200,
                          child: Center(child: Text('No recommendations available.')),
                        ),
                      );
                    } else {
                      final recommendedArticles = snapshot.data!;
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recommendedArticles.length,
                              itemBuilder: (context, index) {
                                final article = recommendedArticles[index];
                                return AspectRatio(
                                  aspectRatio: 2.6 / 3,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ArticleDetailScreen(article: article),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 15.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.5),
                                                BlendMode.darken,
                                              ),
                                              child: FutureBuilder<String>(
                                                future: getImageUrl(article.imageUrl),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                                                    return Icon(Icons.error, color: Colors.red);
                                                  } else {
                                                    return Image.network(
                                                      snapshot.data!,
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 8,
                                            bottom: 8,
                                            right: 8,
                                            child: Text(
                                              article.title,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "경제/금융 상식",
                          style: TextStyle(
                            fontSize: 20,
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
