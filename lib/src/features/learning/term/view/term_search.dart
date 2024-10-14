import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/features/learning/term/view/widget/terminology_category_card_builder.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/common/service/text_utils.dart'; // preventWordBreak 가져오기
import 'term_card.dart';

class TermSearchDelegate extends SearchDelegate {
  final String uid;

  TermSearchDelegate({required this.uid});

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
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.white, // 앱바 배경색
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: Colors.grey, // 힌트 텍스트 색상
          fontSize: 12, // 힌트 텍스트 폰트 크기
        ),
        filled: true,
        fillColor: ColorTheme.colorNeutral, // 텍스트 필드 배경색
        contentPadding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 20), // 텍스트 필드 내부 패딩
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30), // 텍스트 필드에 라운드 모양 추가
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => '검색어 입력';

  @override
  TextStyle get searchFieldStyle => const TextStyle(
        fontSize: 12, // 입력 텍스트 폰트 크기
        color: Colors.black, // 입력 텍스트 색상
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
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
        stream:
            FirebaseFirestore.instance.collection('terminology').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  if (completionSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return TermCategoryCardBuilder(
                    context,
                    data['title'],
                    preventWordBreak(
                        data['catchphrase']), // preventWordBreak 사용
                    Colors.grey,
                    TermCard(
                        title: data['title'], documentName: doc.id, uid: uid),
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
