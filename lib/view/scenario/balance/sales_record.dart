import 'package:flutter/material.dart';
import 'package:motu/service/scenario_service.dart';
import 'package:provider/provider.dart';

class SalesRecord extends StatelessWidget {
  const SalesRecord({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                '투자 일지',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            service.investRecords.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHeaderText('종목명 | 매매 구분'),
                          _buildHeaderText('체결단가 | 체결수량'),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      Column(
                        children: service.investRecords.map<Widget>((record) {
                          return _buildSalesRow(
                              "${record.stock} / ${record.type == TransactionType.buy ? '매수' : '매도'}",
                              "${record.price} | ${record.amount}주",
                              record.type == TransactionType.buy
                                  ? Colors.red
                                  : Colors.blue,
                              screenSize);
                        }).toList(),
                      ),
                    ],
                  )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "투자한 기록이 없습니다.",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      );
    });
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: name.split(' / ')[0],
                  style:
                      TextStyle(color: typeColor, fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: ' | ', style: TextStyle(color: typeColor)), // 공백 추가
                TextSpan(
                  text: name.split(' / ')[1],
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                executionInfo,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
