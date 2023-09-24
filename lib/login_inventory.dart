import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Inventory.dart';

class LoginInventoryPage extends StatefulWidget {
  @override
  _LoginInventoryPageState createState() => _LoginInventoryPageState();
}

class _LoginInventoryPageState extends State<LoginInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Send the login request to the server
      final response = await http.post(
        Uri.parse('http://localhost:3000/login_inventory'), // Replace with your actual API URL
        body: {'email': _email, 'password': _password},
      );

      // Check the response status code and update the UI accordingly
      if (response.statusCode == 200) {
        // Login successful
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Navigate to the home screen or InventoryManagementPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                InventoryManagementPage(), // Replace with your desired destination
          ),
        );
      } else if (response.statusCode == 400) {
        // Invalid email or password
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['error']),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800], // Set the background color to gray
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.6, // Adjust the width as needed
          heightFactor: 0.8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[800], // Set the box color to gray
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(-5, 0),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(5, 0),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40),

                    SizedBox(height: 20),
                    Text(
                      'connectez vous',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 40),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'User',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _email = value;
                              },
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Mot de passe',
                                labelStyle: TextStyle(color: Colors.white),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _password = value;
                              },
                            ),
                            SizedBox(height: 40),
                            GestureDetector(
                              onTap: _submitForm,
                              child: Container(
                                height: 60,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black,
                                      Colors.white,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginInventoryPage(),
  ));
}
