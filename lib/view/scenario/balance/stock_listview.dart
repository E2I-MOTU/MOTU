import 'package:flutter/material.dart';

class StockListView extends StatelessWidget {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '보유 주식',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('관련주',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                '+9.5%\n+285,000',
                style: TextStyle(fontSize: 18, color: Colors.red),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        StockItem(
          logo: Icons.apple,
          name: '관련주 A',
          amount: 100,
          value: '4,545',
        ),
        StockItem(
          logo: Icons.adobe,
          name: '관련주 B',
          amount: 100,
          value: '78,500',
        ),
        StockItem(
          logo: Icons.web,
          name: '관련주 C',
          amount: 100,
          value: '4,545',
        ),
      ],
    );
  }

  Widget StockItem(
      {required IconData logo,
      required String name,
      required int amount,
      required String value}) {
    return ListTile(
      leading: Icon(logo, size: 40),
      title: Text(name),
      subtitle: Text('$amount주'),
      trailing: Text(value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
