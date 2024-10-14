import 'package:flutter/material.dart';
import '../../../design/color_theme.dart';

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림함'),
        backgroundColor: ColorTheme.White,
      ),
      body: const Center(
        child: Text(
          '준비 중입니다!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorTheme.Black1,
          ),
        ),
      ),
    );
  }
}
