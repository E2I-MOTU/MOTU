import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/bookmark_service.dart';
import '../../service/words_card_service.dart';
import '../../widget/words_term_card_builder.dart';


class WordsTermCard extends StatelessWidget {
  final String title;
  const WordsTermCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordsProvider()..fetchWords(title),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: true,
          actions: [
            Consumer<WordsProvider>(
              builder: (context, wordsProvider, child) {
                return IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    if (wordsProvider.words.isNotEmpty) {
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
        body: Consumer<WordsProvider>(
          builder: (context, wordsProvider, child) {
            if (wordsProvider.words.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: wordsProvider.pageController,
                    itemCount: wordsProvider.words.length,
                    onPageChanged: (index) {
                      wordsProvider.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      return buildTermCard(
                        context,
                        wordsProvider.words[index]['term'] ?? '',
                        wordsProvider.words[index]['definition'] ?? '',
                        wordsProvider.words[index]['example'] ?? '',
                      );
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
                        color: wordsProvider.current < wordsProvider.words.length - 1 ? Colors.blue : Colors.grey,
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