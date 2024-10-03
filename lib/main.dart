import 'package:flutter/material.dart';
import 'package:travle_1/pages/home_page.dart';
import 'package:travle_1/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(
          userId: '',
          userName: '', // ต้องระบุค่าเริ่มต้นให้เป็นค่าว่าง
          email: '',
          profileImage: '',
        ),
      },
    );
  }
}

