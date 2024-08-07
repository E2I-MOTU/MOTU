import 'package:flutter/material.dart';

class SalesRecord extends StatelessWidget {
  const SalesRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '매매 일지',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderText('종목명\n매매 구분'),
                  _buildHeaderText('주문단가\n주문수량'),
                  _buildHeaderText('체결단가\n체결수량'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSalesRow('관련주 A', '현금 매도', '4,545', '100', '4,545', '100',
                  Colors.blue),
              _buildSalesRow(
                  '관련주 C', '현금 매수', '78,500', '10', '78,500', '10', Colors.red),
              _buildSalesRow(
                  '관련주 D', '현금 매수', '4,545', '50', '4,545', '50', Colors.red),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSalesRow(
      String name,
      String type,
      String orderPrice,
      String orderQuantity,
      String executionPrice,
      String executionQuantity,
      Color typeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(type, style: TextStyle(color: typeColor)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(orderPrice),
              Text(orderQuantity),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(executionPrice),
              Text(executionQuantity),
            ],
          ),
        ],
      ),
    );
  }
}
