import 'package:aakashien/api/user_api_service.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:aakashien/screens/phone_verification/phone_verification.dart';
import 'package:aakashien/screens/profile/profile.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with WidgetsBindingObserver {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _signupForm = GlobalKey<FormState>();
  var _phoneForm = GlobalKey<FormState>();
  var _userToken;
  FocusNode passwordFocusNode = FocusNode();

  String _email, _password, _name, _confirmPassword, _institute, _phone;
  FirebaseAuth _auth;
  var _isAuthenticated = false;
  var _emailSent = false;
  bool _isLoading = false;

  var _institutions = ['ASIET B-Tech', 'ASIET M-Tech', 'ASIET MBA'];

  void _signup() {
    passwordFocusNode.unfocus();
    var _isValid = _signupForm.currentState.validate();
    if (!_isValid) return;

    if (!_isLoading) {
      _sendSignInWithEmailAndLink()
          .then((_) => _showEmailSentAlertDialog(context));
    }

    // _showAddPhoneBottomSheet();
  }

  void _showEmailSentAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Email Verification"),
      content: Text(
          "We have sent a verification mail to $_email with further instructions."),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _sendSignInWithEmailAndLink() async {
    var _userEmail = _email;
    return await _auth.sendSignInLinkToEmail(
      email: _userEmail,
      actionCodeSettings: ActionCodeSettings(
          url: "https://aakashien.page.link",
          androidPackageName: "com.app.aakashien",
          iOSBundleId: "com.app.aakashien",
          handleCodeInApp: true,
          androidMinimumVersion: "21",
          androidInstallApp: false),
    );
  }

  Future<void> _retrieveDynamicLink() async {
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data?.link != null) {
      _handleLink(data?.link);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      _handleLink(deepLink);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void _handleLink(Uri link) async {
    if (link != null) {
      final User user = (await _auth.signInWithEmailLink(
        email: _email,
        emailLink: link.toString(),
      ))
          .user;
      if (user != null) {
        setState(() {
          // _userID = user.uid;
          _isAuthenticated = true;
          debugPrint('Auth Success');

          _authSuccessAction();
        });
        // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Success')));
      } else {
        setState(() {
          // _success = false;
          debugPrint('Auth fail 1');
        });
      }
    } else {
      setState(() {
        // _success = false;
        debugPrint('Auth fail 2');
      });
    }
    setState(() {});
  }

  void _authSuccessAction() async {
    Navigator.pop(context);

    setState(() {
      _isLoading = true;
    });

    // _showAddPhoneBottomSheet();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('userEmail', _email);

    _signupUser(_email, _password, _institute, _name);
  }

  void _signupUser(email, password, institution, name) async {
    var signupCredentials = {
      'email': email,
      'password': password,
      'institution': institution,
      'name': name
    };
    var _statusText;
    UserModel _currentUser;

    await Provider.of<UserApiService>(context, listen: false)
        .signup(signupCredentials)
        .then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.isSuccessful) {
        _statusText = 'User registration successful';
        _currentUser = response.body;
        _userToken = response.headers['auth-token'];
        debugPrint(_statusText);
        _saveUserDetails(_currentUser, _userToken);

        _showAddPhoneBottomSheet();
      } else {
        if (response.statusCode == 409) _statusText = 'User already exists';
        // if (response.statusCode == 404)
        //   _statusText = 'Email/Phone does not exist';
        if (response.statusCode == 400)
          _statusText = 'Something went wrong, please try again';

        final snackBar = SnackBar(content: Text(_statusText));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _saveUserDetails(UserModel user, String token) {
    _prefs.then((prefs) {
      prefs.setString('userEmail', user.email);
      prefs.setString('userName', user.name);
      prefs.setString('userInstitution', user.institution);
      prefs.setString('userToken', token);
      prefs.setBool('newUser', true);
    });
  }

  void _showAddPhoneBottomSheet() {
    Widget bottomSheet = Padding(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add phone number',
            style: TextStyle(
              fontSize: 20,
              color: myColors.titleText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Add mobile number to complete your profile',
            style: TextStyle(
              fontSize: 18,
              color: myColors.mediumText,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _phoneForm,
                child: TextFormField(
                  initialValue: '+91',
                  maxLines: 1,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Phone',
                    fillColor: myColors.white,
                    filled: true,
                    labelStyle: const TextStyle(color: myColors.greyBackground),
                    border: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide:
                          const BorderSide(color: myColors.greyBackground),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                      borderSide:
                          const BorderSide(color: myColors.greyBackground),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone_iphone_rounded,
                      color: myColors.greyBackground,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _phone = val;
                    });
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: (val) {
                    if (val.length < 10) return 'Enter valid mobile number';
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Text(
                    'Skip',
                    style: TextStyle(color: myColors.lightText),
                  ),
                  onTap: _gotoProfile,
                ),
                SizedBox(
                  width: 15,
                ),
                FlatButton(
                  color: myColors.green,
                  onPressed: _gotoPhoneVerification,
                  child: Text(
                    'VERIFY',
                    style: TextStyle(
                      color: myColors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (BuildContext bc) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: bottomSheet,
            ),
          );
        });
  }

  _gotoProfile() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Profile()), (_) => false);
  }

  _gotoPhoneVerification() {
    var _isValid = _phoneForm.currentState.validate();
    if (!_isValid) return;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PhoneVerification(_userToken, _phone)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Firebase.initializeApp().then((value) => _auth = FirebaseAuth.instance);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint(state.toString());
    if (state == AppLifecycleState.resumed) {
      _retrieveDynamicLink();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios_rounded, color: myColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: myColors.greyBackground,
        elevation: 0,
      ),
      backgroundColor: myColors.greyBackground,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          // height: MediaQuery.of(context).size.height -
          //     AppBar().preferredSize.height,
          padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
          child: Form(
            key: _signupForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: myColors.white,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    fillColor: myColors.white,
                    filled: true,
                    labelStyle: TextStyle(color: myColors.greyBackground),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.person_rounded,
                      color: myColors.greyBackground,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _name = val;
                    });
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: (val) {
                    if (val.isEmpty) return 'Enter your name';
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    fillColor: myColors.white,
                    filled: true,
                    labelStyle: TextStyle(color: myColors.greyBackground),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                      color: myColors.greyBackground,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                    });
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: (val) {
                    if (val.isEmpty) return 'Enter valid email';
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                      color: myColors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: myColors.greyBackground, width: 1)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.account_balance_rounded,
                          color: myColors.greyBackground,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<String>(
                            items: _institutions.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: myColors.greyBackground),
                                  ),
                                ),
                              );
                            }).toList(),
                            value: _institute,
                            onChanged: (value) {
                              setState(() {
                                _institute = value;
                              });
                            },
                            validator: (value) => value == null
                                ? 'Select your Institution'
                                : null,
                            isExpanded: true,
                            style: TextStyle(color: myColors.greyBackground),
                            iconSize: 24,
                            icon: const Icon(Icons.arrow_drop_down),
                            hint: const Text("Select Institution"),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    fillColor: myColors.white,
                    filled: true,
                    labelStyle: TextStyle(color: myColors.greyBackground),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: myColors.greyBackground,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: (val) {
                    if (val.isEmpty || val.length < 8)
                      return 'Password must contain at least 8 characters';
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  focusNode: passwordFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                    fillColor: myColors.white,
                    filled: true,
                    labelStyle: TextStyle(color: myColors.greyBackground),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: myColors.greyBackground,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _confirmPassword = val;
                    });
                  },
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  validator: (val) {
                    if (_password != null && val != _password)
                      return "Passwords don't match";
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Spacer(),
                    FloatingActionButton(
                      onPressed: _signup,
                      backgroundColor: myColors.green,
                      child: _isLoading
                          ? Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator())
                          : Icon(
                              Icons.arrow_forward_rounded,
                              color: myColors.white,
                            ),
                    ),
                  ],
                ),
                // Spacer(),
                SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            'By signing up, you agree to our ',
                            style: TextStyle(color: myColors.background),
                          ),
                          Text(
                            'Terms & Conditions',
                            style: TextStyle(color: myColors.green),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            'and ',
                            style: TextStyle(color: myColors.background),
                          ),
                          Text(
                            'Privacy policy',
                            style: TextStyle(color: myColors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
