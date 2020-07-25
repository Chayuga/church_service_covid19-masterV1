import 'package:church_service/registration/login_page.dart';
import 'package:church_service/registration/signup_page.dart';
import 'package:church_service/screens/survey.dart';
import 'package:flutter/material.dart';
import 'package:church_service/screens/route_controller.dart';

import 'screens/bookin_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Screen ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: 'RouteController',
      routes: {
        'RouteController': (context) => RouteController(),
        'LogIn': (context) => LoginScreen(),
        'SignUp': (context) => SignUpScreen(),
        'Home': (context) => SurveyQuiz(),
        'Survey': (context) => SurveyQuiz(),
        'BookASeat': (context) => BookASeat(),
      },
    );
  }
}
