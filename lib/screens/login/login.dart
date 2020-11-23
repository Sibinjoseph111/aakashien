import 'package:aakashien/models/userModel.dart';
import 'package:aakashien/screens/profile/profile.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/user_api_service.dart';
import '../signup/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _form = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String _email, _password;
  bool _isLoading = false;
  var _userToken;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: myColors.greyBackground,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/logo_semicircle.png'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 40),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 30, color: myColors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Center(
                  child: Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'Email/Mobile',
                            fillColor: myColors.white,
                            filled: true,
                            labelStyle:
                                TextStyle(color: myColors.greyBackground),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.mail,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _email = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Enter email or password';
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
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            fillColor: myColors.white,
                            filled: true,
                            labelStyle:
                                TextStyle(color: myColors.greyBackground),
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
                          onChanged: (val) => _password = val,
                          validator: (val) {
                            if (val.isEmpty) return 'Enter your password';
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              '',
                              // 'Forgot Password?',
                              style: TextStyle(
                                color: myColors.background,
                              ),
                            ),
                            FloatingActionButton(
                              child: _isLoading
                                  ? Container(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator())
                                  : Icon(
                                      Icons.arrow_forward,
                                      color: myColors.white,
                                    ),
                              backgroundColor: myColors.green,
                              onPressed: _login,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: myColors.white, fontSize: 16),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: _gotoSignup,
                          child: Text(
                            "SIGN UP",
                            style:
                                TextStyle(color: myColors.green, fontSize: 16),
                          ),
                        ),
                      ],
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

  _login() {
    var _isValid = _form.currentState.validate();
    if (!_isValid) return;

    if (!_isLoading) {
      _loginUser(_email, _password);
      setState(() {
        _isLoading = true;
      });
    }

    // _gotoHome();
  }

  void _loginUser(email, password) async {
    var loginCredentials = {'login': email, 'password': password};
    var _statusText;
    UserModel _currentUser;

    await Provider.of<UserApiService>(context, listen: false)
        .login(loginCredentials)
        .then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.isSuccessful) {
        _statusText = 'Login successful';
        _currentUser = response.body;
        _userToken = response.headers['auth-token'];

        _saveUserDetails(_currentUser, _userToken);
      } else {
        if (response.statusCode == 401)
          _statusText = 'Password mismatch. Try again';
        if (response.statusCode == 404)
          _statusText = 'Email/Phone does not exist';
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
      prefs.setString('userBranch', user.branch);

      _gotoProfile();
    });
  }

  _gotoProfile() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Profile()), (_) => false);
  }

  _gotoSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }
}
