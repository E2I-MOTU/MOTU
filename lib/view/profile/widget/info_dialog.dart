import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String title = "알림";
    String message =
        "죄송합니다 \u{1F625}\n\n기본 메일앱 사용이 불가능해서\n앱에서 바로 메일을 전송할 수 없습니다.\n\n아래 명시된 이메일로 문의 해주시면\n친절하고 빠르게 답변해드리도록\n하겠습니다 \u{1F60A}\n";

    return SizedBox(
      width: size.width * 0.7,
      height: size.height * 0.5,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const SelectableText(
                "e2i.engagetoinnovate@gmail.com",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Positioned(
            right: -15,
            top: -10,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
