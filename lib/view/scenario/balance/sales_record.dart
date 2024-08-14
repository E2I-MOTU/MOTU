import 'package:flutter/material.dart';

class SalesRecord extends StatelessWidget {
  const SalesRecord({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '매매 일지',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderText('종목명 / 매매 구분'),
                  _buildHeaderText('체결단가 / 체결수량'),
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 10),
              _buildSalesRow(
                  '관련주 A / 현금 매도', '4,545 / 100주', Colors.blue, screenSize),
              _buildSalesRow(
                  '관련주 C / 현금 매수', '78,500 / 10주', Colors.red, screenSize),
              _buildSalesRow(
                  '관련주 D / 현금 매수', '4,545 / 50주', Colors.red, screenSize),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildSalesRow(
      String name, String executionInfo, Color typeColor, Size size) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: name.split(' / ')[0],
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                    text: ' / ',
                    style: TextStyle(color: Colors.black)), // 공백 추가
                TextSpan(
                  text: name.split(' / ')[1],
                  style: TextStyle(color: typeColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(executionInfo, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
