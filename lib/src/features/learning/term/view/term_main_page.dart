import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/common/service/navigation_service.dart';
import 'package:motu/src/features/learning/term/view/widget/terminology_category_card_builder.dart';
import 'package:motu/src/common/service/text_utils.dart';
import 'package:motu/src/common/view/nav_page.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:shimmer/shimmer.dart'; // Make sure to add the shimmer package to your pubspec.yaml
import 'term_card.dart';
import 'bookmark_page.dart';
import 'term_search.dart';
import 'package:provider/provider.dart';
import '../../../login/service/auth_service.dart';

class TermMainPage extends StatelessWidget {
  const TermMainPage({super.key});

  Future<bool> checkCompletionStatus(String uid, String docId) async {
    final firestore = FirebaseFirestore.instance;
    final userQuizRef = firestore
        .collection('user')
        .doc(uid)
        .collection('completedTerminology')
        .doc(docId);
    final snapshot = await userQuizRef.get();
    if (snapshot.exists) {
      return snapshot.data()?['completed'] ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: ColorTheme.colorNeutral,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('용어학습'),
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () {
            NavigationService().setSelectedIndex(1);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const NavPage(),
              ),
              (route) => false, // Remove all existing routes
            );
          },
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TermSearchDelegate(uid: service.user!.uid),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('terminology')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1.6 / 2,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        children: List.generate(
                          6,
                          (index) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                var documents = snapshot.data!.docs;

                List<Widget> completedCategories = [];
                List<Widget> incompleteCategories = [];

                return FutureBuilder<List<bool>>(
                  future: Future.wait(documents
                      .map((doc) =>
                          checkCompletionStatus(service.user!.uid, doc.id))
                      .toList()),
                  builder: (context, completionSnapshots) {
                    if (completionSnapshots.connectionState ==
                        ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 1.6 / 2,
                          padding: const EdgeInsets.all(20),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          children: List.generate(
                            6,
                            (index) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    for (var i = 0; i < documents.length; i++) {
                      var doc = documents[i];
                      var data = doc.data() as Map<String, dynamic>;
                      var isCompleted = completionSnapshots.data?[i] ?? false;

                      var categoryCard = TermCategoryCardBuilder(
                        context,
                        data['title'],
                        preventWordBreak(data['catchphrase']),
                        Colors.white,
                        TermCard(
                          title: data['title'],
                          documentName: doc.id,
                          uid: service.user!.uid,
                        ),
                        isCompleted,
                      );

                      if (isCompleted) {
                        completedCategories.add(categoryCard);
                      } else {
                        incompleteCategories.add(categoryCard);
                      }
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6 / 2,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: incompleteCategories + completedCategories,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
