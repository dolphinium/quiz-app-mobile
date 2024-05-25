import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<dynamic> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/quizzes'));
      final quizzes = json.decode(response.body);
      setState(() {
        _quizzes = quizzes;
      });
    } catch (error) {
      // Handle error
    }
  }

  void _navigateToQuiz(BuildContext context, dynamic quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizPage(quiz: quiz),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Panel'),
      ),
      body: ListView.builder(
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_quizzes[index]['title']),
            onTap: () => _navigateToQuiz(context, _quizzes[index]),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final dynamic quiz;

  QuizPage({required this.quiz});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Map<int, int> _answers = {};
  int _correctCount = 0;
  int _incorrectCount = 0;
  int _blankCount = 0;
  bool _submitted = false;

  void _submitQuiz() {
    int correct = 0;
    int incorrect = 0;
    int blank = 0;

    for (int i = 0; i < widget.quiz['questions'].length; i++) {
      if (_answers.containsKey(i)) {
        bool isCorrect = widget.quiz['questions'][i]['answers'][_answers[i]]['isCorrect'];
        if (isCorrect) {
          correct++;
        } else {
          incorrect++;
        }
      } else {
        blank++;
      }
    }

    setState(() {
      _correctCount = correct;
      _incorrectCount = incorrect;
      _blankCount = blank;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['title']),
      ),
      body: _submitted
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Correct Answers: $_correctCount'),
            Text('Incorrect Answers: $_incorrectCount'),
            Text('Blank Answers: $_blankCount'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Back to Quizzes'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: widget.quiz['questions'].length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.quiz['questions'][index]['text']),
                  ...List.generate(
                    widget.quiz['questions'][index]['answers'].length,
                        (answerIndex) => RadioListTile<int>(
                      title: Text(widget.quiz['questions'][index]['answers'][answerIndex]['text']),
                      value: answerIndex,
                      groupValue: _answers[index],
                      onChanged: (int? value) {
                        setState(() {
                          _answers[index] = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _submitted
          ? null
          : FloatingActionButton(
        onPressed: _submitQuiz,
        child: Icon(Icons.check),
      ),
    );
  }
}
