import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyProfile extends StatefulWidget {
  final int? customerId;
  MyProfile({required this.customerId});

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  Map<String, dynamic>? profileData; // Stores the retrieved profile data
  bool isEditMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Make the HTTP GET request to fetch the profile data
      var response =
      await http.get(Uri.parse('http://localhost:3000/customer/${widget.customerId}'));

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var data = json.decode(response.body);

        setState(() {
          profileData = data;
          nameController.text = profileData!['full_name'];
          emailController.text = profileData!['email'];
          passwordController.text = profileData!['password'];
        });

      } else {
        // Handle error case when the request fails
        print('Failed to fetch profile data');
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Error: $error');
    }
  }

  Future<void> updateProfile() async {
    try {
      // Prepare the updated profile data
      var updatedProfile = {
        'full_name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };


      // Make the HTTP PUT request to update the profile data
      var response = await http.put(
        Uri.parse('http://localhost:3000/customer/${widget.customerId}'),
        body: json.encode(updatedProfile),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Profile updated successfully.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        setState(() {
          isEditMode = false;
          fetchData();
        });
      } else {
        // Handle error case when the request fails
        print('Failed to update profile data');
      }
    } catch (error) {
      // Handle any exceptions that occur during the request
      print('Error: $error');
    }
  }

  void cancelUpdate() {
    setState(() {
      isEditMode = false;
      nameController.text = profileData!['full_name'];
      emailController.text = profileData!['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        hintColor: Colors.white,
      ),
      home: Scaffold(
      appBar: AppBar(
      title: Text(
      'My Profile',
      style: TextStyle(color: Colors.white),
    ),
    leading: IconButton(
    icon: Icon(Icons.arrow_back),
    color: Colors.white,
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    actions: [
    isEditMode
    ? IconButton(
    icon: Icon(Icons.save),
    color: Colors.white,
    onPressed: () {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Your information will be updated. Do you want to proceed?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.of(context).pop();
              updateProfile();
            },
          ),
        ],
      );
    },
    );
    },
    )
        : IconButton(
      icon: Icon(Icons.edit),
      color: Colors.white,
      onPressed: () {
        setState(() {
          isEditMode = true;
        });
      },
    ),
    ],
      ),
          body: Center(
              child: profileData != null
                  ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  SizedBox(height: 24),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              isEditMode
                  ? TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(Icons.edit, color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              )
                  : Text(
                '${profileData!['full_name']}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                itemCount: profileData!.length,
                itemBuilder: (BuildContext context, int index) {
                  var key = profileData!.keys.elementAt(index);
                  var value = profileData![key];

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Icon(getIconForField(key), color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          '$key:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        isEditMode && (key == 'name' || key == 'email')
                            ? Expanded(
                          child: TextField(
                            controller: (key == 'name') ? nameController : emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter $key',
                              hintStyle: TextStyle(color: Colors.white),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                            : Expanded(
                          child: Text('$value', style: TextStyle(color: Colors.white)),

                        ),


                      ],
                    ),
                  );
                },
              ),
              if (isEditMode)
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ElevatedButton(
          onPressed: () {
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return AlertDialog(
    title: Text('Confirmation'),
    content: Text('Do you want to reset the changes?'),
    actions: [
    TextButton(
    child: Text('Cancel'),
    onPressed: () {
    Navigator.of(context).pop();
    },
    ),
    TextButton(
    child: Text('Reset'),
    onPressed: () {
    Navigator.of(context).pop();
    cancelUpdate();
    },
    ),
    ],
    );
    },
    );
    },
      child: Text('Reset'),
    ),
    SizedBox(width: 16),
    ElevatedButton(
    onPressed: () {
    showDialog(
    context: context,
    builder: (
        context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Your information will be updated. Do you want to proceed?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.of(context).pop();
              updateProfile();
            },
          ),
        ],
      );
    },
    );
    },
      child: Text('Save'),
    ),
          ],
          ),
                  ],
              )
                  : CircularProgressIndicator(),
          ),
      ),
    );
  }

  IconData getIconForField(String field) {
    // Add appropriate icons for different fields as needed
    switch (field) {
      case 'name':
        return isEditMode ? Icons.edit : Icons.person;
      case 'email':
        return isEditMode ? Icons.edit : Icons.email;
      case 'created_at':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }
}
