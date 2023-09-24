import 'package:flutter/material.dart';
import 'package:frontend/registration.dart';
import 'CashierPage.dart';
import 'CategoryPage.dart';
import 'Inventory.dart';
import 'ProductCatalog.dart';
import 'home_page.dart';
import 'login.dart';
import 'login_inventory.dart';
import 'menu.dart';
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
        '/caisse' : (context) => CashierPage(),
        '/stock' : (context) => InventoryManagementPage(),
        '/menu' : (context) => MenuTablet(),
        '/login_inventory' : (context) => LoginInventoryPage(),
      },
    );
  }
}