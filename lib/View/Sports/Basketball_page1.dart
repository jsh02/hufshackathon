import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Main/BoardMaking_page.dart';

class BasketballPage1 extends StatefulWidget {
  @override
  _BasketballPage1State createState() => _BasketballPage1State();
}

class _BasketballPage1State extends State<BasketballPage1> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _points = 0;
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
          _points = userDoc.get('points');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/basketball.png'), // 예제 이미지 경로
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(8), // 각진 네모
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('농구', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Spacer(),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black, // 테두리 색상
                                  width: 2.0, // 테두리 두께
                                ),
                                borderRadius: BorderRadius.circular(8), // 모서리 각도 (원하는 경우)
                              ),
                              padding: EdgeInsets.all(8), // 내부 여백
                              child: Text('내 포인트: $_points'),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BoardMakingPage(),
                                  ),
                                );
                                _loadUserData(); // 포인트 갱신을 위해 다시 로드
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.black, width: 2.0), // 테두리 설정
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8), // 각지게 설정
                                ),
                              ),
                              child: Text(
                                '게시글 작성',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('board').orderBy('createdAt', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final posts = snapshot.data!.docs;
                    List<Widget> postWidgets = posts.map((doc) {
                      DateTime postDate = DateTime.parse(doc['time']);
                      String formattedDate = "${postDate.year}-${postDate.month}-${postDate.day}";
                      return GestureDetector(
                        onTap: () {
                          _showPostDialog(context, doc['title'], doc['participants'], formattedDate, doc['location'], doc['content']);
                        },
                        child: buildBasketballListItem(
                          context,
                          doc['title'],
                          '날짜: $formattedDate\n'
                              '인원: ${doc['participants']}\n'
                              '장소: ${doc['location']}\n',
                        ),
                      );
                    }).toList();
                    return ListView(
                      children: postWidgets,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPostDialog(BuildContext context, String title, String participants, String date, String location, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Text('인원: $participants')),
                    Expanded(child: Text('날짜: $date')),
                  ],
                ),
                SizedBox(height: 8),
                Text('장소: $location'),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 300,
                    minHeight: 100, // 최소 높이 설정
                    maxHeight: 200, // 최대 높이 설정
                  ),
                  child: Text(content),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text('참여하기', style: TextStyle(color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 2.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Text('뒤로가기', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildBasketballListItem(BuildContext context, String title, String description) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            child: Image.asset(
              'lib/assets/images/logo.png', // 로고 이미지 경로
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BasketballPage1(),
  ));
}
