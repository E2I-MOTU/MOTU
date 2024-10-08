import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore 추가
import 'package:firebase_auth/firebase_auth.dart'; // 인증용 (uid 가져오기)
import '../../model/news_data.dart';
import '../../service/news_service.dart';
import 'news_list_item.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService _controller = NewsService();
  String _selectedTopic = 'All';
  Future<List<NewsArticle>>? _newsFuture;
  List<String> _defaultTopics = ['All', 'Technology', 'Science', 'Business']; // 기본 토픽 리스트
  List<String> _userTopics = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser!.uid; // 로그인된 사용자의 uid

  @override
  void initState() {
    super.initState();
    _fetchUserTopics(); // 사용자 토픽 가져오기
    _newsFuture = _controller.fetchNews('시사');
  }

  // 사용자 토픽을 Firestore에서 가져오는 함수
  Future<void> _fetchUserTopics() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user').doc(_uid).get();
      if (userDoc.exists && userDoc['topic'] != null) {
        setState(() {
          // 기본 토픽 + 사용자 정의 토픽
          _userTopics = _defaultTopics + List<String>.from(userDoc['topic']);
        });
      } else {
        // 기본 토픽만 설정
        setState(() {
          _userTopics = _defaultTopics;
        });
      }
    } catch (e) {
      print('사용자 토픽을 가져오는 중 오류 발생: $e');
    }
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
        const SnackBar(content: Text('Could not launch the URL')),
      );
    }
  }

  // 새로운 토픽을 Firestore에 추가하는 함수
  Future<void> _addNewTopic(String newTopic) async {
    try {
      await _firestore.collection('user').doc(_uid).update({
        'topic': FieldValue.arrayUnion([newTopic])
      });
      setState(() {
        _userTopics.add(newTopic); // 성공적으로 추가되면 로컬 리스트 업데이트
      });
    } catch (e) {
      print('새로운 토픽 추가 중 오류 발생: $e');
    }
  }

  // 토픽 삭제 함수
  Future<void> _removeTopic(String topic) async {
    try {
      await _firestore.collection('user').doc(_uid).update({
        'topic': FieldValue.arrayRemove([topic])
      });
      setState(() {
        _userTopics.remove(topic); // 삭제되면 로컬 리스트에서 제거
      });
    } catch (e) {
      print('토픽 삭제 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          '오늘의 시사',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ..._userTopics.map((String topic) {
                    final isSelected = _selectedTopic == topic;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _onTopicSelected(topic),
                        onLongPress: _defaultTopics.contains(topic)
                            ? null // 기본 토픽은 삭제할 수 없도록 설정
                            : () => _showRemoveTopicDialog(topic), // 길게 눌렀을 때 삭제 확인
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isSelected ? const Color(0xff701FFF) : Colors.white,
                          side: const BorderSide(
                            color: Color(0xff701FFF),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          topic,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xff701FFF),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      onPressed: () async {
                        final newTopic = await _showAddTopicDialog();
                        if (newTopic != null && newTopic.isNotEmpty) {
                          _addNewTopic(newTopic); // 새 토픽을 Firestore에 추가
                        }
                      },
                      icon: const Icon(
                        Icons.add, // 플러스 아이콘 사용
                        color: Color(0xff701FFF), // 플러스 아이콘 컬러
                        size: 30.0, // 아이콘 크기
                      ),
                      splashRadius: 24.0, // 아이콘 주변의 터치 영역 반경 설정
                      padding: EdgeInsets.zero, // 패딩을 없앰 (투명 배경 효과)
                      constraints: const BoxConstraints(), // 기본 크기 제한을 없앰
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NewsArticle>>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available'));
                } else {
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 16.0,
                      endIndent: 16.0,
                    ),
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

  Future<String?> _showAddTopicDialog() {
    TextEditingController _textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('새로운 토픽 추가'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: '토픽 입력'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                Navigator.of(context).pop(_textController.text);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRemoveTopicDialog(String topic) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('토픽 삭제'),
          content: Text('토픽 "$topic"을(를) 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                _removeTopic(topic); // Firebase에서 토픽 삭제
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
