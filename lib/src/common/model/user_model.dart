import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/features/profile/model/balance_detail.dart';
import 'package:motu/src/features/scenario/model/scenario_result.dart';

class UserModel {
  final String uid; // 유저 ID
  final String email; // 이메일
  final String name; // 이름
  final String photoUrl; // 프로필 사진
  int balance; // 보유 자산
  List<BalanceDetail> balanceHistory; // 자산 변동 내역
  List<DateTime> attendance; // 출석 기록
  // final List<Completed> completedTerminalogy; // 완료한 용어공부
  // final List<Completed> completedQuiz; // 완료한 퀴즈
  // final List<BookmarkData> bookmarks; // 저장한 용어공부
  final List<ScenarioResult> scenarioRecord; // 시나리오 기록

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.balance,
    required this.balanceHistory,
    required this.attendance,
    // required this.completedTerminalogy,
    // required this.completedQuiz,
    // required this.bookmarks,
    required this.scenarioRecord,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      balance: map['balance'],
      balanceHistory: (map['balanceHistory'] as List)
          .map((data) => BalanceDetail.fromMap(data))
          .toList(),
      attendance: (map['attendance'] as List)
          .map((date) => (date as Timestamp).toDate())
          .toList(),
      // completedTerminalogy: (map['completedTerminalogy'] as List)
      //     .map((data) => Completed.fromMap(data))
      //     .toList(),
      // completedQuiz: (map['completedQuiz'] as List)
      //     .map((data) => Completed.fromMap(data))
      //     .toList(),
      // bookmarks: (map['bookmarks'] as List)
      //     .map((data) => BookmarkData.fromMap(data))
      //     .toList(),
      scenarioRecord: (map['scenarioRecord'] as List)
          .map((data) => ScenarioResult.fromMap(data))
          .toList(),
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
      // 'completedTerminalogy': completedTerminalogy,
      // 'completedQuiz': completedQuiz,
      // 'bookmarks': bookmarks,
      'scenarioRecord': scenarioRecord.map((data) => data.toMap()).toList(),
    };
  }
}
