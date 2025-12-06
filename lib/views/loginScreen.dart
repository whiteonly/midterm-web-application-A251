import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/homeScreen.dart';
import 'package:pawpal/views/registerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool visible = true;
  bool isChecked = false;
 //1042.4000244140625 - width of the screen

  late User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page'), backgroundColor: const Color.fromARGB(255, 234, 216, 129)),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Padding(//insert image
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/images/logo_picture.png', scale: 4.5, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 5),
                  TextField(// email text field
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextField(// password text field
                    controller: passwordController,
                    obscureText: visible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (visible) {
                            visible = false;
                          } else {
                            visible = true;
                          }
                          setState(() {});
                        },
                        icon: Icon(Icons.visibility),
                      ),
                      border: OutlineInputBorder(),// to create border around text field
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(// remember me checkbox
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Row(
                      children: [
                        Text('Remember Me'),
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            isChecked = value!;
                            setState(() {});
                            if (isChecked) {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                prefUpdate(isChecked);// save the preferences using shared preferences
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Preferences Stored"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Please fill your email and password",
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                isChecked = false;
                                setState(() {});
                              }
                            } else {
                              prefUpdate(isChecked);
                              if (emailController.text.isEmpty &&
                                  passwordController.text.isEmpty) {
                                return;
                                // do nothing
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Preferences Removed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              emailController.clear();
                              passwordController.clear();
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 191, 165, 35),
                      ),
                      onPressed: () {
                        loginuser();
                      },
                      child: Text('Login'),
                    ),
                  ),
                  SizedBox(height: 5),
                  GestureDetector(// if clicked, go to register screen for registration
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => registerScreen(),
                        ),
                      );
                    },
                    child: Text('Dont have an account? Register here.'),
                  ),
                  SizedBox(height: 5),
                  Text('Forgot Password?')// no functionality yet,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
   void prefUpdate(bool isChecked) async {// to update shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();// to get instance of shared preferences
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  void loadPreferences() {// to load shared preferences when the screen is initialized
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        emailController.text = email ?? '';
        passwordController.text = password ?? '';
        isChecked = true;
        setState(() {});
      }
    });
  }

  void loginuser() {
    // validate inputs and to secure sql injection
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {// check if email and password are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password.length < 6) {// check if password is less than 6 characters
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // validate email format for gmail and yahoo only
    if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      //(\.[A-Za-z]{2,3}) - it accept three character after dot like .com / .com.my 
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid personal email address (gmail or yahoo)'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // proceed to login
    http
        .post(
          Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/login_user.php'),
          body: {'email': email, 'password': password},
        )
        .then((response) {  //response succeed
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            log(jsonResponse.toString() + response.statusCode.toString()+ "response".toString() + resarray.toString());
            if (resarray['status'] == 'success') {
              user = User.fromJson(resarray['data'][0]);
              if (!mounted) return;
              log("succeess".toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
              // Navigate to home page or dashboard
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homescreen(user: user),
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
            // Handle successful login here
          } else {
            if (!mounted) return;
            log( "failed".toString() + response.statusCode.toString() + "response".toString()+ response.body.toString());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Login failed: ${response.statusCode}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
  }
}