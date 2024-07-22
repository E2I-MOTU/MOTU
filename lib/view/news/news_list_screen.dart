import 'package:flutter/material.dart';
import '../../model/news_article.dart';
import '../../service/news_service.dart';
import 'news_list_item.dart';


class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsController _controller = NewsController();
  String _selectedTopic = 'All';

  @override
  Widget build(BuildContext context) {
    List<NewsArticle> articles = _selectedTopic == 'All'
        ? _controller.allArticles
        : _controller.getArticlesByTopic(_selectedTopic);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'News',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <String>['All', 'Technology', 'Science', 'Business']
                    .map((String topic) {
                  final isSelected = _selectedTopic == topic;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedTopic = topic;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Color(0xff701FFF)
                            : Colors.white,
                        side: BorderSide(
                          color: Color(0xff701FFF),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        topic,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Color(0xff701FFF),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: NewsListItem(
                      article: article,
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
