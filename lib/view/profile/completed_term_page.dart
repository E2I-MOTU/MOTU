import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompletedTermPage extends StatelessWidget {
  const CompletedTermPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('학습한 용어 목록'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              CupertinoIcons.check_mark_circled,
              size: 100,
              color: Color(0xFF4CAF50),
            ),
            SizedBox(height: 16),
            Text(
              '약관 동의가 완료되었습니다.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
