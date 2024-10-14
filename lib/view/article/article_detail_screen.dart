import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:motu/view/article/widget/skeleton.dart';
import '../../model/article_data.dart';
import '../theme/markdown.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  Future<String> getImageUrl(String imagePath) async {
    try {
      return await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    } catch (e) {
      print("Error getting image URL: $e");
      return '';
    }
  }

  // 스켈레톤과 SizedBox를 생성하는 함수
  Widget buildSkeleton(double width, double height, {double? paddingBottom}) {
    return Column(
      children: [
        Skeleton(width: width, height: height),
        if (paddingBottom != null) SizedBox(height: paddingBottom),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<String>(
        future: getImageUrl(article.imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Skeleton(width: double.infinity, height: 250),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSkeleton(100, 30, paddingBottom: 16),
                      buildSkeleton(double.infinity, 24, paddingBottom: 12),
                      buildSkeleton(200, 24, paddingBottom: 40),
                      buildSkeleton(150, 24, paddingBottom: 10),
                      for (int i = 0; i < 5; i++) buildSkeleton(double.infinity, 20, paddingBottom: 10),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
            return Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey,
              child: Icon(Icons.error, color: Colors.white, size: 50),
            );
          } else {
            // 이미지와 모든 데이터를 로드한 후에 한번에 표시
            return SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    snapshot.data!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    transform: Matrix4.translationValues(0.0, -20.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: article.topics.map((topic) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Color(0xff701FFF),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                topic,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        MarkdownBody(
                          data: article.content.replaceAll('\\n', '\n'),
                          styleSheet: CustomMarkdownStyle.fromTheme(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
