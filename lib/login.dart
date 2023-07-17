import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Send the login request to the server
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
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
        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                MyHomePage(customerId: data['customer_id']),
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
          heightFactor : 0.8,
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
                    SvgPicture.string(
                      '''<svg xmlns="http://www.w3.org/2000/svg" class="site__logo" width="56" height="56" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path fill="#ffffff" d="M17 12v6h2v-6h3l-4-4-4 4h3zM3 4v16h18V4H3zm16 14H5V6h14v12z"/></svg>''',
                      color: Colors.white,
                      width: 56,
                      height: 56,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sign Up',
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
                                labelText: 'Email',
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
                                labelText: 'Password',
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
                    SizedBox(height: 20),
                    Text(
                      'Already have an account? Log in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
