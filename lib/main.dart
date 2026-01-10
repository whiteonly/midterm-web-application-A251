import 'package:flutter/material.dart';
import 'package:pawpal/views/splashpage.dart';
void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();// local state []
}

class _MyHomePageState extends State<MyHomePage> {//
  

  @override
  Widget build(BuildContext context) { 
    return SplashPage();
  }
}
