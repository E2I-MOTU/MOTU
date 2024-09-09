import 'package:cloud_firestore/cloud_firestore.dart';

class ScenarioResult {
  DateTime date;
  String subject;
  bool isIncome;
  int totalReturn; // 손익
  String returnRate; // 수익률

  ScenarioResult({
    required this.date,
    required this.subject,
    required this.isIncome,
    required this.totalReturn,
    required this.returnRate,
  });

  factory ScenarioResult.fromMap(Map<String, dynamic> map) {
    return ScenarioResult(
      date: (map['date'] as Timestamp).toDate(),
      subject: map['subject'],
      isIncome: map['isIncome'],
      totalReturn: map['totalReturn'],
      returnRate: map['returnRate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'subject': subject,
      'isIncome': isIncome,
      'totalReturn': totalReturn,
      'returnRate': returnRate,
    };
  }
}
