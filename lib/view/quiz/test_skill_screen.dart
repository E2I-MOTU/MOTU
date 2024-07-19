import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestSkillScreen extends StatefulWidget {
  final String collectionName;

  const TestSkillScreen({super.key, required this.collectionName});

  @override
  _TestSkillScreenState createState() => _TestSkillScreenState();
}

class _TestSkillScreenState extends State<TestSkillScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadRandomQuestions();
  }

  Future<void> _loadRandomQuestions() async {
    final snapshot = await _firestore.collection('quiz').doc(widget.collectionName).get();
    if (snapshot.exists) {
      final data = snapshot.data()!;
      List<Map<String, dynamic>> questionsList = [];
      data.forEach((key, value) {
        if (key.startsWith('index')) {
          questionsList.add(value as Map<String, dynamic>);
        }
      });
      questionsList.shuffle();
      setState(() {
        _questions = questionsList.take(10).toList();
      });
    }
  }

  void _submitAnswer() {
    if (_selectedAnswer != null) {
      final correctAnswer = _questions[_currentQuestionIndex]['answer'];
      if (_selectedAnswer == correctAnswer) {
        _score++;
      }
      _nextQuestion();
    }
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '실력 테스트',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _currentQuestionIndex >= _questions.length
          ? Center(child: Text('테스트 완료! 점수: $_score/${_questions.length}'))
          : Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  minHeight: 10,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${_currentQuestionIndex + 1} / ${_questions.length}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...(_questions[_currentQuestionIndex]['options'] as List<dynamic>)
                      .map<Widget>((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedAnswer = option as String;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedAnswer == option
                              ? Colors.deepPurpleAccent
                              : Colors.white,
                        ),
                        child: Text(option as String),
                      ),
                    );
                  }).toList(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: _submitAnswer,
                      child: const Text('제출'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
