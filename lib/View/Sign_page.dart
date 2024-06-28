import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login_Page.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _nickname = '';
  String _name = '';
  int _age = 0;
//수정
//수정
  void _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        // Firestore에 사용자 데이터 저장
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'nickname': _nickname,
          'name': _name,
          'age': _age,
          'email': _email,
          'points': 1000, // 기본 포인트 1000 지급
          'entries': 0, // 기본 응모 횟수 0 설정
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 성공')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입 실패: ${e.message}')),
        );
      }
    }
  }

  Widget buildLabel(String text) {
    return Container(
      margin: EdgeInsets.only(left: 12, top: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildTextFormField(String hintText, {bool obscureText = false, TextInputType keyboardType = TextInputType.text, required FormFieldValidator<String> validator, required FormFieldSetter<String> onSaved}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'PLAYER',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w800,
                      fontSize: 50,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buildLabel('닉네임'),
                buildTextFormField(
                  '사용자 닉네임을 입력해주세요',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nickname = value ?? '';
                  },
                ),
                buildLabel('이름'),
                buildTextFormField(
                  '이름을 입력해주세요',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이름을 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                ),
                buildLabel('나이'),
                buildTextFormField(
                  '나이를 입력해주세요',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '나이를 입력하세요';
                    }
                    if (int.tryParse(value) == null) {
                      return '유효한 나이를 입력하세요';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.parse(value ?? '0');
                  },
                ),
                buildLabel('이메일'),
                buildTextFormField(
                  '이메일을 입력해주세요',
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
                buildLabel('비밀번호'),
                buildTextFormField(
                  '비밀번호를 입력해주세요',
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
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.black,
                  ),
                  child: Text('PLAYER 시작하기!'),
                ),
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
    home: SignUpScreen(),
  ));
}
