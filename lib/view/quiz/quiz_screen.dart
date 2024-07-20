import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  final String collectionName;

  const QuizScreen({super.key, required this.collectionName});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _correct = false;
  String _selectedAnswer = '';
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final snapshot = await _firestore
          .collection('quiz')
          .doc(widget.collectionName)
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

      setState(() {
        _questions = questionsList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitAnswer(String correctAnswer) {
    setState(() {
      _answered = true;
      _correct = _selectedAnswer == correctAnswer;
      if (_correct) {
        _score++;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_correct ? '정답입니다!' : '오답입니다.'),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(_correct ? '잘했어요!' : '정답은 $correctAnswer 입니다.'),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('다음 질문'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _nextQuestion();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _answered = false;
      _correct = false;
      _selectedAnswer = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '퀴즈 앱',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '퀴즈 앱',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Text('퀴즈 완료! 점수: $_score/${_questions.length}'),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '퀴즈 앱',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    question['question'] ?? '질문이 없습니다.',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                ...(question['options'] as List<dynamic>).map<Widget>((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _answered
                            ? null
                            : () {
                          setState(() {
                            _selectedAnswer = option as String;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedAnswer == option
                              ? Colors.deepPurpleAccent
                              : null,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(option as String),
                      ),
                    ),
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _selectedAnswer.isEmpty
                            ? null
                            : () => _submitAnswer(question['answer'] ?? ''),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text('제출'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Text(
              '${_currentQuestionIndex + 1} / ${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
