import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motu/view/theme/color_theme.dart';
import '../terminology/widget/terminology_category_card_builder.dart';

class CompletedTermPage extends StatelessWidget {
  const CompletedTermPage({super.key});

  Future<List<Map<String, dynamic>>> getCompletedCategories(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore
        .collection('user')
        .doc(uid)
        .collection('completedTerminology')
        .where('completed', isEqualTo: true)
        .get();

    List<Map<String, dynamic>> completedCategories = [];
    for (var doc in querySnapshot.docs) {
      var categorySnapshot =
          await firestore.collection('terminology').doc(doc.id).get();
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
      backgroundColor: ColorTheme.colorNeutral,
      appBar: AppBar(
        title: const Text('학습한 용어 목록'),
      ),
      body: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('오류가 발생했습니다.'));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('사용자를 찾을 수 없습니다.'));
          }

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: getCompletedCategories(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('오류가 발생했습니다.'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('학습 완료한 용어가 없습니다.'));
              }

              var completedCategories = snapshot.data!;
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.6 / 2,
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
          );
        },
      ),
    );
  }
}
