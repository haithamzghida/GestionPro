import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.post(Uri.parse('http://localhost:3000/login'),
          body: {'email': _email, 'password': _password});
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
            builder: (BuildContext context) => MyHomePage(customerId: data['customer_id']),
          ),
        );
      }
      else if (response.statusCode == 400) {
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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                size: 150,
                color: Colors.black,
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
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
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap: _submitForm,
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black,
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
    );
  }
}