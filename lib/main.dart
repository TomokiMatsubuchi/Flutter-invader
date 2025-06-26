import 'package:flutter/material.dart';
import 'screens/title_screen.dart';

void main() {
  runApp(const SpaceInvaderApp());
}

class SpaceInvaderApp extends StatelessWidget {
  const SpaceInvaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Invader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TitleScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}