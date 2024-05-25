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
      final response = await http.get(Uri.parse('http://localhost:8080/api/quizzes/getAll'));
      final quizzes = json.decode(response.body);
      setState(() {
        _quizzes = quizzes;
      });
    } catch (error) {
      // Handle error
    }
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
            title: Text(_quizzes[index]['question']),
            subtitle: Text(_quizzes[index]['answer']),
          );
        },
      ),
    );
  }
}
