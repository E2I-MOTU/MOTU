import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future<List<NewsArticle>>? _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _controller.fetchNews('시사');
  }

  void _onTopicSelected(String topic) {
    setState(() {
      _selectedTopic = topic;
      _newsFuture = _controller.fetchNews(topic == 'All' ? '시사' : topic);
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => _onTopicSelected(topic),
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
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No news available'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: NewsListItem(
                          article: article,
                          onTap: () => _launchURL(article.link),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
