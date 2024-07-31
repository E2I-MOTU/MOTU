import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widget/words_category_card_builder.dart';
import 'terminology_card.dart';

class WordsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('terminology').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var documents = snapshot.data!.docs;
        var filteredDocs = documents.where((doc) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data == null || data['word'] == null) return false;
          var words = data['word'] as Map<String, dynamic>;
          return words.keys.any((word) => word.contains(query));
        }).toList();

        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: filteredDocs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return buildCategoryCard(
              context,
              data['title'],
              data['catchphrase'],
              Colors.grey,
              WordsTermCard(title: data['title'], documentName: doc.id),
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('terminology').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        var documents = snapshot.data!.docs;
        var filteredDocs = documents.where((doc) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data == null || data['word'] == null) return false;
          var words = data['word'] as Map<String, dynamic>;
          return words.keys.any((word) => word.contains(query));
        }).toList();

        return GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: filteredDocs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return buildCategoryCard(
              context,
              data['title'],
              data['catchphrase'],
              Colors.grey,
              WordsTermCard(title: data['title'], documentName: doc.id),
            );
          }).toList(),
        );
      },
    );
  }
}
