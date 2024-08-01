import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String email;
  final String name;
  final int balance;
  final List<DateTime> attendance;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.balance,
    required this.attendance,
  });

  factory UserModel.fromMap(String? uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      balance: data['balance'] ?? 0,
      attendance: data['attendance'] != null
          ? (data['attendance'] as List<dynamic>)
          .map((date) => (date as Timestamp).toDate())
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'balance': balance,
      'attendance': attendance.map((date) => Timestamp.fromDate(date)).toList(),
    };
  }
}
