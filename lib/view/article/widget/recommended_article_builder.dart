import 'package:flutter/material.dart';
import 'package:motu/model/article_data.dart';
import 'package:motu/view/article/widget/skeleton.dart';
import '../article_detail_screen.dart';
import 'article_list_builder.dart';

Widget buildRecommendedArticles(BuildContext context, List<Article> recommendedArticles) {
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
                      builder: (context) =>
                          ArticleDetailScreen(article: article),
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
                        child: FutureBuilder<String>(
                          future: getImageUrl(article.imageUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Skeleton(height: 200, width: 180);
                            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                              return Icon(Icons.error, color: Colors.red);
                            } else {
                              return ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.darken,
                                ),
                                child: Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Positioned(
                        left: 8,
                        bottom: 8,
                        right: 8,
                        child: FutureBuilder<String>(
                          future: getImageUrl(article.imageUrl),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                              return Container();
                            } else {
                              return Text(
                                article.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          },
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
