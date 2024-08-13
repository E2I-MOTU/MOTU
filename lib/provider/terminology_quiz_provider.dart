import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../service/user_service.dart';

class TerminologyQuizService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _correct = false;
  String _selectedAnswer = '';
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> _incorrectAnswers = [];
  String _uid = '';
  String _documentName = '';
  final TextEditingController _answerController = TextEditingController();

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get answered => _answered;
  bool get correct => _correct;
  String get selectedAnswer => _selectedAnswer;
  List<Map<String, dynamic>> get questions => _questions;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get incorrectAnswers => _incorrectAnswers;
  TextEditingController get answerController => _answerController;

  Future<void> loadQuestions(String collectionName, String documentName, String uid) async {
    _uid = uid;
    _documentName = documentName;
    try {
      final doc = await _firestore.collection(collectionName).doc(documentName).get();
      final data = doc.data()?['test'] ?? {};

      List<Map<String, dynamic>> questionsList = (data as Map).values.map((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();

      questionsList.forEach((question) {
        List<dynamic> options = question['options'];
        options.shuffle(Random());
      });

      questionsList.shuffle(Random());

      _questions = questionsList.take(15).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading questions: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void submitAnswer(String correctAnswer) {
    _answered = true;
    _correct = _selectedAnswer == correctAnswer;
    if (_correct) {
      _score++;
    } else {
      _incorrectAnswers.add({
        'question': _questions[_currentQuestionIndex]['question'],
        'selectedAnswer': _selectedAnswer,
        'correctAnswer': correctAnswer,
        'options': _questions[_currentQuestionIndex]['options'],
        'type': _questions[_currentQuestionIndex]['type'],
        'situation': _questions[_currentQuestionIndex]['situation'],
      });
    }
    notifyListeners();
  }

  Future<void> nextQuestion() async {
    _currentQuestionIndex++;
    _answered = false;
    _correct = false;
    _selectedAnswer = '';
    _answerController.clear(); // Clear the controller

    if (_currentQuestionIndex >= _questions.length) {
      await saveQuizCompletion();
    }

    notifyListeners();
  }

  Future<void> saveQuizCompletion() async {
    try {
      final userQuizRef = _firestore.collection('users').doc(_uid).collection('terminology_quiz').doc(_documentName);
      final snapshot = await userQuizRef.get();

      bool wasPreviouslyCompleted = false;
      int previousScore = 0;
      if (snapshot.exists) {
        final quizData = snapshot.data()!;
        wasPreviouslyCompleted = quizData['completed'] ?? false;
        previousScore = quizData['score'] ?? 0;
      }

      final newCompleted = wasPreviouslyCompleted || (_score / _questions.length >= 0.9);
      final finalScore = wasPreviouslyCompleted ? max(_score, previousScore) : _score;

      await userQuizRef.set({
        'score': finalScore,
        'completedAt': Timestamp.now(),
        'completed': newCompleted,
      });

      if (newCompleted && !wasPreviouslyCompleted) {
        await _userService.updateUserBalance(_uid, 100000); // Add 100,000 reward if completed
      }
    } catch (e) {
      print('Error saving quiz completion: $e');
    }
  }

  void selectAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }
}
