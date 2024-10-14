import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/features/profile/model/balance_detail.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/design/color_theme.dart';
import 'package:provider/provider.dart';

import '../../../common/util/util.dart';

class BalanceDetailPage extends StatefulWidget {
  const BalanceDetailPage({super.key});

  @override
  State<BalanceDetailPage> createState() => _BalanceDetailPageState();
}

class _BalanceDetailPageState extends State<BalanceDetailPage> {
  String selectedValue = '최신순';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('잔고 내역'),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: Consumer<AuthService>(
        builder: (context, service, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(
                      24.0, 16, 24.0, 16), // 내부 padding

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
                                  color: ColorTheme.Black3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            Formatter.format(service.user!.balance),
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
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isDense: true,
                        alignment: Alignment.centerRight,
                        hint: const Text(
                          "최신순",
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorTheme.Black4,
                          ),
                        ),
                        value: selectedValue,
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: '최신순',
                            child: Text(
                              '최신순',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorTheme.Black1,
                              ),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: '오래된순',
                            child: Text(
                              '오래된순',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorTheme.Black1,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (String? value) {
                          log("✅ Filter button clicked: $value");
                          setState(() {
                            selectedValue = value!;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          width: 75,
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 0), // 여백 제거
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          offset: const Offset(-5, -5),
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Icon(CupertinoIcons.chevron_down),
                          ),
                          iconSize: 15,
                          iconEnabledColor: ColorTheme.Black4,
                        ),
                        selectedItemBuilder: (context) {
                          return [
                            const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: Text(
                                "최신순",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorTheme.Black4,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                "오래된순",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ColorTheme.Black4,
                                ),
                              ),
                            ),
                          ];
                        },
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
                    itemCount: service.user!.balanceHistory.length,
                    itemBuilder: (context, index) {
                      List<BalanceDetail> sortedBalanceHistory;
                      if (selectedValue == '최신순') {
                        sortedBalanceHistory =
                            List.from(service.user!.balanceHistory)
                              ..sort((a, b) => b.date.compareTo(a.date));
                      } else {
                        sortedBalanceHistory =
                            List.from(service.user!.balanceHistory)
                              ..sort((a, b) => a.date.compareTo(b.date));
                      }
                      final detail = sortedBalanceHistory[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
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
                              '${detail.amount == 0 ? '' : detail.isIncome ? '+' : '-'} ${Formatter.format(detail.amount)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: detail.amount == 0
                                    ? Colors.black
                                    : detail.isIncome
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ),
                            dense: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
