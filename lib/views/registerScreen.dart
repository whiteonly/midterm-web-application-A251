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
    //width = 1536
    if (width > 400) {
      width = 400;
    } else {
      width = width;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Register Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(255, 234, 216, 129),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Image.asset('assets/images/registration.jpg', fit: BoxFit.cover,height: 400), //insert image
              SizedBox(width: 40),
              Column(
                children: [
                  Padding(
                padding: const EdgeInsets.all(4.0),
              ),
              
              SizedBox(height: 20),
              SizedBox(//email TextField
                width: width * 0.8,
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(//name TextField
                width: width * 0.8,
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(//phone TextField
                width: width * 0.8,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(//password TextField
                width: width * 0.8,
                child: TextField(
                  controller: passwordController,
                  obscureText: visible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(//to show/hide password
                      onPressed: () {
                        setState(() {
                          visible = !visible;
                        });
                      },
                      icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(//confirm password TextField
                width: width * 0.8,
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: visible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(//to show/hide password at the same time with password field 
                      onPressed: () {
                        setState(() {
                          visible = !visible;//same variable as password field if change can change both fields security
                        });
                      },
                      icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(//register button
                    onPressed: () {
                      developer.log('Register button pressed');
                      // Call the registerNotification function
                      registerNotification();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(//cancel button
                    onPressed: () {
                      // Handle cancellation logic here
                      print('Cancel button pressed');
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Welcomescreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextButton(//login redirect button when clicked to login account page
                onPressed: () {
                  // Navigate to a login page; LoginPage is defined below as a simple placeholder.
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const loginScreen(),
                    ),
                  );
                },
                child: const Text('Already have an account? Login here'),
              ),
                ]
              ), 
              SizedBox(width: 40),
              Image.asset('assets/images/registration2.jpg', fit: BoxFit.cover,height: 400),//insert image
            ],
          ),
        ),
      ),
    );
  }

  void registerNotification() {
    // Validate input fields and to avoid the registration from penetration
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim(); 
    String confirmPassword = confirmPasswordController.text.trim();
    // Check for empty fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || phone.isEmpty) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please fill in all fields'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // Password length validation atleast 6 characters
    if (password.length < 6) {
      SnackBar snackBar = const SnackBar(
        content: Text('Password must be at least 6 characters long'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // Phone number validation more than 7 - 10 digits and only numbers are allowed
    if(!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid phone number'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // Check if passwords match
    if (password != confirmPassword) {
      SnackBar snackBar = const SnackBar(
        content: Text('Passwords do not match'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    // Email format validation for gmail and yahoo only
    if (!RegExp(r'^[\w-\.]+@(gmail|yahoo)(\.[A-Za-z]{2,3})+$').hasMatch(email)) {
      //(\.[A-Za-z]{2,3}) - it accept three character after dot like .com / .com.my 
      SnackBar snackBar = const SnackBar(
        content: Text('Please enter a valid personal email address (gmail or yahoo)'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    showDialog(//confirmation dialog before registering the account to the database
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register this account?'),
        actions: [
          TextButton(
              onPressed: () {
              Navigator.pop(context);
              log('Before registering user with email: $email');
              registerUser(email, password, name, phone);//call register user function to register the account
            },
            child: Text('Register'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ], 
    )
    );
  }
  
  //function to register user account to database
  void registerUser(String email, String password, String name, String phone) async {
    setState(() {
      isLoading = true;// show loading indicator
    });
    showDialog(context: context,
     builder: (context) {
       return AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
         children :[
            CircularProgressIndicator(),// loading indicator
            SizedBox(width: 20),
            SizedBox(//loading text
              width: 200, 
              child: Text(
                'Registering user...', 
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none
                  )
                  )
            ),
         ] 
        ),
       );
     },
     barrierDismissible: false,// prevent closing the dialog by tapping outside
     );
      await http//register user to database
        .post(
          Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/register_user.php'),
          body: {//user details
          'email': email,
          'password': password, 
          'name': name, 
          'phone': phone}
          )
          .then((response) {//successful connection to server
            log("succeess".toString());
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
                  Navigator.pop(context); // Close the loading dialog
                  setState(() {
                    isLoading = false;// stop loading indicator
                  });
                }
              Navigator.pop(context); // Close the registration dialog
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => loginScreen ()),// redirect to login screen after successful registration
              );
                } else {// registration failed
                  if (!mounted) return;
                  SnackBar snackBar = SnackBar(content: Text(resarray['message']));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
            } else {// failed to connect to server
                if (!mounted) return;
                SnackBar snackBar = const SnackBar(
                  content: Text('Registration failed. Please try again.'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            })
            .timeout(
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
            Navigator.pop(context); // Close the loading dialog
            setState(() {
              isLoading = false;
            });
          }
            }
            
  }//registerUser
