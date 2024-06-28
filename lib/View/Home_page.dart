import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  HomeScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈 페이지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '로그인 성공!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              '닉네임: ${user['nickname']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '이름: ${user['name']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '나이: ${user['age']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '이메일: ${user['email']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
