import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class TicketingPage extends StatefulWidget {
  @override
  _TicketingPageState createState() => _TicketingPageState();
}

class _TicketingPageState extends State<TicketingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _points = 0;
  int _entries = 0;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_userId).get();
      if (userDoc.exists) {
        setState(() {
          _points = userDoc.get('points') ?? 0;
          _entries = userDoc.get('entries') ?? 0;
        });
      } else {
        // 응모 횟수 기본값 설정
        await _firestore.collection('users').doc(_userId).set({'entries': 0}, SetOptions(merge: true));
      }
    }
  }

  Future<void> _tryTicketing() async {
    if (_points < 500) {
      _showResultDialog('포인트가 부족합니다.');
      return;
    }

    setState(() {
      _points -= 500;
      _entries += 1;
    });

    DocumentReference userRef = _firestore.collection('users').doc(_userId);
    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot userDoc = await transaction.get(userRef);
      if (userDoc.exists) {
        int newPoints = (userDoc['points'] ?? 0) - 500;
        int newEntries = (userDoc['entries'] ?? 0) + 1;
        transaction.update(userRef, {'points': newPoints, 'entries': newEntries});
      }
    });

    bool isWinner = Random().nextInt(100) == 0;
    _showResultDialog(isWinner ? '!!!!!!!당첨되었습니다!!!!!!' : '다음 기회에 ㅋ');
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 450,
                    width: double.infinity,
                    child: Image.asset(
                      'lib/assets/images/paris_1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
                '내 응모 횟수: $_entries',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
            ),
            Text(
                '내 포인트: $_points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white, // 텍스트 색상 설정
                  side: BorderSide(color: Colors.black, width: 3), // 테두리 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // 둥근 모서리 설정
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 패딩 설정
                ),
              onPressed: _tryTicketing,
              child: Text(
                  '티켓 응모하기',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TicketingPage(),
  ));
}
