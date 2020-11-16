import 'package:aakashien/utility/myColors.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.greyBackground,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: AssetImage('assets/images/logo_semicircle.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30, color: myColors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 50, 10, 20),
                child: Center(
                  child: TextField(
                    style: TextStyle(),
                    decoration: InputDecoration(
                      hintText: 'Email/Mobile',
                      fillColor: myColors.white,
                      filled: true,
                      labelStyle: TextStyle(color: myColors.greyBackground),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.mail,
                        color: myColors.greyBackground,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
