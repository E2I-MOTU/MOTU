import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/terminology_card_provider.dart';
import 'widget/terminology_card_builder.dart';
import 'widget/terminology_card_completion_builder.dart';
import '../terminology/bookmark.dart';

class TermCard extends StatelessWidget {
  final String title;
  final String documentName;
  final String uid;

  const TermCard({super.key, required this.title, required this.documentName, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TerminologyCardProvider()..fetchWords(title)..fetchBookmarkedWords(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: Icon(Icons.bookmark_border),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookmarkPage()),
                );
                Provider.of<TerminologyCardProvider>(context, listen: false).fetchBookmarkedWords();
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
                        final word = wordsProvider.words[index];
                        final isBookmarked = wordsProvider.bookmarkedWords.contains(word['term']);
                        return buildTermCard(
                          context,
                          word['term']!,
                          word['definition']!,
                          word['example']!,
                          isBookmarked,
                              () {
                            wordsProvider.toggleBookmark(word['term']!);
                          },
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
