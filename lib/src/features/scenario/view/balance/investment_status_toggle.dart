import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/features/scenario/service/scenario_service.dart';
import 'package:motu/src/common/util/util.dart';
import 'package:provider/provider.dart';

class InvestmentStatusToggle extends StatefulWidget {
  final bool haveTitle;
  const InvestmentStatusToggle({super.key, required this.haveTitle});

  @override
  InvestmentStatusToggleState createState() => InvestmentStatusToggleState();
}

class InvestmentStatusToggleState extends State<InvestmentStatusToggle> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ScenarioService>(builder: (context, service, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.haveTitle
                ? const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "투자 현황",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  )
                : const SizedBox(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: -5,
                      child: AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: IconButton(
                          icon: const Icon(
                            CupertinoIcons.chevron_down,
                            size: 18,
                          ),
                          color: Colors.grey[350],
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 16.0),
                            child: Text(
                              Formatter.format(service.totalRatingPrice),
                              style: const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  24.0, 0, 24.0, 16.0),
                              child: service.unrealizedPnL == 0
                                  ? Text(
                                      '실현 손익 : ${service.realizedPnL}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Row(
                                      children: [
                                        Text(
                                          service.unrealizedPnL > 0
                                              ? '+${Formatter.format(service.unrealizedPnL)}'
                                              : Formatter.format(
                                                  service.unrealizedPnL),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: service.unrealizedPnL == 0
                                                ? Colors.black
                                                : service.unrealizedPnL > 0
                                                    ? Colors.red
                                                    : Colors.blue,
                                          ),
                                        ),
                                        service.totalPurchasePrice == 0
                                            ? const SizedBox()
                                            : Text(
                                                service.totalRatingPrice == 0
                                                    ? ''
                                                    : service.totalEarningRate >
                                                            0
                                                        ? ' (+${service.totalEarningRate.toStringAsFixed(1)}%)'
                                                        : " (${service.totalEarningRate.toStringAsFixed(1)}%)",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: service.unrealizedPnL +
                                                              service
                                                                  .realizedPnL ==
                                                          0
                                                      ? Colors.black
                                                      : service.unrealizedPnL +
                                                                  service
                                                                      .realizedPnL >
                                                              0
                                                          ? Colors.red
                                                          : Colors.blue,
                                                ),
                                              ),
                                        service.unrealizedPnL == 0
                                            ? const SizedBox()
                                            : Icon(
                                                service.unrealizedPnL > 0
                                                    ? Icons.arrow_drop_up_sharp
                                                    : Icons
                                                        .arrow_drop_down_sharp,
                                                color: service.unrealizedPnL > 0
                                                    ? Colors.red
                                                    : Colors.blue,
                                              ),
                                      ],
                                    )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _isExpanded ? 16 : 0,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _isExpanded
                      ? [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                height: _isExpanded ? null : 0,
                width: double.infinity,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPnLRow('총 손익',
                          service.unrealizedPnL + service.realizedPnL, service),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          '총 매입',
                          Formatter.format(service.totalPurchasePrice),
                          Colors.black),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                          '총 평가',
                          Formatter.format(service.totalRatingPrice),
                          Colors.black),
                      const SizedBox(height: 8),
                      _buildPnLRow('평가 손익', service.unrealizedPnL, service),
                      const SizedBox(height: 8),
                      _buildPnLRow('실현 손익', service.realizedPnL, service),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildPnLRow(String label, int value, ScenarioService service) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              value == 0
                  ? '0'
                  : '${value > 0 ? '+' : '-'}${Formatter.format(value.abs())}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: value == 0
                    ? Colors.black
                    : value > 0
                        ? Colors.red
                        : Colors.blue,
              ),
            ),
            // label == '총 손익'
            //     ? Text(
            //         ' (${((service.totalRatingPrice - service.totalPurchasePrice) / service.totalPurchasePrice * 100).toStringAsFixed(1)}%)',
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //           color: value == 0
            //               ? Colors.black
            //               : value > 0
            //                   ? Colors.red
            //                   : Colors.blue,
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
