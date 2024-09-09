import 'package:cloud_firestore/cloud_firestore.dart';

class BalanceDetail {
  DateTime date;
  String content;
  int amount;
  bool isIncome;

  BalanceDetail({
    required this.date,
    required this.content,
    required this.amount,
    required this.isIncome,
  });

  factory BalanceDetail.fromMap(Map<String, dynamic> map) {
    return BalanceDetail(
      date: (map['date'] as Timestamp).toDate(),
      content: map['content'],
      amount: map['amount'],
      isIncome: map['isIncome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'content': content,
      'amount': amount,
      'isIncome': isIncome,
    };
  }
}
