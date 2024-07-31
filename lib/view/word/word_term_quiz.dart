import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class TermQuizScreen extends StatefulWidget {
  final String collectionName;

  TermQuizScreen({Key? key, required this.collectionName}) : super(key: key);

  @override
  _TermQuizScreenState createState() => _TermQuizScreenState();
}

class _TermQuizScreenState extends State<TermQuizScreen> {
  late Future<List<Map<String, dynamic>>> _quizData;
  late List<Map<String, dynamic>> _filteredQuizList;
  List<Map<String, dynamic>> _incorrectQuestions = [];
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  String? _userAnswer;
  bool _answered = false;
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quizData = _fetchQuizData();
  }

  Future<List<Map<String, dynamic>>> _fetchQuizData() async {
    final firestore = FirebaseFirestore.instance;
    final doc = await firestore.collection(widget.collectionName).doc('투자 기본 원칙').get();
    final data = doc.data()?['test'] ?? {};
    final quizList = (data as Map<String, dynamic>)
        .values
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    // 동일한 정답을 가진 문제 중에서 유형당 하나씩만 선택하기
    Map<String, Map<String, dynamic>> filteredMap = {};
    for (var question in quizList) {
      String answer = question['answer'];
      String type = question['type'];
      String key = '$answer-$type';

      if (!filteredMap.containsKey(key)) {
        filteredMap[key] = question;
      }
    }

    // 필터링된 문제들 리스트
    _filteredQuizList = filteredMap.values.toList();

    // 문제 리스트를 랜덤으로 섞기
    _filteredQuizList.shuffle(Random());

    // 15문제만 추출
    _filteredQuizList = _filteredQuizList.take(15).toList();
    return _filteredQuizList;
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _filteredQuizList.length - 1) {
        _checkAnswer(_filteredQuizList[_currentQuestionIndex]['answer']);
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _userAnswer = null;
        _answered = false;
        _answerController.clear();
      } else {
        // 모든 문제를 풀면 결과 화면으로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(incorrectQuestions: _incorrectQuestions),
          ),
        );
      }
    });
  }

  void _checkAnswer(String correctAnswer) {
    if ((_selectedAnswer != null && _selectedAnswer != correctAnswer) ||
        (_userAnswer != null && _userAnswer!.trim() != correctAnswer)) {
      _incorrectQuestions.add(_filteredQuizList[_currentQuestionIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '퀴즈 앱',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _quizData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('퀴즈 데이터가 없습니다.'));
          }

          final quizList = snapshot.data!;
          if (_currentQuestionIndex >= quizList.length) {
            return const Center(child: Text('모든 문제를 푸셨습니다.'));
          }

          final question = quizList[_currentQuestionIndex];

          return Column(
            children: [
              SizedBox(
                height: 12,
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / quizList.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${_currentQuestionIndex + 1} / ${quizList.length}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        question['situation'] ?? '상황 설명이 없습니다.',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        question['question'] ?? '질문이 없습니다.',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (question['type'] == '단답형') ...[
                        TextField(
                          controller: _answerController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '정답 입력',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _userAnswer = value;
                              _answered = true;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                      ] else if (question['type'] == '객관식') ...[
                        ...(question['options'] as List<dynamic>).map<Widget>((option) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedAnswer = option as String;
                                    _answered = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _selectedAnswer == option
                                      ? Colors.deepPurpleAccent
                                      : Colors.white,
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
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: !_answered ? null : _nextQuestion,
                        child: const Text('다음 문제'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> incorrectQuestions;

  ResultScreen({Key? key, required this.incorrectQuestions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('결과'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '틀린 문제들:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: incorrectQuestions.length,
                itemBuilder: (context, index) {
                  final question = incorrectQuestions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('상황: ${question['situation']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(question['question'] ?? '질문이 없습니다.'),
                          const SizedBox(height: 10),
                          Text('정답: ${question['answer']}'),
                          if (question['type'] == '객관식') ...[
                            const SizedBox(height: 10),
                            Text('보기: ${(question['options'] as List<dynamic>).join(', ')}'),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
