import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal/myconfiguration.dart';
import 'package:pawpal/views/MainScreen.dart';
import 'package:pawpal/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    autologin();
  }

  void autologin() {//check if user had choose to rememberme
    SharedPreferences.getInstance().then((prefs) {
      bool? rememberMe = prefs.getBool('rememberMe');
      if (rememberMe != null && rememberMe) {//user had choose to rememberme
        email = prefs.getString('email') ?? 'NA';
        password = prefs.getString('password') ?? 'NA';
        http
            .post(
              Uri.parse('${myconfiguration.baseUrl}/pawpal/pawpal/api/login_user.php'),
              body: {'email': email, 'password': password},
            )
            .then((response) {
              if (response.statusCode == 200) {
                var jsonResponse = response.body;
                var resarray = jsonDecode(jsonResponse);
                if (resarray['status'] == 'success') {
                  User user = User.fromJson(resarray['data'][0]);
                  if (!mounted) return;
                  Future.delayed(Duration(seconds: 2), () {
                    if (!mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mainscreen(user: user),
                      ),
                    );
                  });
                } else {//login as guest
                  Future.delayed(Duration(seconds: 3), () {
                    if (!mounted) return;
                    User user = User(
                      userId : '0',
                      userEmail : 'guest@email.com',
                      userName : 'Guest',
                      userPassword : 'guest',
                      userPhone : '0000000000',
                      userRegdate : '0000-00-00',
                      userCredit : 0,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mainscreen(user: user),
                      ),
                    );
                  });
                }
              } else {//login as guest
                Future.delayed(Duration(seconds: 3), () {
                  if (!mounted) return;
                  User user = User(
                    userId : '0',
                    userEmail : 'guest@email.com',
                    userName : 'Guest',
                    userPassword : 'guest',
                    userPhone : '0000000000',
                    userRegdate : '0000-00-00',
                    userCredit : 0,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Mainscreen(user: user),
                    ),
                  );
                });
              }
            });
      } else {
        Future.delayed(Duration(seconds: 3), () {
          if (!mounted) return;
          User user = User(
            userId : '0',
            userEmail : 'guest@email.com',
            userName : 'Guest',
            userPassword : 'guest',
            userPhone : '0000000000',
            userRegdate : '0000-00-00',
            userCredit : 0,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Mainscreen(user: user)),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 217, 115, 6), Color.fromARGB(255, 191, 204, 14)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // APP ICON
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.pets_outlined,
                size: 60,
                color: Color.fromARGB(255, 176, 149, 13),
              ),
            ),
            const SizedBox(height: 24),
            // APP NAME
            const Text(
              "Pawpal",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            // TAGLINE
            const Text(
              "everything can be settle",
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            // LOADING INDICATOR
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
}
