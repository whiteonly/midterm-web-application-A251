import 'package:flutter/material.dart';
import 'package:pawpal/views/loginScreen.dart';
import 'package:pawpal/views/registerScreen.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    backgroundColor: const Color.fromARGB(255, 234, 216, 129),
    ),
    body: Column(
    children: [
      Padding(//for Description Text
        padding: const EdgeInsets.only(top: 20),
        child: Text(
          'Connect with Malaysia\'s \nAnimal Lovers',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 19, 14, 14),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 20),
      Expanded(//insert image
        child: Center(
          child: Image.asset(
            'assets/images/petAdoption.jpg',
            fit: BoxFit.cover,
            height: 550,
          ),
        ),
      ),
      SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(//login button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const loginScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(// register button
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => registerScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 191, 165, 35),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      SizedBox(height: 20),
      
    ],
    ),
          bottomNavigationBar: BottomAppBar(//bottom description bar
          color: const Color.fromARGB(255, 234, 216, 129),
          child: Center(
              child: Text(
                'Welcome to the Pawpal Community!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
  );
  }
}
