import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/view/terminology/widget/terminology_category_card_builder.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'terminology_card.dart';

class TermSearchDelegate extends SearchDelegate {
  final String uid;

  TermSearchDelegate({required this.uid});

  Future<bool> checkCompletionStatus(String uid, String docId) async {
    final firestore = FirebaseFirestore.instance;
    final userQuizRef = firestore.collection('users').doc(uid).collection('terminology_quiz').doc(docId);
    final snapshot = await userQuizRef.get();
    if (snapshot.exists) {
      return snapshot.data()?['completed'] ?? false;
    }
    return false;
  }

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
    return _buildSearchResultsOrSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResultsOrSuggestions();
  }

  Widget _buildSearchResultsOrSuggestions() {
    return Container(
      color: ColorTheme.colorNeutral,
      child: StreamBuilder<QuerySnapshot>(
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

          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 0.8, // 카드 비율
            ),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              var doc = filteredDocs[index];
              var data = doc.data() as Map<String, dynamic>;
              return FutureBuilder<bool>(
                future: checkCompletionStatus(uid, doc.id),
                builder: (context, completionSnapshot) {
                  if (completionSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return buildCategoryCard(
                    context,
                    data['title'],
                    data['catchphrase'],
                    Colors.grey,
                    TermCard(title: data['title'], documentName: doc.id, uid: uid),
                    completionSnapshot.data ?? false,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
