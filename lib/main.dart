import 'package:flutter/material.dart';
import 'package:frontend/registration.dart';
import 'ProductCatalog.dart';
import 'home_page.dart';
import 'login.dart';
import 'splash_screen.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'about.dart';
import 'first.dart';
import 'contact.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The house coffee shop',
      home: First(),
      initialRoute: '/',
      routes: {

        '/login': (context) => LoginPage(), // Define a route for LoginPage
        '/registration' : (context) => RegistrationPage(),
        '/about' : (context) => AboutPage(),
        '/first' : (context) => First(),
        '/contact' : (context) => ContactPage(),
      },
    );
  }
}