import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'package:motu/src/design/color_theme.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> checkAttendance(BuildContext context) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(40.0),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '오늘의 출석 체크를\n하시겠습니까?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/stamp.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorTheme.colorDisabled,
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: ColorTheme.colorBlack,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    confirmed = true;
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: ColorTheme.colorPrimary,
                    minimumSize: const Size(100, 30),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: ColorTheme.colorWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        bool hasAttended = await loadAttendance();
        if (hasAttended) {
          // 이미 출석한 경우
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '오늘은 이미 출석 체크가 완료되었습니다.',
                style: TextStyle(color: ColorTheme.colorWhite),
              ),
              backgroundColor: ColorTheme.colorPrimary80,
            ),
          );
        } else {
          // 출석이 완료된 경우
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '출석 체크가 완료되었습니다!',
                style: TextStyle(color: ColorTheme.colorWhite),
              ),
              backgroundColor: ColorTheme.colorPrimary80,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '출석 체크 중 오류가 발생했습니다.',
              style: TextStyle(color: ColorTheme.colorWhite),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> loadAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = _firestore.collection('user').doc(user.uid);
      DocumentSnapshot doc = await userDoc.get();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> attendance = data['attendance'] ?? [];
      DateTime now = DateTime.now();

      // 오늘 출석 기록을 확인
      bool hasAttendedToday = attendance.any((date) {
        DateTime dateTime = (date as Timestamp).toDate();
        return dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;
      });

      // 이미 출석한 경우 true 반환
      if (hasAttendedToday) {
        return true;
      }

      // 출석 기록 추가
      attendance.add(Timestamp.fromDate(now));

      // 최신 7개의 출석 기록만 유지
      if (attendance.length > 7) {
        attendance = attendance.sublist(attendance.length - 7);
      }

      // 출석 기록을 날짜 순으로 정렬
      attendance.sort((a, b) =>
          (a as Timestamp).toDate().compareTo((b as Timestamp).toDate()));

      // 7일 연속 출석 여부 확인
      bool isConsecutive = true;
      for (int i = 0; i < attendance.length - 1; i++) {
        DateTime current = (attendance[i] as Timestamp).toDate();
        DateTime next = (attendance[i + 1] as Timestamp).toDate();

        // 두 날짜가 연속적인지 확인 (차이가 1일이어야 함)
        if (next.difference(current).inDays != 1) {
          isConsecutive = false;
          break;
        }
      }

      // 연속 7일 출석 시 보상 지급
      if (attendance.length == 7 && isConsecutive) {
        try {
          print("Updating user balance...");
          await AuthService().updateUserBalance(user.uid, 50000, "7일 연속 출석 보상");
          print("User balance updated successfully");
        } catch (e) {
          print('Error in updateUserBalance: $e');
        }
      }

      // 출석 기록 업데이트
      await userDoc.update({
        'attendance': attendance,
      });
      print("Attendance updated successfully");

      // 새로운 출석 기록이 추가되었음을 반환
      return false;
    }
    return false; // 유저가 없을 경우 출석 실패로 처리
  }

  Future<List<DateTime>> getAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('user').doc(user.uid).get();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> attendance = data['attendance'] ?? [];
      return attendance.map((date) => (date as Timestamp).toDate()).toList();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    User? user = _auth.currentUser;
    if (user != null) {
      QuerySnapshot snapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('bookmarks')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }
    return [];
  }
}
