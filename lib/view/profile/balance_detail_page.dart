import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/service/auth_service.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'package:provider/provider.dart';

import '../../util/util.dart';

class BalanceDetailPage extends StatelessWidget {
  const BalanceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, service, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('잔고 내역'),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.fromLTRB(24.0, 16, 24.0, 16), // 내부 padding

                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/profile/balance_icon.png",
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 8.0),
                            const Text(
                              '보유 자산',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          Formatter.format(service.user.balance),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                            color: ColorTheme.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36.0),
              Row(
                children: [
                  const Text(
                    "상세 내역",
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorTheme.Black4,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      log("🔍 Filter button clicked");
                    },
                    child: const Row(
                      children: [
                        Text(
                          "1개월, 전체, 최신순",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorTheme.Black4,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 15,
                          color: ColorTheme.Black4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: ColorTheme.Black5,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: service.user.balanceHistory.length,
                  itemBuilder: (context, index) {
                    final detail = service.user.balanceHistory[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: ColorTheme.Grey1, // 원하는 배경색
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // 그림자 색상
                            blurRadius: 5,
                            offset: const Offset(0, 3), // 그림자 위치
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          detail.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: ColorTheme.Black1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${detail.date.year}년 ${detail.date.month}월 ${detail.date.day}일',
                          style: const TextStyle(
                            fontSize: 12,
                            color: ColorTheme.Black4,
                          ),
                        ),
                        trailing: Text(
                          '${detail.isIncome ? '+' : '-'} ${Formatter.format(detail.amount)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: detail.isIncome ? Colors.green : Colors.red,
                          ),
                        ),
                        // dense: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
