import 'package:flutter/material.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';

import '../provider/navigation_provider.dart';
import '../view/main_page.dart';

Widget CommonDialog(BuildContext context) {
  Size size = MediaQuery.of(context).size;

  return AlertDialog(
    backgroundColor: Colors.white,
    content: Stack(
      children: [
        Positioned(
          right: -10,
          top: 0,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: MotuNormalButton(
                    context,
                    text: "아니요",
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: MotuCancelButton(
                    context: context,
                    text: "예",
                    onPressed: () {
                      final navService = Provider.of<NavigationService>(context,
                          listen: false);
                      navService.setSelectedIndex(2);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                        (route) => false, // 모든 기존 경로를 제거
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: size.height * 0.3,
          width: size.width * 0.8,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Text(
                "정말 나가실 건가요?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "중도 포기하면 투자했던 금액이 사라져요.",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
