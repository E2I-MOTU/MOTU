import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:speech_balloon/speech_balloon.dart';
import '../../theme/color_theme.dart';

Widget buildTermCard(BuildContext context, String term, String definition, String example, bool isBookmarked, VoidCallback onBookmarkToggle) {
  final size = MediaQuery.of(context).size;
  final cardWidth = size.width * 0.9;
  final cardHeight = size.height * 0.55;

  return Center(
    child: Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        // 카드 앞면
        front: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  term,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                ),
                onPressed: onBookmarkToggle,
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpeechBalloon(
                    nipLocation: NipLocation.right,
                    color: ColorTheme.colorPrimary,
                    width: 140,
                    height: 40,
                    borderRadius: 10,
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        '용어 뜻을 알고 싶다면\n클릭해서 뒤집어 보세요!',
                        style: TextStyle(
                          fontSize: 10,
                          color: ColorTheme.colorWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/images/panda.png',
                    height: 80,
                  ),
                ],
              ),
            ),
          ],
        ),

        // 카드 뒷면
        back: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                '${term}(이)란?',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                definition,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 40),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: ColorTheme.colorPrimary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: _buildExampleTextSpans(example, term),
                      ),
                    ),
                  ),
                  Positioned(
                    top: -14,
                    left: -10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                        color: ColorTheme.colorPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '예시',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

List<TextSpan> _buildExampleTextSpans(String example, String term) {
  List<TextSpan> spans = [];
  int start = 0;
  int termStartIndex;

  while ((termStartIndex = example.indexOf(term, start)) != -1) {
    if (termStartIndex > start) {
      spans.add(TextSpan(text: example.substring(start, termStartIndex)));
    }
    spans.add(
      TextSpan(
        text: term,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
    start = termStartIndex + term.length;
  }

  if (start < example.length) {
    spans.add(TextSpan(text: example.substring(start)));
  }

  return spans;
}
