import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_data.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
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

  Future<void> checkAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot doc = await userDoc.get();
      List<dynamic> attendance = doc['attendance'] ?? [];
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      bool alreadyCheckedIn = attendance.any((timestamp) {
        DateTime date = (timestamp as Timestamp).toDate();
        return date.year == today.year && date.month == today.month && date.day == today.day;
      });

      if (!alreadyCheckedIn) {
        attendance = attendance.where((timestamp) {
          DateTime date = (timestamp as Timestamp).toDate();
          return now.difference(date).inDays < 7;
        }).toList();

        attendance.add(Timestamp.now());

        if (attendance.length >= 7) {
          DateTime startDate = (attendance[attendance.length - 7] as Timestamp).toDate();
          if (now.difference(startDate).inDays <= 6) {
            int balance = doc['balance'] ?? 0;
            balance += 100000;
            await userDoc.update({
              'balance': balance,
            });
          }
        }

        await userDoc.update({
          'attendance': attendance,
        });
      } else {
        throw Exception("Already checked in today");
      }
    }
  }

  Future<List<DateTime>> getAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      List<dynamic> attendance = doc['attendance'] ?? [];
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

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }
    return [];
  }
}
