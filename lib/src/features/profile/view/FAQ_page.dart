import 'package:flutter/material.dart';
import '../../../design/color_theme.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: ColorTheme.White,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
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
