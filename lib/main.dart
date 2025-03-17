import 'package:costtracker/pages/onboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 119, 82, 223),
        disabledColor: Colors.grey[600],
        hintColor: const Color.fromARGB(255, 42, 15, 117),
      ),
      home: OnboardingScreen(),
    );
  }
}
