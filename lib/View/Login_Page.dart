import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Navigation_page.dart';
import 'Sign_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 성공')),
        );
        // 로그인 성공 시 사용자 정보를 가져옵니다.
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
        if (userDoc.exists) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationPage(user: {
                'uid': userCredential.user!.uid,
                'nickname': userDoc.get('nickname'),
                'points': userDoc.get('points'), // 포인트 정보 추가
              }), // user 매개변수를 전달합니다.
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사용자 정보를 찾을 수 없습니다.')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${e.message}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.1), // 상단 여백 추가
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'PLAYER',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.1, // 폰트 크기 화면 너비의 10%
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '이메일',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 4.0), // 항상 굵은 검정색 보더 설정
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value ?? '';
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 4.0), // 항상 굵은 검정색 보더 설정
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력하세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value ?? '';
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.1),
                Container(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // 텍스트 색상 설정
                      side: BorderSide(color: Colors.black, width: 3), // 테두리 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 둥근 모서리 설정
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 패딩 설정
                    ),
                    child: Text('로그인', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white, // 텍스트 색상 설정
                      side: BorderSide(color: Colors.black, width: 3), // 테두리 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 둥근 모서리 설정
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 패딩 설정
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text('회원가입', style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w700)),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Text(
                  'PLAYER를 통해 세계 PLAYER의 \n    경기를 눈앞에서 경험하세요!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center, // 텍스트 가운데 정렬
                ),
                SizedBox(height: screenHeight * 0.1), // 하단 여백 추가
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
