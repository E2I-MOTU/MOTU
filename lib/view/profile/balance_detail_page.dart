import 'package:flutter/material.dart';

class BalanceDetailPage extends StatelessWidget {
  final int balance;

  const BalanceDetailPage({Key? key, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('잔고 상세'),
      ),
      body: Center(
        child: Text(
          '잔고 상세 페이지\n현재 잔고: $balance 원',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}