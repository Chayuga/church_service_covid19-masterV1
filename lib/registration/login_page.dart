// import 'package:flutter/gestures.dart';
import 'dart:developer';

import 'package:church_service/http/http_response/http_response.dart';
import 'package:church_service/models/Response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginScreenState extends State<LoginScreen> implements HttpCallBack {
//declare variables ........................
  String mobile;
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

  //declare global keys ........................
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  //Declare response
  HttpResponse _response;

  //initialize response
  _LoginScreenState() {
    _response = new HttpResponse(this);
  }

  //on login button clicked calls this
  void _submit() {
    final form = _formKey.currentState;
    if (form.validate() && _validate == false) {
      setState(() {
        form.save();
        _response.doLogin(mobile, password);
      });
    }
  }

  void _showSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        '$text',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, letterSpacing: 1),
      ),
      backgroundColor: Colors.grey[800],
    ));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Container(
        child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('asset/img/app.png'))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.contact_phone), onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 20, left: 10),
                            child: TextFormField(
                              onSaved: (val) => mobile = val,
                              keyboardType: TextInputType.phone,
                              controller: _mobile,
                              decoration:
                                  InputDecoration(hintText: 'Phone number'),
                            ),
                          ),
                        ),
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
                              obscureText: true,
                              decoration: InputDecoration(hintText: 'Password'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 60,
                        child: RaisedButton(
                          onPressed: () {
                            setState(() {
                              //validate textFields

                              if (_mobile.text.isEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Fields required");
                              } else if (_mobile.text.isNotEmpty &&
                                  _password.text.isEmpty) {
                                _validate = true;
                                _showSnackBar("Password required");
                              } else if (_mobile.text.isEmpty &&
                                  _password.text.isNotEmpty) {
                                _validate = true;
                                _showSnackBar("Mobile required");
                              } else {
                                if (_formKey.currentState.validate()) {
                                  pr.show();
                                  _validate = false;
                                  _submit();
                                }
                              }
                            });
                          },
                          color: Color(0xFF00a79B),
                          child: Text(
                            'SIGN IN',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'SignUp');
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Don\'t have an account?',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'SIGN UP',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  @override
  void onError(String error) {
    // TODO: implement onError
    pr.hide();
    log('Login error: $error');
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
        Navigator.pushNamed(context, 'BookASeat');
      } else if (response.error == true) {
        pr.hide();
        String message = response.user['message'];
        showToast("$message");
      }
    } else {
      pr.hide();
      showToast("failed");
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
