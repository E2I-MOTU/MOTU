import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import '../../service/bookmark_service.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService _bookmarkService = BookmarkService();
  late Future<List<Map<String, dynamic>>> _bookmarksFuture;

  @override
  void initState() {
    super.initState();
    _bookmarksFuture = _bookmarkService.getBookmarks();
  }

  Future<void> _refreshBookmarks() async {
    setState(() {
      _bookmarksFuture = _bookmarkService.getBookmarks();
    });
  }

  Future<void> _deleteBookmark(String bookmarkId) async {
    await _bookmarkService.deleteBookmark(bookmarkId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('북마크가 삭제되었습니다.')),
    );
    _refreshBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('책갈피'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _bookmarksFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('저장된 책갈피가 없습니다.'));
          }

          List<Map<String, dynamic>> bookmarks = snapshot.data!;
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Card(
                  child: ListTile(
                    title: _buildCard(
                      context,
                      bookmarks[index]['term'] ?? '',
                      bookmarks[index]['definition'] ?? '',
                      bookmarks[index]['example'] ?? '',
                      bookmarks[index]['category'] ?? '',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteBookmark(bookmarks[index]['id']);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, String term, String definition, String example, String category) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    term,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '카테고리: $category',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          back: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    definition,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '예시: $example',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
