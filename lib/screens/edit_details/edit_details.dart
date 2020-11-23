import 'package:aakashien/api/user_api_service.dart';
import 'package:aakashien/models/userModel.dart';
import 'package:aakashien/screens/profile/profile.dart';
import 'package:aakashien/utility/myColors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDetails extends StatefulWidget {
  UserModel user;
  String userToken;

  @override
  _EditDetailsState createState() => _EditDetailsState();

  EditDetails(this.userToken, this.user);
}

class _EditDetailsState extends State<EditDetails> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _schoolDetailsForm = GlobalKey<FormState>();
  var _employmentDetailsForm = GlobalKey<FormState>();
  var _higherDetailsForm = GlobalKey<FormState>();
  var _personalDetailsForm = GlobalKey<FormState>();

  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();

  var _btechBranch = [
    'Electronics & Communication',
    'Computer Science',
    'Mechanical',
    'Civil',
    'Electrical & Electronics'
  ];
  var _mbaBranch = ['Finance & Marketing', 'Human Resources'];
  var _mtechBranch = [
    'Computer Science',
    'Power Electronics & Power Systems',
    'VLSI & Embedded Systems',
    'Communication Engineering'
  ];
  var _gender = ['Male', 'Female', 'Other'];

  List<String> _setPassoutYear() {
    List<String> _years = [];

    for (int i = 2000; i <= 2020; i++) {
      _years.add(i.toString());
    }
    return _years;
  }

  List<String> _branches() {
    var branches = ['No Institution Selected'];
    if (widget.user.institution == 'ASIET B-Tech') {
      branches = _btechBranch;
    }
    if (widget.user.institution == 'ASIET M-Tech') {
      branches = _mtechBranch;
    }
    if (widget.user.institution == 'ASIET MBA') {
      branches = _mbaBranch;
    }
    return branches;
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(1980),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        widget.user.dob = _selectedDate.day.toString() +
            '/' +
            _selectedDate.month.toString() +
            '/' +
            _selectedDate.year.toString();
      });
  }

  void _saveDetails() {
    var _isValid = _schoolDetailsForm.currentState.validate();
    if (!_isValid) return;
    var _isNameValid = _personalDetailsForm.currentState.validate();
    if (!_isNameValid) return;

    UserModel user = widget.user;

    if (!_isLoading) {
      _updateUserDetails(
          widget.userToken,
          user.branch,
          user.batch,
          user.name,
          user.location,
          user.gender,
          user.dob,
          user.jobTitle,
          user.jobCompany,
          user.higherEducationInstitution,
          user.higherEducationBranch,
          user.higherEducationBatch);
    }
  }

  void _updateUserDetails(
      token,
      branch,
      batch,
      name,
      location,
      gender,
      dob,
      jobTitle,
      jobCompany,
      higherEducationInstitution,
      higherEducationBranch,
      higherEducationBatch) async {
    var userDetails = {
      'branch': branch,
      'batch': batch,
      'name': name,
      if (location != null) 'location': location,
      if (gender != null) 'gender': gender,
      if (dob != null) 'dob': dob,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (jobCompany != null) 'jobCompany': jobCompany,
      if (higherEducationInstitution != null)
        'higherEducationInstitution': higherEducationInstitution,
      if (higherEducationBranch != null)
        'higherEducationBranch': higherEducationBranch,
      if (higherEducationBatch != null)
        'higherEducationBatch': higherEducationBatch,
    };
    var _statusText;
    UserModel _currentUser;

    await Provider.of<UserApiService>(context, listen: false)
        .updateDetails(token, userDetails)
        .then((response) {
      setState(() {
        _isLoading = false;
      });

      if (response.isSuccessful) {
        _statusText = 'Update details successful';
        _currentUser = response.body;
        debugPrint(_statusText);
        _saveUserDetails(_currentUser);
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
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _saveUserDetails(UserModel user) {
    _prefs.then((prefs) {
      prefs.setBool('newUser', false);
      prefs.setString('userBranch', widget.user.branch);

      _gotoProfile();
    });
  }

  _gotoProfile() {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Profile()), (_) => false);
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
          'Edit details',
          style: TextStyle(color: myColors.white),
        ),
        leading: _isLoading
            ? Container(
                width: 25, height: 25, child: CircularProgressIndicator())
            : IconButton(
                icon: const Icon(Icons.clear_outlined, color: myColors.white),
                onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                    (Route<dynamic> route) => false),
              ),
        actions: [
          FlatButton(
            onPressed: _saveDetails,
            child: _isLoading
                ? Container(
                    width: 25, height: 25, child: CircularProgressIndicator())
                : Text(
                    'Save',
                    style: TextStyle(color: myColors.white),
                  ),
            color: myColors.black,
          )
        ],
        elevation: 0,
        backgroundColor: myColors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _schoolDetailsForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'School Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Text('Select Branch'),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: myColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: myColors.greyBackground,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.account_balance_outlined,
                                  color: myColors.greyBackground,
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    items: _branches().map((String value) {
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
                                    value: widget.user.branch,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.user.branch = value;
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? 'Select your branch'
                                        : null,
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: myColors.greyBackground),
                                    iconSize: 24,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text("Select Branch"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Text('Select Batch'),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: myColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: myColors.greyBackground,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: myColors.greyBackground,
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    items:
                                        _setPassoutYear().map((String value) {
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
                                    value: widget.user.batch,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.user.batch = value;
                                      });
                                    },
                                    validator: (value) => value == null
                                        ? 'Select your batch'
                                        : null,
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: myColors.greyBackground),
                                    iconSize: 24,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text("Select Batch"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _personalDetailsForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.name,
                          initialValue: widget.user.name,
                          decoration: const InputDecoration(
                            hintText: 'Name',
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
                              Icons.person_rounded,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.name = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          initialValue: widget.user.location,
                          decoration: const InputDecoration(
                            hintText: 'Current City',
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
                              Icons.location_on,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.location = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            // if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: myColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: myColors.greyBackground,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: IconButton(
                                      icon: Image.asset(
                                          'assets/images/icons/gender.png'),
                                      onPressed: null),
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    items: _gender.map((String value) {
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
                                    value: widget.user.gender,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.user.gender = value;
                                      });
                                    },
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: myColors.greyBackground),
                                    iconSize: 24,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text("Gender"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            height: 55,
                            decoration: BoxDecoration(
                              color: myColors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: myColors.greyBackground,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    child: Icon(
                                      Icons.date_range_rounded,
                                      color: myColors.greyBackground,
                                    ),
                                  ),
                                ),
                                Text(widget.user.dob ?? 'D.O.B'),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _employmentDetailsForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Employment Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          initialValue: widget.user.jobTitle,
                          decoration: const InputDecoration(
                            hintText: 'Job Role',
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
                              Icons.person_pin_outlined,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.jobTitle = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          initialValue: widget.user.jobCompany,
                          decoration: const InputDecoration(
                            hintText: 'Company Name',
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
                              Icons.work,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.jobCompany = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: myColors.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _higherDetailsForm,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Higher Education Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          initialValue: widget.user.higherEducationInstitution,
                          decoration: const InputDecoration(
                            hintText: 'Institution Name',
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
                              Icons.account_balance_rounded,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.higherEducationInstitution = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          initialValue: widget.user.higherEducationBranch,
                          decoration: const InputDecoration(
                            hintText: 'Course Name',
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
                              Icons.account_balance_outlined,
                              color: myColors.greyBackground,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              widget.user.higherEducationBranch = val;
                            });
                          },
                          onEditingComplete: () =>
                              FocusScope.of(context).nextFocus(),
                          validator: (val) {
                            if (val.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: myColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: myColors.greyBackground,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Icon(
                                  Icons.date_range_outlined,
                                  color: myColors.greyBackground,
                                ),
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    items:
                                        _setPassoutYear().map((String value) {
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
                                    value: widget.user.higherEducationBatch,
                                    onChanged: (value) {
                                      setState(() {
                                        widget.user.higherEducationBatch =
                                            value;
                                      });
                                    },
                                    isExpanded: true,
                                    style: TextStyle(
                                        color: myColors.greyBackground),
                                    iconSize: 24,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    hint: const Text("Select Batch"),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
