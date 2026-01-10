import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/models/user.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/MainScreen.dart';
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
  late User user;

  @override
  void initState() {
    super.initState();
    loadPreferences();// Load shared preferences for email and password
  }

  @override
  Widget build(BuildContext context) {
    // UI design for login screen
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF8E1),
              Color(0xFFFFECB3),
              Color(0xFFFFD54F),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with shadow effect
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo_picture.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    
                    // Welcome text
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D4C41),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Login to continue to PawPal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF8D6E63),
                      ),
                    ),
                    SizedBox(height: 40),
                    
                    // Login form card
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Email field
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFFFFA726)),
                              labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFD54F)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFD54F), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFA726), width: 2),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFBF0),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Password field
                          TextField(
                            controller: passwordController,
                            obscureText: visible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock_outline, color: Color(0xFFFFA726)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visible = !visible;
                                  });
                                },
                                icon: Icon(
                                  visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                  color: Color(0xFF8D6E63),
                                ),
                              ),
                              labelStyle: TextStyle(color: Color(0xFF8D6E63)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFD54F)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFD54F), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Color(0xFFFFA726), width: 2),
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFFBF0),
                            ),
                          ),
                          SizedBox(height: 16),
                          
                          // Remember me and Forgot password row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      isChecked = value!;
                                      setState(() {});
                                      if (isChecked) {
                                        if (emailController.text.isNotEmpty &&
                                            passwordController.text.isNotEmpty) {
                                          prefUpdate(isChecked);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Preferences Stored"),
                                              backgroundColor: Colors.green,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("Please fill your email and password"),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
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
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text("Preferences Removed"),
                                            backgroundColor: Colors.red,
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                        emailController.clear();
                                        passwordController.clear();
                                        setState(() {});
                                      }
                                    },
                                    activeColor: Color(0xFFFFA726),
                                  ),
                                  Text(
                                    'Remember Me',
                                    style: TextStyle(
                                      color: Color(0xFF6D4C41),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // Forgot password functionality
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Color(0xFFFFA726),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFA726),
                                foregroundColor: Colors.white,
                                elevation: 8,
                                shadowColor: Color(0xFFFFA726).withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                loginuser();
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF6D4C41),
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => registerScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Register here',
                            style: TextStyle(
                              color: Color(0xFFFFA726),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Shared Preferences functions to save and load email, password and rememberMe status
  void prefUpdate(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
  // Load saved preferences
  void loadPreferences() {
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
  // User login function with input validation and server communication
  void loginuser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    // Input validation for email and password
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill in email and password"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // Password length validation
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password must be at least 6 characters long'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // Email format validation for personal email addresses only applicable to gmail and yahoo
    if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid personal email address (gmail or yahoo)'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // request to login user using database configuration
    http.post(
      Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/login_user.php'),
      body: {'email': email, 'password': password},
    ).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);
        log(jsonResponse.toString() + response.statusCode.toString() + "response".toString() + resarray.toString());
        if (resarray['status'] == 'success') {
          user = User.fromJson(resarray['data'][0]);
          if (!mounted) return;
          log("succeess".toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login successful"),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Mainscreen(user: user),
            ),
          );
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(resarray['message']),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        if (!mounted) return;
        log("failed".toString() + response.statusCode.toString() + "response".toString() + response.body.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login failed: ${response.statusCode}"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    });
  }
}