import 'dart:async';

import 'package:aakashien/api/user_api_service.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:aakashien/screens/profile/profile.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerification extends StatefulWidget {
  String phone, userToken;
  bool _isLoading = false;

  PhoneVerification(this.userToken, this.phone);

  @override
  _PhoneVerificationState createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hasError = false;
  String currentText = "";
  TextEditingController textEditingController = TextEditingController();
  var _verificationID;
  var status;
  bool _isLoading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _resendToken;

  StreamController<ErrorAnimationType> errorController;

  Future _sendOTP(String mobile, BuildContext context) async {
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          _onAuthenticationSuccessful();
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.message);
        setState(() {
          status = authException.message;
        });

        _onAuthenticationFailed();
      },
      codeSent: (String verificationId, int forceResendingToken) {
        _resendToken = forceResendingToken;
        _verificationID = verificationId;
        debugPrint('OTP SEND ');
        final snackBar = SnackBar(content: Text('Code send'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("Timeout");
        final snackBar = SnackBar(
            content: Text('Auto retrieval timed out. Enter OTP manually'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
    );
  }

  Future _resendOTP(String mobile, BuildContext context, resendToken) async {
    _auth.verifyPhoneNumber(
      phoneNumber: mobile,
      timeout: Duration(seconds: 60),
      forceResendingToken: resendToken,
      verificationCompleted: (AuthCredential authCredential) {
        _auth
            .signInWithCredential(authCredential)
            .then((UserCredential result) {
          _onAuthenticationSuccessful();
        }).catchError((e) {
          print(e);
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        print(authException.message);
        setState(() {
          status = authException.message;
        });

        _onAuthenticationFailed();
      },
      codeSent: (String verificationId, int forceResendingToken) {
        _resendToken = forceResendingToken;
        _verificationID = verificationId;
        debugPrint('OTP SEND ');
        final snackBar = SnackBar(content: Text('Code send'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("Timeout");
        final snackBar = SnackBar(
            content: Text('Auto retrieval timed out. Enter OTP manually'));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
    );
  }

  void _signInWithOTP(String smsCode) async {
    final snackBar = SnackBar(content: Text('Verifying code'));
    _scaffoldKey.currentState.showSnackBar(snackBar);

    AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationID, smsCode: smsCode);
    _auth.signInWithCredential(_authCredential).then((value) {
      setState(() {
        status = 'Authentication successful';
        _onAuthenticationSuccessful();
      });
    }).catchError((error) {
      setState(() {
        status = 'Something has gone wrong, please try later';
      });
      _onAuthenticationFailed();
    });
  }

  void _onAuthenticationFailed() {
    final snackBar = SnackBar(content: Text(status));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _onAuthenticationSuccessful() {
    debugPrint('Auth Success');
    setState(() {
      _isLoading = true;
    });
    _updateUserPhone(widget.userToken, widget.phone);
  }

  void _updateUserPhone(token, phone) async {
    var phoneDetails = {'phone': phone};
    // var headers = {'auth-token', token};

    var _statusText;
    UserModel _currentUser;

    await Provider.of<UserApiService>(context, listen: false)
        .updatePhone(token, phoneDetails)
        .then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.isSuccessful) {
        _statusText = 'Update phone successful';
        _currentUser = response.body;

        _saveUserDetails(_currentUser);
      } else {
        if (response.statusCode == 409) {
          _statusText = 'This phone is linked to another account';
          _showPhoneExistDialog(context);
        }
        // if (response.statusCode == 404)
        //   _statusText = 'Email/Phone does not exist';
        if (response.statusCode == 400)
          _statusText = 'Something went wrong, please try again';

        debugPrint('Update failed : $_statusText');

        final snackBar = SnackBar(content: Text(_statusText));
        _scaffoldKey.currentState.showSnackBar(snackBar);

        // Navigator.pop(context);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showPhoneExistDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Update failed"),
      content: Text("This phone is linked to another account"),
      actions: [TextButton(onPressed: _gotoProfile, child: Text('Ok'))],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _saveUserDetails(UserModel user) {
    _prefs.then((prefs) {
      prefs.setString('userPhone', user.phone);
      _gotoProfile();
    });
  }

  _gotoProfile() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Profile()), (_) => false);
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();

    _sendOTP(widget.phone, context);
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: myColors.greyBackground,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Image(
                    image: AssetImage('assets/images/phone_verification.png'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Phone Verification',
                    style: TextStyle(color: myColors.white, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: PinCodeTextField(
                      appContext: context,
                      backgroundColor: myColors.greyBackground,
                      pastedTextStyle: TextStyle(
                        color: myColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      dialogConfig: null,
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v.length < 1) {
                          return "Enter 6 digit OTP";
                        } else {
                          return null;
                        }
                      },
                      errorTextSpace: 20,
                      pinTheme: PinTheme(
                        inactiveColor: myColors.white,
                        inactiveFillColor: myColors.white,
                        selectedColor: myColors.white,
                        selectedFillColor: myColors.white,
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 40,
                        activeColor: myColors.white,
                        activeFillColor:
                            hasError ? myColors.white : myColors.white,
                      ),
                      cursorColor: myColors.white,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      // backgroundColor: Colors.blue.shade50,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed $v");
                        _signInWithOTP(v);
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      // beforeTextPaste: (text) {
                      //   print("Allowing to paste $text");
                      //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      //   return true;
                      // },
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Verification code has been sent to ${widget.phone}',
                    style: TextStyle(color: myColors.white, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _resendOTP(widget.phone, context, _resendToken),
                      child: Text(
                        'RESEND',
                        style: TextStyle(color: myColors.green, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
