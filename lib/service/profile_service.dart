import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
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
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> attendance = data.containsKey('attendance')
          ? data['attendance'] as List<dynamic>
          : [];

      DateTime today = DateTime.now();
      bool alreadyChecked = attendance.any((date) {
        DateTime checkDate = (date as Timestamp).toDate();
        return checkDate.year == today.year &&
            checkDate.month == today.month &&
            checkDate.day == today.day;
      });

      if (!alreadyChecked) {
        attendance.add(Timestamp.fromDate(today));
        await userDoc.update({'attendance': attendance});

        if (attendance.length % 7 == 0) {
          int currentBalance = data['balance'] ?? 0;
          await userDoc.update({'balance': currentBalance + 100000});
        }
      }
    }
  }

  Future<List<DateTime>> getAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> attendance = data.containsKey('attendance')
          ? data['attendance'] as List<dynamic>
          : [];
      return attendance.map((date) => (date as Timestamp).toDate()).toList();
    }
    return [];
  }
}
