import 'package:cloud_firestore/cloud_firestore.dart';

class ScenarioResult {
  DateTime date;
  String subject;
  int totalReturn; // 손익
  double returnRate; // 수익률

  ScenarioResult({
    required this.date,
    required this.subject,
    required this.totalReturn,
    required this.returnRate,
  });

  factory ScenarioResult.fromMap(Map<String, dynamic> map) {
    return ScenarioResult(
      date: (map['date'] as Timestamp).toDate(),
      subject: map['subject'],
      totalReturn: map['totalReturn'],
      returnRate: map['returnRate'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': Timestamp.fromDate(date),
      'subject': subject,
      'totalReturn': totalReturn,
      'returnRate': returnRate,
    };
  }
}
