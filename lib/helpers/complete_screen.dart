import 'package:flutter/material.dart';
import 'package:naif/home.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isArabic
                  ? "🎉 جميع المستويات مكتملة! 🎉"
                  : "🎉 All Levels Complete! 🎉",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? "العودة إلى الصفحة الرئيسية" : "Back to Home",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
