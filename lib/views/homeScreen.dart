import 'package:flutter/material.dart';
import 'package:pawpal/models/user.dart';
import 'package:pawpal/views/MainScreen.dart';
import 'package:pawpal/views/SubmitPetScreen%20.dart';

class Homescreen extends StatefulWidget {
  final User? user;

  const Homescreen({super.key,required this.user});

  @override
  State<Homescreen> createState() => _HomescreenState();
}
        // Display user's name after login successful
class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child :Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(// submit a submission
              onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SubmitPet(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 191, 165, 35),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('add  submission',
              style: TextStyle(fontSize: 18, color: Colors.white),),  
            ),
            SizedBox(height: 20,),
            ElevatedButton(// view submission
              onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  Mainscreen(user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 191, 165, 35),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('view all submissions',
              style: TextStyle(fontSize: 18, color: Colors.white),),  
            ),
        ],)
      ),
    );
  }
}