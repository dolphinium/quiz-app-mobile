import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TextEditingController _quizTitleController = TextEditingController();
  List<Question> _questions = [];

  Future<void> _createQuiz() async {
    final quiz = {
      'title': _quizTitleController.text,
      'questions': _questions.map((q) => q.toJson()).toList(),
    };

    try {
      await http.post(
        Uri.parse('http://localhost:8080/api/quizzes'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(quiz),
      );
      _showSuccessDialog('Quiz created successfully!');
    } catch (error) {
      // Handle error
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add(Question());
    });
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Panel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _quizTitleController,
              decoration: InputDecoration(labelText: 'Quiz Title'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return QuestionWidget(
                    question: _questions[index],
                    onRemove: () {
                      setState(() {
                        _questions.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addQuestion,
              child: Text('Add Question'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createQuiz,
              child: Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class Question {
  TextEditingController textController = TextEditingController();
  List<Answer> answers = [Answer()];

  Map<String, dynamic> toJson() {
    return {
      'text': textController.text,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class Answer {
  TextEditingController textController = TextEditingController();
  bool isCorrect = false;

  Map<String, dynamic> toJson() {
    return {
      'text': textController.text,
      'isCorrect': isCorrect,
    };
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final VoidCallback onRemove;

  QuestionWidget({required this.question, required this.onRemove});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  void _addAnswer() {
    setState(() {
      widget.question.answers.add(Answer());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: widget.question.textController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.question.answers.length,
              itemBuilder: (context, index) {
                return AnswerWidget(answer: widget.question.answers[index]);
              },
            ),
            ElevatedButton(
              onPressed: _addAnswer,
              child: Text('Add Answer'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onRemove,
              child: Text('Remove Question'),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerWidget extends StatefulWidget {
  final Answer answer;

  AnswerWidget({required this.answer});

  @override
  _AnswerWidgetState createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.answer.textController,
            decoration: InputDecoration(labelText: 'Answer'),
          ),
        ),
        Checkbox(
          value: widget.answer.isCorrect,
          onChanged: (bool? value) {
            setState(() {
              widget.answer.isCorrect = value ?? false;
            });
          },
        ),
      ],
    );
  }
}
