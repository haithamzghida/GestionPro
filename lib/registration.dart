import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}
class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _email;
  late String _password;
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Send the registration request to the server
      final response = await http.post(Uri.parse('http://localhost:3000/customers'),
          body: {'full_name': _fullName, 'email': _email, 'password': _password});
      // Check the response status code and update the UI accordingly
      if (response.statusCode == 200) {
        // Registration successful
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // TODO: Navigate to the login screen
      } else if (response.statusCode == 400) {
        // Invalid email, password or full name
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
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add,
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
                            labelText: 'Full Name',
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
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _fullName = value;
                          },
                        ),
                        SizedBox(height: 20),
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
                          obscureText: true,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _password = value;
                          },
                        ),
                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Text(
                              'Register',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
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
    );
  }
}