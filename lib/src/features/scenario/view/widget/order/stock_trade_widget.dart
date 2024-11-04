import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:motu/src/features/scenario/model/invest_record.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/common/util/util.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:motu/src/common/view/widget/motu_button.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

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

    return Consumer<AuthService>(builder: (context, auth, child) {
      return Consumer<ScenarioService>(builder: (context, service, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.55,
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
                          color: ColorTheme.Grey2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: ColorTheme.Grey2,
                                ),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                  _quantityController.text =
                                      _quantity.toString();
                                });
                              },
                            ),
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
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: ColorTheme.Grey2,
                                ),
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                  _quantityController.text =
                                      _quantity.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.tradeType == StockTradeType.buy
                            ? "최대 구매 가능 : ${(auth.user!.balance / service.visibleStockData.last.close).truncate()}주"
                            : "판매 가능 : ${service.investStocks[service.selectedStock]![0]}주",
                        style: const TextStyle(
                          fontSize: 13,
                          color: ColorTheme.Black4,
                        ),
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
                          '총 ${Formatter.format((_quantity * service.visibleStockData.last.close).toInt())}원',
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
                        log("매도 매수");
                        switch (widget.tradeType) {
                          case StockTradeType.buy:
                            log("매수 종목 : ${service.selectedStock}");
                            log("매수 수량 : $_quantity");
                            log("매수 종목가 : ${service.visibleStockData.last.close}");
                            log("매수 금액 : ${_quantity * service.visibleStockData.last.close}");

                            if ((auth.user!.balance /
                                        service.visibleStockData.last.close)
                                    .truncate() <
                                _quantity) {
                              toastification.show(
                                type: ToastificationType.warning,
                                title: const Text("알림"),
                                description: const Text("구매 가능 수량을 초과하였습니다."),
                                autoCloseDuration: const Duration(seconds: 2),
                                alignment: Alignment.topCenter,
                                showProgressBar: false,
                                primaryColor: Colors.red,
                              );
                              return;
                            } else {
                              // investStocks에 저장 & balance에서 뺌
                              auth.setUserBalance(auth.user!.balance -
                                  (_quantity *
                                          service.visibleStockData.last.close)
                                      .toInt());
                              service.setInvestStocks(service.selectedStock,
                                  TransactionType.buy, _quantity);
                              // investRecord에 저장
                              InvestRecord record = InvestRecord(
                                stock: service.selectedStock,
                                type: TransactionType.buy,
                                price:
                                    service.visibleStockData.last.close.toInt(),
                                amount: _quantity,
                              );
                              service.setInvestRecords(record);
                              service.updateTotalPurchasePrice();

                              toastification.show(
                                type: ToastificationType.success,
                                title: const Text("알림"),
                                description: const Text("매수가 완료되었습니다."),
                                autoCloseDuration: const Duration(seconds: 2),
                                alignment: Alignment.topCenter,
                                showProgressBar: false,
                                primaryColor: Colors.blue,
                              );
                              Navigator.pop(context);
                            }
                            break;
                          case StockTradeType.sell:
                            log("매도 종목 : ${service.selectedStock}");
                            log("매도 수량 : $_quantity");
                            log("매도 종목가 : ${service.visibleStockData.last.close}");
                            log("매도 금액 : ${_quantity * service.visibleStockData.last.close}");

                            if (service
                                    .investStocks[service.selectedStock]![0] <
                                _quantity) {
                              toastification.show(
                                type: ToastificationType.warning,
                                title: const Text("알림"),
                                description: const Text("판매 가능 수량을 초과하였습니다."),
                                autoCloseDuration: const Duration(seconds: 2),
                                alignment: Alignment.topCenter,
                                showProgressBar: false,
                                primaryColor: Colors.red,
                              );
                              return;
                            } else {
                              // investStocks에 저장 & balance에서 더함
                              auth.setUserBalance(auth.user!.balance +
                                  (_quantity *
                                          service.visibleStockData.last.close)
                                      .toInt());

                              // investRecord에 저장
                              InvestRecord record = InvestRecord(
                                stock: service.selectedStock,
                                type: TransactionType.sell,
                                price:
                                    service.visibleStockData.last.close.toInt(),
                                amount: _quantity,
                              );
                              service.setInvestRecords(record);
                              service.updateTotalPurchasePrice();
                              service.updateRealizedPnL(record);

                              service.setInvestStocks(service.selectedStock,
                                  TransactionType.sell, _quantity);

                              toastification.show(
                                type: ToastificationType.success,
                                title: const Text("알림"),
                                description: const Text("매도가 완료되었습니다."),
                                autoCloseDuration: const Duration(seconds: 2),
                                alignment: Alignment.topCenter,
                                showProgressBar: false,
                                primaryColor: Colors.blue,
                              );
                              Navigator.pop(context);
                            }

                            break;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }
}
