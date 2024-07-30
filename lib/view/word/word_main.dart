import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widget/words_category_card_builder.dart';
import 'words_term_card.dart';
import 'bookmark.dart';
import 'words_search_delegate.dart';

class WordsMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('용어카드'),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: WordsSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('terminology').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var documents = snapshot.data!.docs;
                return GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: documents.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    return buildCategoryCard(context, data['title'], data['catchphrase'], Colors.grey, WordsTermCard(title: data['title']));
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}