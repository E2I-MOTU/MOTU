import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(user.uid, doc.data() as Map<String, dynamic>);
      }
    }
    return null;
  }

  Future<void> updateName(String newName) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'name': newName,
      });
    }
  }

  Future<void> updateUserInfo(String uid, String name, String email) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = _firestore.collection('users').doc(uid);
      await userDoc.update({
        'name': name,
        'email': email,
      });
    }
  }

  Future<void> checkAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot doc = await userDoc.get();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      List<dynamic> attendance = data['attendance'] ?? [];
      DateTime now = DateTime.now();

      bool hasAttendedToday = attendance.any((date) {
        DateTime dateTime = (date as Timestamp).toDate();
        return dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;
      });

      if (!hasAttendedToday) {
        attendance.add(Timestamp.fromDate(now));
      }

      if (attendance.length > 7) {
        attendance = attendance.sublist(attendance.length - 7);
      }

      if (attendance.length == 7) {
        DateTime startDate = (attendance.first as Timestamp).toDate();
        if (now.difference(startDate).inDays == 6) {
          int balance = data['balance'] ?? 0;
          balance += 100000;
          await userDoc.update({
            'balance': balance,
          });
        }
      }

      await userDoc.update({
        'attendance': attendance,
      });
    }
  }

  Future<List<DateTime>> getAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

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
          .collection('users')
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
