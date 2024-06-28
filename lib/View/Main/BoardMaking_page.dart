import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BoardMakingPage extends StatefulWidget {
  @override
  _BoardMakingPageState createState() => _BoardMakingPageState();
}

class _BoardMakingPageState extends State<BoardMakingPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _participantsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addPostAndIncreasePoints() async {
    User? user = _auth.currentUser;
    if (user != null) {
      // 게시글 추가
      await _firestore.collection('board').add({
        'title': _titleController.text,
        'time': _selectedDate != null ? _selectedDate!.toIso8601String() : '',
        'participants': _participantsController.text,
        'location': _locationController.text,
        'content': _contentController.text,
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 포인트 증가 및 일정 추가
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userDoc = await transaction.get(userRef);
        if (userDoc.exists) {
          int newPoints = (userDoc['points'] ?? 0) + 500;
          transaction.update(userRef, {'points': newPoints});
          if (_selectedDate != null) {
            transaction.set(userRef.collection('schedule').doc(), {
              'date': _selectedDate!.toIso8601String(),
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '게시글 제목',
                hintText: '제목을 입력해 주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: _selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : '날짜를 선택해 주세요',
                border: OutlineInputBorder(),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _participantsController,
              decoration: InputDecoration(
                labelText: '인원',
                hintText: '참가 인원을 지정해 주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: '장소',
                hintText: '장소를 지정해 주세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '게시글 내용',
                hintText: '내용을 입력해 주세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _addPostAndIncreasePoints();
                Navigator.pop(context);
              },
              child: Text('게시글 작성하기'),
            ),
          ],
        ),
      ),
    );
  }
}
