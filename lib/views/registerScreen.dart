import 'dart:developer';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/loginScreen.dart';
import 'package:pawpal/views/welcomeScreen.dart';
import 'package:http/http.dart' as http;

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  late double height, width;
  bool visible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    developer.log('Width: $width', name: 'registerScreen');
    
    double formWidth = width > 400 ? 400 : width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F0),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_add, size: 28, color: Colors.white),
            SizedBox(width: 12),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFA18B1D),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Image
                if (width > 900)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/registration.jpg',
                        fit: BoxFit.cover,
                        height: 450,
                      ),
                    ),
                  ),
                
                if (width > 900) SizedBox(width: 50),
                
                // Form Container
                Container(
                  width: formWidth * 0.9,
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Welcome Text
                      Text(
                        'Join PawPal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFA18B1D),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Create your account to get started',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 32),

                      // Email Field
                      _buildTextField(
                        controller: emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 16),

                      // Name Field
                      _buildTextField(
                        controller: nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 16),

                      // Phone Field
                      _buildTextField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),

                      // Password Field
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline,
                        obscureText: visible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          icon: Icon(
                            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Color(0xFFA18B1D),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Confirm Password Field
                      _buildTextField(
                        controller: confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock_outline,
                        obscureText: visible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          icon: Icon(
                            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Color(0xFFA18B1D),
                          ),
                        ),
                      ),
                      SizedBox(height: 28),

                      // Register Button
                      ElevatedButton(
                        onPressed: () {
                          developer.log('Register button pressed');
                          registerNotification();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFA18B1D),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 12),

                      // Cancel Button
                      OutlinedButton(
                        onPressed: () {
                          print('Cancel button pressed');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Welcomescreen(),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFFA18B1D),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Color(0xFFA18B1D), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const loginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Login here',
                              style: TextStyle(
                                color: Color(0xFFA18B1D),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                if (width > 900) SizedBox(width: 50),
                
                // Right Image
                if (width > 900)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/registration2.jpg',
                        fit: BoxFit.cover,
                        height: 450,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Color(0xFFA18B1D)),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFA18B1D), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  void registerNotification() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password.length < 6) {
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid personal email address (gmail or yahoo)'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Color(0xFFA18B1D), size: 28),
            SizedBox(width: 12),
            Text('Confirm Registration'),
          ],
        ),
        content: Text('Are you sure you want to register this account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              log('Before registering user with email: $email');
              registerUser(email, password, name, phone);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA18B1D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

  void registerUser(String email, String password, String name, String phone) async {
    setState(() {
      isLoading = true;
    });
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFFA18B1D)),
              SizedBox(height: 20),
              Text(
                'Creating your account...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
      barrierDismissible: false,
    );

    await http
        .post(
          Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/register_user.php'),
          body: {
            'email': email,
            'password': password,
            'name': name,
            'phone': phone
          },
        )
        .then((response) {
      log("success".toString());
      if (response.statusCode == 200) {
        var jsonResponse = response.body;
        var resarray = jsonDecode(jsonResponse);
        log(jsonResponse);
        if (resarray['status'] == 'success') {
          if (!mounted) return;
          SnackBar snackBar = const SnackBar(
            content: Text('Registration successful'),
          );
          if (isLoading) {
            if (!mounted) return;
            Navigator.pop(context);
            setState(() {
              isLoading = false;
            });
          }
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => loginScreen()),
          );
        } else {
          if (!mounted) return;
          SnackBar snackBar = SnackBar(content: Text(resarray['message']));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        if (!mounted) return;
        SnackBar snackBar = const SnackBar(
          content: Text('Registration failed. Please try again.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        if (!mounted) return;
        SnackBar snackBar = const SnackBar(
          content: Text('Request timed out. Please try again.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );

    if (isLoading) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        isLoading = false;
      });
    }
  }
}