import 'dart:io';

import 'package:aakashien/api/user_api_service.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:aakashien/screens/edit_details/edit_details.dart';
import 'package:aakashien/screens/login/login.dart';
import 'package:aakashien/screens/phone_verification/phone_verification.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:chopper/chopper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _phoneForm = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _currentUser = new UserModel.general();
  var _userToken;

  var _userEmail, _imageUrl;
  final _defaultImage =
      'https://firebasestorage.googleapis.com/v0/b/aakashienapp.appspot.com/o/profile_picture%2Fprofile-image-placeholder.png?alt=media&token=9befe26c-a77d-4697-b233-3c40ff22740d';

  _gotoLogin() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();

    _prefs.then((SharedPreferences prefs) {
      var newUser = prefs.getBool('newUser') ?? false;
      setState(() {
        _currentUser.phone = prefs.getString('userPhone') ?? null;
        _currentUser.email = prefs.getString('userEmail') ?? null;
        _currentUser.institution = prefs.getString('userInstitution') ?? null;
        _currentUser.name = prefs.getString('userName') ?? null;
        _userToken = prefs.getString('userToken') ?? null;
        _currentUser.branch = prefs.getString('userBranch') ?? null;

        debugPrint(
            '${_currentUser.name} : ${_currentUser.email} : ${_currentUser.branch}');
      });

      if (_userToken == null) {
        _gotoLogin();
      } else {
        if (newUser || _currentUser.branch == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditDetails(_userToken, _currentUser)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: myColors.background,
      appBar: AppBar(
        centerTitle: false,
        brightness: Brightness.dark,
        title: const Text(
          'Profile',
          style: TextStyle(color: myColors.white),
        ),
        elevation: 0,
        backgroundColor: myColors.black,
      ),
      body: _buildBody(context),
    );
  }

  FutureBuilder<Response<UserModel>> _buildBody(BuildContext context) {
    return FutureBuilder<Response<UserModel>>(
      future: Provider.of<UserApiService>(context).userDetails(_userToken),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data.isSuccessful) {
              _currentUser = snapshot.data.body;
              return _buildProfile(context, _currentUser);
            } else {
              return Center(
                child: Text('Something went wrong, please try again later'),
              );
            }
          } else {
            return Center(
              child: Text('No internet connection'),
            );
          }
        } else {
          return Center(
            child: Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(myColors.black),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProfile(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: myColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 75,
                    color: myColors.black,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 20,
                          width: 60,
                          child: OutlineButton(
                            child: Text(
                              'edit',
                              style: TextStyle(
                                  color: myColors.white, fontSize: 14),
                            ),
                            borderSide: BorderSide(color: myColors.white),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: _editDetails,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Transform(
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _getFromGallery,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    user.profileImg ?? _defaultImage,
                                    height: 140,
                                    width: 140,
                                  ),
                                ),
                              ),
                              Transform(
                                transform: Matrix4.translationValues(0, 20, 0),
                                child: Container(
                                  width: 140,
                                  child: Text(
                                    user.name,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width -
                                    140 -
                                    30 -
                                    20,
                                child: Transform(
                                  transform:
                                      Matrix4.translationValues(0, 45, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (user.dob != null)
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              child: Icon(Icons.cake_rounded),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              user.dob ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      if (user.gender != null)
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              child: IconButton(
                                                  icon: Image.asset(
                                                      'assets/images/icons/gender.png'),
                                                  onPressed: null),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              user.gender ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      if (user.location != null)
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              child: Icon(Icons.location_on),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  140 -
                                                  30 -
                                                  20 -
                                                  42,
                                              child: Text(
                                                user.location ?? '',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (user.phone != null)
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              child: Icon(
                                                  Icons.phone_iphone_rounded),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              user.phone ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: myColors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'School Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    if (user.batch != null)
                      Text(
                        'Class of ${user.batch}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    if (user.branch != null)
                      Text(
                        '${user.branch}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (user.jobTitle != null)
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Employment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${user.jobTitle}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${user.jobCompany ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: myColors.lightText),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 10,
            ),
            if (user.higherEducationInstitution != null)
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Higher Education',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${user.higherEducationInstitution ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${user.higherEducationBranch ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: myColors.lightText),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Class of ${user.higherEducationBatch ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: myColors.lightText),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 40,
              child: FlatButton(
                  color: myColors.white,
                  onPressed: _showAddPhoneBottomSheet,
                  child: Text(
                    'Update Phone',
                    style: TextStyle(
                        color: myColors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: myColors.lightText, width: 1.0))),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 40,
              width: 150,
              child: FlatButton(
                  color: myColors.white,
                  onPressed: _showLogoutDialog,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0),
                      side: BorderSide(color: myColors.lightText, width: 1.0))),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _editDetails() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditDetails(_userToken, _currentUser)));
  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    _cropImage(pickedFile.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxWidth: 720,
        maxHeight: 720,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

    debugPrint(croppedImage.path);
    _uploadPic(context, croppedImage);
  }

  Future _uploadPic(BuildContext context, File imageFile) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('profile_picture/${_currentUser.email}');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
      () => setState(() {
        print("Profile Picture uploaded");
        // Scaffold.of(context)
        //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));

        firebaseStorageRef.getDownloadURL().then((value) {
          debugPrint(value);
          _imageUrl = value;
          _updateUserDetails(_userToken, _imageUrl);
        });
      }),
    );
  }

  // _getProfileImage() async {
  //   Reference firebaseStorageRef = FirebaseStorage.instance
  //       .ref()
  //       .child('profile_picture/${_currentUser.email}');
  //   firebaseStorageRef.getDownloadURL().then(
  //         (value){
  //         // setState(
  //         //   () {
  //             _imageUrl = value;
  //             debugPrint('profile Image: $_imageUrl');
  //             _updateUserDetails(_userToken, _imageUrl);
  //           // },
  //         // ),
  //       });
  // }

  void _updateUserDetails(token, imageUrl) async {
    var userDetails = {'profileImg': _imageUrl};

    var _statusText;

    await Provider.of<UserApiService>(context, listen: false)
        .updateDetails(token, userDetails)
        .then((response) {
      if (response.isSuccessful) {
        _statusText = 'Update details successful';
        _currentUser = response.body;
        debugPrint(_statusText);
        // _saveUserDetails(_currentUser);
        setState(() {
          _currentUser = response.body;
          _imageUrl = _currentUser.profileImg;
        });
      } else {
        // if (response.statusCode == 409) _statusText = 'User already exists';
        // if (response.statusCode == 404)
        //   _statusText = 'Email/Phone does not exist';
        if (response.statusCode == 400)
          _statusText = 'Something went wrong, please try again';

        final snackBar = SnackBar(content: Text(_statusText));
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      // setState(() {
      //   _isLoading = false;
      // });
    });
  }

  void _logoutUser() {
    _prefs.then((prefs) => prefs.clear());
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  void _showLogoutDialog() {
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: myColors.lightText, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          color: Colors.red,
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: _logoutUser,
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showAddPhoneBottomSheet() {
    var newPhone;

    Widget bottomSheet = Padding(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Update phone number',
            style: TextStyle(
              fontSize: 20,
              color: myColors.titleText,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
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
                  initialValue: _currentUser.phone ?? '+91',
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
                    newPhone = val;
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
                FlatButton(
                  color: myColors.green,
                  onPressed: () => _gotoPhoneVerification(newPhone),
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

  _gotoPhoneVerification(newPhone) {
    var _isValid = _phoneForm.currentState.validate();
    if (!_isValid) return;

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PhoneVerification(_userToken, newPhone)));
  }
}
