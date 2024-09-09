import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motu/view/article/widget/skeleton.dart';
import '../../../model/article_data.dart';
import '../article_detail_screen.dart';

Future<String> getImageUrl(String imagePath) async {
  try {
    return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
  } catch (e) {
    print("Error getting image URL: $e");
    return '';
  }
}

Widget articleListBuilder(BuildContext context, Article article, {bool showDivider = true}) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              // 이미지
              Container(
                width: 90,
                height: 90,
                padding: EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FutureBuilder<String>(
                    future: getImageUrl(article.imageUrl),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Skeleton(width: 90, height: 90);
                      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                        return Center(child: Icon(Icons.error));
                      } else {
                        return Image.network(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 토픽
                      FutureBuilder<String>(
                        future: getImageUrl(article.imageUrl), // 실제 데이터를 로딩할 Future
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Row(
                              children: [
                                Skeleton(width: 50, height: 20),
                                SizedBox(width: 8),
                                Skeleton(width: 50, height: 20),
                              ],
                            );
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                            return Container(); // 에러 처리
                          } else {
                            return Wrap(
                              spacing: 8.0,
                              children: article.topics.map((topic) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Color(0xff701FFF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    topic,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 8.0),
                      // 제목
                      FutureBuilder<String>(
                        future: getImageUrl(article.imageUrl), // 실제 데이터를 로딩할 Future
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Skeleton(width: double.infinity, height: 16);
                          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                            return Container(); // 에러 처리
                          } else {
                            return Text(
                              article.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Custom Divider
      if (showDivider)
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth * 0.9, // 90% of the screen width
              height: 1.0,
              color: Colors.grey[300],
            );
          },
        ),
    ],
  );
}
