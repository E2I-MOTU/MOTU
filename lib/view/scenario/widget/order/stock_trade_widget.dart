import 'package:flutter/material.dart';
import 'package:motu/provider/scenario_service.dart';
import 'package:motu/util/util.dart';
import 'package:motu/widget/motu_button.dart';
import 'package:provider/provider.dart';

enum StockTradeType { buy, sell }

class StockTradeWidget extends StatefulWidget {
  final StockTradeType tradeType;

  const StockTradeWidget({
    super.key,
    required this.tradeType,
  });

  @override
  StockTradeWidgetState createState() => StockTradeWidgetState();
}

class StockTradeWidgetState extends State<StockTradeWidget> {
  int _quantity = 1;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = _quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        width: screenSize.width * 0.8,
        height: screenSize.height * 0.4,
        child: Column(
          children: [
            Text(
              widget.tradeType == StockTradeType.buy ? '매수' : '매도',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.tradeType == StockTradeType.buy
                    ? Colors.red
                    : Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              service.selectedStock,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // add border
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) _quantity--;
                              _quantityController.text = _quantity.toString();
                            });
                          },
                        ),
                        Expanded(
                          child: SizedBox(
                            width: screenSize.width,
                            child: TextField(
                              controller: _quantityController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                suffixText: '주', // 여기에 원하는 텍스트를 넣습니다.
                                suffixStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ), // 스타일 지정
                                contentPadding: EdgeInsets.only(
                                    right: 10, left: 24), // 내부 패딩 조정
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _quantity = int.tryParse(value) ?? 1;
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _quantity++;
                              _quantityController.text = _quantity.toString();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.tradeType == StockTradeType.buy
                          ? Text(
                              '1주 구매가',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            )
                          : Text(
                              '1주 판매가',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                      Text(
                        '${Formatter.format(service.visibleStockData.last.close.toInt())}원',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.tradeType == StockTradeType.buy
                          ? Text(
                              '구매금액',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            )
                          : Text(
                              '판매금액',
                              style: TextStyle(
                                color: Colors.grey[700],
                              ),
                            ),
                      Text(
                        '${Formatter.format((_quantity * service.visibleStockData.last.close).toInt())}원',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: MotuCancelButton(
                    context: context,
                    text: "취소",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MotuNormalButton(
                    context,
                    text: "확인",
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      print("매도 매수");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
