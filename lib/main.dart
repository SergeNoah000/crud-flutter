import 'package:flutter/material.dart';
import './home_screen.dart';

void main() {
  runApp(  MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home:  HomeScreen(),

    );
  }
}
