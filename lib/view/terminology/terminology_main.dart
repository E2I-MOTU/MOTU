import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/view/terminology/widget/terminology_category_card_builder.dart';
import 'terminology_card.dart';
import 'bookmark.dart';
import 'terminology_search.dart';

class TermMain extends StatelessWidget {
  final String uid;

  const TermMain({Key? key, required this.uid}) : super(key: key);

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
                delegate: TermSearchDelegate(uid: uid),
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
                    return FutureBuilder<bool>(
                      future: checkCompletionStatus(uid, doc.id),
                      builder: (context, completionSnapshot) {
                        if (completionSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
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
