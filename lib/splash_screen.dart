import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naif/home.dart'; // <-- change if your home file is different

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()), // your home widget
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // change if needed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ⭐ App icon
            Image.asset(
              "assets/icon.png", // <-- change to your app icon path
              width: 150,
              height: 150,
            ),

            const SizedBox(height: 30),

            // ⭐ Welcome text
            const Text(
              "Welcome to the Game!\nمرحبا بكم في اللعبة!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
