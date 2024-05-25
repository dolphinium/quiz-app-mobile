import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();

  Future<void> _handleLogin() async {
    final username = _usernameController.text;
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/users/$username'));
      final user = json.decode(response.body);
      if (user['role'] == 'teacher') {
        Navigator.pushNamed(context, '/teacher');
      } else if (user['role'] == 'student') {
        Navigator.pushNamed(context, '/student');
      } else {
        // Handle other roles if needed
      }
    } catch (error) {
      // Handle error (e.g., user not found)
    }
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
