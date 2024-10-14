import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/terminology_card_provider.dart';
import '../../widget/linear_indicator.dart';
import '../theme/color_theme.dart';
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
      create: (_) => TerminologyCardProvider()
        ..fetchWords(title)
        ..fetchBookmarkedWords(),
      child: Scaffold(
        backgroundColor: ColorTheme.colorNeutral,
        appBar: AppBar(
          backgroundColor: ColorTheme.colorWhite,
          title: Text(title),
          automaticallyImplyLeading: true,
          actions: [
            Consumer<TerminologyCardProvider>(
              builder: (context, provider, child) {
                return IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()),
                    );
                    provider.fetchBookmarkedWords();
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
                LinearIndicator(
                  current: wordsProvider.current + 1,
                  total: wordsProvider.words.length,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: wordsProvider.current < wordsProvider.words.length,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          "${wordsProvider.current + 1} / ${wordsProvider.words.length}",
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorTheme.colorDisabled,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: PageView.builder(
                      controller: wordsProvider.pageController,
                      itemCount: wordsProvider.words.length + 1,
                      onPageChanged: wordsProvider.setCurrentPage,
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
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          wordsProvider.current > 0
                              ? 'assets/images/arrow_back_active.png'
                              : 'assets/images/arrow_back_inactive.png',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                        onPressed: wordsProvider.current > 0
                            ? wordsProvider.previousPage
                            : null,
                      ),
                      IconButton(
                        icon: Image.asset(
                          wordsProvider.current < wordsProvider.words.length
                              ? 'assets/images/arrow_forward_active.png'
                              : 'assets/images/arrow_forward_inactive.png',
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.contain,
                        ),
                        onPressed: wordsProvider.current < wordsProvider.words.length
                            ? wordsProvider.nextPage
                            : null,
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
