import 'dart:developer';

import 'package:church_service/http/http_response/http_response.dart';
import 'package:church_service/models/Response.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _SignUpScreenState extends State<SignUpScreen> implements HttpCallBack {
  //declare variables ........................
  String mobile;
  String email;
  String password;

  //declare progress dialog
  ProgressDialog pr;

  //validate fields
  bool _validate = false;

  //login status declaration
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  // declare Controllers....................
  TextEditingController _mobile = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();

  //declare global keys ........................
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //
  String emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  String mobilePattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  //Declare response
  HttpResponse _response;

  //initialize response
  _SignUpScreenState() {
    _response = new HttpResponse(this);
  }

  //on login button clicked calls this
  void _submit() {
    final form = _formKey.currentState;
    if (form.validate() && _validate == false) {
      setState(() {
        form.save();
        _response.doSign(email, mobile, password);
      });
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          '$text',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1),
        ),
        backgroundColor: Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
//      customBody: LinearProgressIndicator(
//        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//        backgroundColor: Colors.white,
//      ),
    );

    pr.style(
      message: 'Loading',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
    return Scaffold(
      key: _scaffoldKey, //Scaffold key/............
      backgroundColor: Colors.white,
      body: Container(
        child: Form(
          key: _formKey,
          child: Container(
            child: ListView(
              children: <Widget>[
                BackButtonWidget(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.phone), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                onSaved: (val) => mobile = val,
                                controller: _mobile,
                                decoration:
                                    InputDecoration(hintText: 'Phone number'),
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.lock), onPressed: null),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(right: 20, left: 10),
                              child: TextFormField(
                                onSaved: (val) => password = val,
                                controller: _password,
                                decoration:
                                    InputDecoration(hintText: 'Password'),
                              )))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: Icon(Icons.mail), onPressed: null),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 20, left: 10),
                          child: TextFormField(
                            onSaved: (val) => email = val,
                            controller: _email,
                            decoration: InputDecoration(hintText: 'Email'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Radio(value: null, groupValue: null, onChanged: null),
                      RichText(
                        text: TextSpan(
                          text: 'I have accepted the',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Terms & Condition',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      height: 54,
                      child: RaisedButton(
                        onPressed: () {
                          setState(
                            () {
                              if (_mobile.text.isEmpty &&
                                  _email.text.isEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Fields required");
                              } else if (_mobile.text.isNotEmpty &&
                                  _email.text.isEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Fields required");
                              }
                              if (_mobile.text.isEmpty &&
                                  _email.text.isEmpty &&
                                  _password.text.isNotEmpty) {
                                _validate = true;
                                _showSnackBar("Fields required");
                              }
                              if (_mobile.text.isEmpty &&
                                  _email.text.isNotEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Fields required");
                              } else if (_mobile.text.isEmpty &&
                                  _email.text.isNotEmpty &&
                                  _password.text.isNotEmpty) {
                                _validate = true;
                                _showSnackBar("Mobile  required");
                              } else if (_mobile.text.isNotEmpty &&
                                  _email.text.isEmpty &&
                                  _password.text.isNotEmpty) {
                                _validate = true;
                                _showSnackBar("Email  required");
                              } else if (_mobile.text.isNotEmpty &&
                                  _email.text.isNotEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Email  required");
                              } else if (_mobile.text.isNotEmpty &&
                                  _email.text.isNotEmpty &&
                                  _password.text.isNotEmpty) {
                                RegExp regexEmail = RegExp(emailPattern);
                                if (!regexEmail.hasMatch(_email.text)) {
                                  _showSnackBar("Enter valid email address");
                                } else {
                                  if (_formKey.currentState.validate()) {
                                    pr.show();
                                    _validate = false;
                                    _submit();
                                  }
                                }
                              }
                            },
                          );
                        },
                        color: Color(0xFF00a79B),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void onError(String error) {
    // TODO: implement onError
    pr.hide();
    log('Sign error: $error');
  }

  @override
  void onSuccess(Response response) {
    // TODO: implement onSuccess
    if (response != null) {
      if (response.error == false) {
        pr.hide();
        String message = response.user['message'];
        String userId = response.user['user_id'];
        String mobile = response.user['mobile'];
        String email = response.user['email'];

        showToast("Welcome back $email");
        savePref(1, userId, email, mobile);
        setState(() {});
        _loginStatus = LoginStatus.signIn;
        Navigator.pushNamed(context, 'Survey');
      } else if (response.error == true) {
        pr.hide();
        String message = response.user['message'];
        showToast("$message");
      }
    } else {
      pr.hide();
      showToast("failed try later");
    }
  }

  savePref(int value, String userId, String email, String mobile) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("userId", userId);
      preferences.setString("email", email);
      preferences.setString("mobile", mobile);
      preferences.commit();
    });
  }
}

//show toast message
void showToast(String message) {
  Fluttertoast.showToast(
      msg: '$message',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white);
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('asset/img/app.png'))),
      child: Positioned(
          child: Stack(
        children: <Widget>[
          Positioned(
              top: 20,
              child: Row(
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text(
                    'Back',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Create New Account',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          )
        ],
      )),
    );
  }
}
