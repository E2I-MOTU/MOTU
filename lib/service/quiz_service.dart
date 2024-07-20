import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class QuizService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _correct = false;
  String _selectedAnswer = '';
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get answered => _answered;
  bool get correct => _correct;
  String get selectedAnswer => _selectedAnswer;
  List<Map<String, dynamic>> get questions => _questions;
  bool get isLoading => _isLoading;

  Future<void> loadQuestions(String collectionName) async {
    try {
      final snapshot = await _firestore
          .collection('quiz')
          .doc(collectionName)
          .get();

      List<Map<String, dynamic>> questionsList = [];

      var data = snapshot.data();
      if (data == null) {
        print('No data found for the given collection name.');
      } else {
        data.forEach((key, value) {
          if (key != 'catchphrase') {
            questionsList.add(value as Map<String, dynamic>);
          }
        });

        questionsList.forEach((question) {
          List<dynamic> options = question['options'];
          options.shuffle(Random());
        });
      }

      _questions = questionsList;
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
    }
    notifyListeners();
  }

  void nextQuestion() {
    _currentQuestionIndex++;
    _answered = false;
    _correct = false;
    _selectedAnswer = '';
    notifyListeners();
  }

  void selectAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }
}
