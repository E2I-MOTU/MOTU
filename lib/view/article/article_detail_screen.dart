import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:motu/text_utils.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<String>(
              future: getImageUrl(article.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == '') {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey,
                    child: Icon(Icons.error, color: Colors.white, size: 50),
                  );
                } else {
                  return Image.network(
                    snapshot.data!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  );
                }
              },
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
                  SizedBox(height: 10),
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
                  Text(
                    preventWordBreak(article.content),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  MarkdownBody(
                    data: article.content.replaceAll('\\n', '\n'),
                    styleSheet: CustomMarkdownStyle.fromTheme(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
