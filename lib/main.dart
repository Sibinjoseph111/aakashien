import 'package:aakashien/screens/login/login.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: myColors.background,
        accentColor: myColors.white,

      ),
      home: Login(),
    );
  }
}

