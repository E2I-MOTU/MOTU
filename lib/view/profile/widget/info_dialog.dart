import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String title = "알림";
    String message =
        "죄송합니다 \u{1F625}\n\n기본 메일앱 사용이 불가능해서\n앱에서 바로 메일을 전송할 수 없습니다.\n\n아래 명시된 이메일로 연락주시면\n친절하고 빠르게 답변해드리도록\n하겠습니다 \u{1F60A}\n";

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const SelectableText(
            "21900215@handong.ac.kr",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Dialog 닫기 동작
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
