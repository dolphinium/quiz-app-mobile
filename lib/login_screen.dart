import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();

  String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080';
    } else {
      return 'http://localhost:8080';
    }
  }

  Future<void> _handleLogin() async {
    final username = _usernameController.text;

    // Validate the username
    if (username != 'test_student' && username != 'test_teacher') {
      _showErrorDialog('Invalid username');
      return;
    }

    try {
      final response = await http.get(Uri.parse('${getBaseUrl()}/api/users/$username'));
      final user = json.decode(response.body);
      if (user['role'] == 'teacher') {
        _showSuccessDialog('Logged in successfully as a Teacher', '/teacher');
      } else if (user['role'] == 'student') {
        _showSuccessDialog('Logged in successfully as a Student', '/student');
      } else {
        // Handle other roles if needed
      }
    } catch (error) {
      _showErrorDialog('Login failed. Please try again.');
    }
  }

  void _showSuccessDialog(String message, String route) {
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
                Navigator.pushNamed(context, route);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Enter Username'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleLogin,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
