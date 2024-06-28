import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/Login_Page.dart';

// 수정
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAM1yLGaw62h71a1TX3X1RFRRXFod6JGz4',
      appId: '1:297970635159:android:e8fa9fcf5f5f0a6e17b4d2',
      messagingSenderId: '297970635159',
      projectId: 'hackathon-529c2',
    ),

  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
