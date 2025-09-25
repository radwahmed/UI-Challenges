import 'package:flutter/material.dart';

import 'challenges/challenge_one.dart';
import 'challenges/challenge_two.dart';
import 'challenges/challenge_three.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Cards with Checkbox",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const LoadingDots(),
    );
  }
}
