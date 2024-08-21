import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/model/balance_detail.dart';
import 'package:motu/model/scenario_result.dart';

class UserModel {
  final String uid; // 유저 ID
  final String email; // 이메일
  final String name; // 이름
  final String photoUrl; // 프로필 사진
  final int balance; // 보유 자산
  final List<BalanceDetail> balanceHistory; // 자산 변동 내역
  final List<DateTime> attendance; // 출석 기록
  final List<String> completedTerminalogy; // 완료한 용어공부
  final List<String> completedQuiz; // 완료한 퀴즈
  final List<ScenarioResult> scenarioRecord; // 시나리오 기록

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.balance,
    required this.balanceHistory,
    required this.attendance,
    required this.completedTerminalogy,
    required this.completedQuiz,
    required this.scenarioRecord,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    List<BalanceDetail> balanceHistory =
        (map['balanceHistory'] as List<dynamic>)
            .map((data) => BalanceDetail.fromMap(data as Map<String, dynamic>))
            .toList();

    List<DateTime> attendance = (map['attendance'] as List<dynamic>)
        .map((date) => (date as Timestamp).toDate())
        .toList();

    List<String> completedTerminalogy =
        (map['completedTerminalogy'] as List<dynamic>)
            .map((term) => term as String)
            .toList();

    List<String> completedQuiz = (map['completedQuiz'] as List<dynamic>)
        .map((quiz) => quiz as String)
        .toList();

    List<ScenarioResult> scenarioRecord =
        (map['scenarioRecord'] as List<dynamic>)
            .map((data) => ScenarioResult.fromMap(data as Map<String, dynamic>))
            .toList();

    return UserModel(
      uid: uid,
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      balance: map['balance'],
      balanceHistory: balanceHistory,
      attendance: attendance,
      completedTerminalogy: completedTerminalogy,
      completedQuiz: completedQuiz,
      scenarioRecord: scenarioRecord,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'balance': balance,
      'balanceHistory': balanceHistory.map((data) => data.toMap()).toList(),
      'attendance': attendance.map((date) => Timestamp.fromDate(date)).toList(),
      'completedTerminalogy': completedTerminalogy,
      'completedQuiz': completedQuiz,
      'scenarioRecord': scenarioRecord.map((data) => data.toMap()).toList(),
    };
  }
}
