import 'package:flutter/material.dart';
import 'package:quiz_app/login_screen.dart';
import 'package:quiz_app/teacher_page.dart';
import 'package:quiz_app/student_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/teacher': (context) => TeacherPage(),
        '/student': (context) => StudentPage(),
      },
    );
  }
}
