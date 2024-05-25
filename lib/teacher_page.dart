import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TeacherPage extends StatefulWidget {
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  TextEditingController _quizTitleController = TextEditingController();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();

  Future<void> _createQuiz() async {
    final quiz = {
      'title': _quizTitleController.text,
      'question': _questionController.text,
      'answer': _answerController.text,
    };

    try {
      await http.post(
        Uri.parse('http://localhost:8080/api/quizzes/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(quiz),
      );
      // Handle success
    } catch (error) {
      // Handle error
    }
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
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Enter Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Enter Answer'),
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
