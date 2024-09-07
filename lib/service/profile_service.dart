import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motu/service/user_service.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<void> checkAttendance() async {
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

      // 사용자가 버튼을 눌렀을 때만 출석 기록을 추가
      if (!hasAttendedToday) {
        attendance.add(Timestamp.fromDate(now));
      }

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

      // 연속 7일 출석이 확인되면 보상 지급
      if (attendance.length == 7 && isConsecutive) {
        try {
          print("Updating user balance...");
          await _userService.updateUserBalance(user.uid, 50000, "7일 연속 출석 보상");
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
    }
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
