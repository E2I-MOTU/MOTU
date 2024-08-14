import 'package:flutter/material.dart';

class SecondPageView extends StatelessWidget {
  const SecondPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "종목 정보",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.2,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildInfoCard(
                  context,
                  title: "시가총액",
                  value: "1,000억원",
                  onTap: () {
                    print("시가총액 클릭");
                  },
                ),
                _buildInfoCard(
                  context,
                  title: "배당수익률",
                  value: "2.5%",
                  onTap: () {
                    print("배당수익률 클릭");
                  },
                ),
                _buildInfoCard(
                  context,
                  title: "PBR",
                  value: "1.2",
                  onTap: () {
                    print("PBR 클릭");
                  },
                ),
                _buildInfoCard(
                  context,
                  title: "PER",
                  value: "15.3",
                  onTap: () {
                    print("PER 클릭");
                  },
                ),
                _buildInfoCard(
                  context,
                  title: "ROE",
                  value: "12.5%",
                  onTap: () {
                    print("ROE 클릭");
                  },
                ),
                _buildInfoCard(
                  context,
                  title: "PSR",
                  value: "1.8",
                  onTap: () {
                    print("PSR 클릭");
                  },
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: _buildFinancialTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    context, {
    required String title,
    required String value,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Image.asset(
                'assets/images/scenario/info_icon.png',
                width: 13,
                height: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialTable() {
    final List<String> years = ["", "22년 3월", "22년 6월", "22년 9월", "22년 12월"];
    final List<String> items = ["매출액", "영업이익", "당기순이익", "자산총계", "부채총계"];

    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(1.25),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      children: [
        _buildTableRow(years, isHeader: true),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          String item = entry.value;
          return _buildTableRow([
            item,
            _getItemData(item, 0),
            _getItemData(item, 1),
            _getItemData(item, 2),
            _getItemData(item, 3),
          ], isItemRow: true, itemIndex: index);
        }),
      ],
    );
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, bool isItemRow = false, int itemIndex = -1}) {
    return TableRow(
      children: cells.asMap().entries.map((entry) {
        int index = entry.key;
        String cell = entry.value;
        bool isItemCell = isItemRow && index == 0;

        return TableCell(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            alignment: Alignment.centerRight,
            child: isItemCell
                ? Row(
                    children: [
                      Image.asset(
                        'assets/images/scenario/info_icon.png',
                        width: 12,
                        height: 12,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        cell,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                : Text(
                    cell,
                    style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: isHeader ? 13 : 12,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  String _getItemData(String item, int yearIndex) {
    final Map<String, List<String>> data = {
      "매출액": ["120억", "150억", "180억", "200억"],
      "영업이익": ["15억", "20억", "25억", "30억"],
      "당기순이익": ["12억", "16억", "20억", "24억"],
      "자산총계": ["550억", "600억", "650억", "700억"],
      "부채총계": ["220억", "240억", "260억", "11280억"],
    };
    return data[item]![yearIndex];
  }
}
