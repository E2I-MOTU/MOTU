import 'dart:developer' as dev;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motu/main.dart';
import 'package:motu/model/scenario_result.dart';
import 'package:motu/model/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../model/balance_detail.dart';

class AuthService with ChangeNotifier {
  Function? showAddInfoDialog;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _user;
  UserModel? get user => _user;

  Future<void> initialize() async {
    dev.log("🏁 Initializing MOTU...");
    if (auth.currentUser != null) {
      dev.log("🔑 User is already signed in: ${auth.currentUser!.uid}");
      await getUserInfo();
    } else {
      dev.log("🔑 No user is signed in.");
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      notifyListeners();
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        dev.log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        dev.log('Wrong password provided for that user.');
      }
      notifyListeners();
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (_auth.currentUser != null) {
        dev.log('Email Register Success: ${_auth.currentUser!}');

        bool isUserInfoExists = await checkUserInfoExists();
        if (isUserInfoExists) {
          dev.log("유저 정보가 이미 존재합니다.");
          await getUserInfo();
        } else {
          dev.log("유저 정보가 없으므로 추가합니다.");
          await addEmailUserInfo(name);
        }

        notifyListeners();
        return _auth.currentUser;
      } else {
        dev.log('Email Register Fail: No User Found');

        notifyListeners();
        return null;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dev.log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        dev.log('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      dev.log(e.toString());
      return null;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (_auth.currentUser != null) {
      dev.log('Email dev.login Success: ${_auth.currentUser!.displayName}');

      bool isUserInfoExists = await checkUserInfoExists();
      if (isUserInfoExists) {
        dev.log("유저 정보가 이미 존재합니다.");
        await getUserInfo();
      } else {
        await addEmailUserInfo(_auth.currentUser!.displayName ?? "");
        dev.log("유저 정보가 없으므로 추가합니다.");
      }

      notifyListeners();
      return _auth.currentUser;
    } else {
      dev.log('Email dev.login Fail: No User Found');

      notifyListeners();
      return null;
    }
  }

  dynamic verifyCheck(BuildContext context) {
    if (_auth.currentUser != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const App()), // MyApp 를 메인 페이지로 교체해 주세요.
        (route) => false, // 모든 이전 루트를 제거하여 새로운 페이지로 이동합니다
      );
    }
  }

  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await _auth.signInWithCredential(credential);

    if (_auth.currentUser != null) {
      dev.log('Google dev.login Success: ${_auth.currentUser!.displayName}');

      bool isUserInfoExists = await checkUserInfoExists();
      if (isUserInfoExists) {
        dev.log("유저 정보가 이미 존재합니다.");
        await getUserInfo();
      } else {
        await addUserInfo();
        dev.log("유저 정보가 없으므로 추가합니다.");
      }

      notifyListeners();
      return _auth.currentUser;
    } else {
      dev.log('Google dev.login Fail: No User Found');

      notifyListeners();
      return null;
    }
  }

  Future<User?> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final OAuthCredential credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    await _auth.signInWithCredential(credential);

    if (_auth.currentUser != null) {
      dev.log('Apple dev.login Success: ${_auth.currentUser!}');

      bool isUserInfoExists = await checkUserInfoExists();
      if (isUserInfoExists) {
        dev.log("유저 정보가 이미 존재합니다.");
        await getUserInfo();
      } else {
        dev.log("유저 정보가 없음");
        await addAppleUserInfo();
      }

      notifyListeners();
      return _auth.currentUser;
    } else {
      dev.log('Apple dev.login Fail: No User Found');

      notifyListeners();
      return null;
    }
  }

  Future<bool> checkUserInfoExists() async {
    // 현재 유저의 UID 가져오기
    if (_auth.currentUser != null) {
      // Firestore 인스턴스 가져오기
      CollectionReference userCollection = _firestore.collection('user');

      // Document 존재 여부 확인
      DocumentSnapshot doc =
          await userCollection.doc(_auth.currentUser!.uid).get();

      return doc.exists; // document가 존재하면 true, 아니면 false 반환
    }

    return false; // 유저가 로그인하지 않은 경우
  }

  Future<void> addUserInfo() async {
    if (_auth.currentUser != null) {
      UserModel currentUser = UserModel(
        uid: _auth.currentUser!.uid,
        email: _auth.currentUser!.email!,
        name: _auth.currentUser!.displayName ?? "",
        photoUrl: _auth.currentUser!.photoURL ?? "",
        balance: 1000000,
        balanceHistory: [
          BalanceDetail(
            date: DateTime.now(),
            content: "초기 자금",
            amount: 1000000,
            isIncome: true,
          ),
        ],
        attendance: [],
        // completedTerminadev.logy: [],
        // completedQuiz: [],
        // bookmarks: [],
        scenarioRecord: [],
      );

      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .set(currentUser.toMap());
    }
  }

  Future<void> addEmailUserInfo(String name) async {
    if (_auth.currentUser != null) {
      UserModel currentUser = UserModel(
        uid: _auth.currentUser!.uid,
        email: _auth.currentUser!.email!,
        name: name,
        photoUrl: _auth.currentUser!.photoURL ?? "",
        balance: 1000000,
        balanceHistory: [
          BalanceDetail(
            date: DateTime.now(),
            content: "초기 자금",
            amount: 1000000,
            isIncome: true,
          ),
        ],
        attendance: [],
        // completedTerminadev.logy: [],
        // completedQuiz: [],
        // bookmarks: [],
        scenarioRecord: [],
      );

      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .set(currentUser.toMap());
    }
  }

  Future<void> addAppleUserInfo() async {
    if (_auth.currentUser != null) {
      UserModel currentUser = UserModel(
        uid: _auth.currentUser!.uid,
        email: _auth.currentUser!.email!,
        name: _auth.currentUser!.email!.split('@').first,
        photoUrl: "",
        balance: 1000000,
        balanceHistory: [
          BalanceDetail(
            date: DateTime.now(),
            content: "초기 자금",
            amount: 1000000,
            isIncome: true,
          ),
        ],
        attendance: [],
        // completedTerminadev.logy: [],
        // completedQuiz: [],
        // bookmarks: [],
        scenarioRecord: [],
      );

      await _firestore
          .collection('user')
          .doc(_auth.currentUser!.uid)
          .set(currentUser.toMap());
    }

    notifyListeners();
  }

  Future<void> getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('user').doc(user.uid).get();
      if (doc.exists) {
        dev.log("🔍 User Info found");
        notifyListeners();
        _user = UserModel.fromMap(user.uid, doc.data() as Map<String, dynamic>);
      }
    } else {
      dev.log("🔍 User Info not found");
    }
  }

  Future<void> updateUserInfo(String name) async {
    if (_auth.currentUser != null) {
      await _firestore.collection('user').doc(_auth.currentUser!.uid).update({
        'name': name,
      });
      await getUserInfo();
      dev.log("🔄 User Info Updated: ${_user?.name}");
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    GoogleSignIn().signOut();

    notifyListeners();
  }

  Future<List<DateTime>> getAttendance() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('user').doc(user.uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> attendanceList = data['attendance'] ?? [];
        List<DateTime> attendanceDates = attendanceList
            .map((timestamp) => (timestamp as Timestamp).toDate())
            .toList();
        return attendanceDates;
      }
    }
    return [];
  }

  void setUserBalance(int amount) {
    _user?.balance = amount;

    _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'balance': amount,
    });

    notifyListeners();
  }

  Future<void> updateUserBalance(
      String uid, int additionalBalance, String content) async {
    try {
      final userRef = _firestore.collection('user').doc(uid);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final userData = snapshot.data()!;
        final currentBalance = userData['balance'] ?? 0;
        final newBalance = currentBalance + additionalBalance;

        // 잔고 업데이트
        transaction.update(userRef, {'balance': newBalance});

        // BalanceDetail 객체 생성
        BalanceDetail newBalanceDetail = BalanceDetail(
          date: DateTime.now(),
          content: content,
          amount: additionalBalance,
          isIncome: true,
        );

        // 기존 balanceHistory를 가져오고, 새로운 내역을 추가
        final List<dynamic> balanceHistory = userData['balanceHistory'] ?? [];
        balanceHistory.add(newBalanceDetail.toMap());

        // 잔고 내역 업데이트
        transaction.update(userRef, {'balanceHistory': balanceHistory});
      });
    } catch (e) {
      print('Error updating user balance: $e');
    }
  }

  void addBalanceDetail(BalanceDetail detail) {
    _user?.balanceHistory.add(detail);

    _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'balanceHistory': FieldValue.arrayUnion([detail.toMap()]),
    });

    notifyListeners();
  }

  void addScenarioRecord(ScenarioResult result) {
    _user?.scenarioRecord.add(result);

    _firestore.collection('user').doc(_auth.currentUser!.uid).update({
      'scenarioRecord': FieldValue.arrayUnion([result.toMap()]),
    });

    notifyListeners();
  }

  // 경제/금융 퀴즈
  Future<void> saveQuizCompletion(
      String uid, String quizId, int score, int questionLength) async {
    try {
      final userQuizRef = _firestore
          .collection('user')
          .doc(uid)
          .collection('completedQuiz')
          .doc(quizId);
      final snapshot = await userQuizRef.get();

      bool wasPreviouslyCompleted = false;
      int previousScore = 0;
      if (snapshot.exists) {
        final quizData = snapshot.data()!;
        wasPreviouslyCompleted = quizData['completed'] ?? false;
        previousScore = quizData['score'] ?? 0;
      }

      final newCompleted =
          wasPreviouslyCompleted || (score / questionLength >= 0.9);
      final finalScore =
          wasPreviouslyCompleted ? max(score, previousScore) : score;

      await userQuizRef.set({
        'score': finalScore,
        'completedAt': Timestamp.now(),
        'completed': newCompleted,
      });
    } catch (e) {
      print('Error saving quiz completion: $e');
    }
  }
}
