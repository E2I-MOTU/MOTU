import 'package:flutter/material.dart';
import 'package:motu/view/scenario/news/news_detail_page.dart';
import '../../../../model/scenario_news.dart';

Widget NewsListTile(BuildContext context, ScenarioNews news) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        !news.isRead
            ? Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/scenario/news_badge.png",
                        width: 10,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              )
            : const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    news.content,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: isRead 상태 변경
                print("Read News");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewsDetailPage(
                      news: news,
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                visualDensity: VisualDensity.compact,
                side: const BorderSide(color: Colors.purple, width: 1),
                minimumSize: const Size(48, 28),
              ),
              child: const Text(
                "뉴스 보기",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
