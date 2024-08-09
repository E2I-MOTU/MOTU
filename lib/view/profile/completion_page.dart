import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../terminology/widget/terminology_category_card_builder.dart';

class CompletionPage extends StatelessWidget {
  final String uid;

  const CompletionPage({Key? key, required this.uid}) : super(key: key);

  Future<List<Map<String, dynamic>>> getCompletedCategories(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('users').doc(uid).collection('terminology_quiz').where('completed', isEqualTo: true).get();
    List<Map<String, dynamic>> completedCategories = [];
    for (var doc in querySnapshot.docs) {
      var categorySnapshot = await firestore.collection('terminology').doc(doc.id).get();
      if (categorySnapshot.exists) {
        completedCategories.add({
          'id': doc.id,
          'title': categorySnapshot.data()!['title'],
          'catchphrase': categorySnapshot.data()!['catchphrase'],
        });
      }
    }
    return completedCategories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('수료 완료'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getCompletedCategories(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('수료된 카테고리가 없습니다.'));
          }

          var completedCategories = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: completedCategories.length,
            itemBuilder: (context, index) {
              var category = completedCategories[index];
              return buildCategoryCard(
                context,
                category['title'],
                category['catchphrase'],
                Colors.white,
                null,
                true,
              );
            },
          );
        },
      ),
    );
  }
}
