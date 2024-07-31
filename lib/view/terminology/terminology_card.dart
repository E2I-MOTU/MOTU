import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../service/bookmark_service.dart';
import '../../provider/terminology_card_provider.dart';
import 'widget/terminology_card_builder.dart';
import 'widget/terminology_card_completion_builder.dart';

class TermCard extends StatelessWidget {
  final String title;
  final String documentName;
  final String uid;

  const TermCard({super.key, required this.title, required this.documentName, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TerminologyCardProvider()..fetchWords(title),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: true,
          actions: [
            Consumer<TerminologyCardProvider>(
              builder: (context, wordsProvider, child) {
                return IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    if (wordsProvider.words.isNotEmpty && wordsProvider.current < wordsProvider.words.length) {
                      BookmarkService().addBookmark(
                        wordsProvider.words[wordsProvider.current]['term'] ?? '',
                        wordsProvider.words[wordsProvider.current]['definition'] ?? '',
                        wordsProvider.words[wordsProvider.current]['example'] ?? '',
                        wordsProvider.words[wordsProvider.current]['category'] ?? '',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('책갈피에 저장되었습니다.')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<TerminologyCardProvider>(
          builder: (context, wordsProvider, child) {
            if (wordsProvider.words.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: wordsProvider.pageController,
                    itemCount: wordsProvider.words.length + 1,
                    onPageChanged: (index) {
                      wordsProvider.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      if (index == wordsProvider.words.length) {
                        return buildCompletionPage(context, title, documentName, uid);
                      } else {
                        return buildTermCard(
                          context,
                          wordsProvider.words[index]['term'] ?? '',
                          wordsProvider.words[index]['definition'] ?? '',
                          wordsProvider.words[index]['example'] ?? '',
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: wordsProvider.previousPage,
                        color: wordsProvider.current > 0 ? Colors.blue : Colors.grey,
                      ),
                      if (wordsProvider.current < wordsProvider.words.length)
                        Text(
                          "${wordsProvider.current + 1} / ${wordsProvider.words.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: wordsProvider.nextPage,
                        color: wordsProvider.current < wordsProvider.words.length ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
