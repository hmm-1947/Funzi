import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/confetti_effects.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/helpers/visual_cat_levels.dart';
import 'package:naif/home.dart';

class VisualCat extends StatefulWidget {
  const VisualCat({super.key});

  @override
  State<VisualCat> createState() => _VisualCatState();
}

class _VisualCatState extends State<VisualCat> {
  final levels = visualCatLevels;

  int currentLevel = 0;
  bool answeredCorrectly = false;
  bool allComplete = false;
  String? wrongImage;

  late ConfettiController _confettiController;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _generateOptions();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateOptions() {
    final level = levels[currentLevel];
    List<String> temp = [
      level.correctImage,
      level.distractors[0],
      level.distractors[1],
    ];
    temp.shuffle();
    options = temp;
  }

  Future<void> checkAnswer(String imgPath) async {
    if (answeredCorrectly) return;

    if (imgPath == levels[currentLevel].correctImage) {
      setState(() {
        answeredCorrectly = true;
        wrongImage = null; // clear previous wrong answer
      });
      _confettiController.play();
      playCrossPlatformSound("assets/soundeffects/correct.mp3");
    } else {
      setState(() {
        wrongImage = imgPath; // highlight this wrong one
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? "حاول مرة أخرى" : "Try Again"),
          duration: Duration(seconds: 1),
        ),
      );

      playCrossPlatformSound("assets/soundeffects/wrong.mp3");
    }
  }

  void nextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        answeredCorrectly = false;
        _generateOptions();
      });
    } else {
      setState(() => allComplete = true);
      playCrossPlatformSound("assets/soundeffects/won.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allComplete) return CompleteScreen();

    final level = levels[currentLevel];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            isArabic ? "اختر الصورة الصحيحة" : "Choose the Correct Image",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'calibri',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        ),

        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: CommonConfetti(controller: _confettiController),
            ),

            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),

                    // ⭐ QUESTION TEXT
                    Text(
                      isArabic ? level.questionAr : level.questionEn,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        shadows: [
                          Shadow(
                            offset: Offset(-2, -2),
                            color: Colors.white,
                            blurRadius: 1,
                          ),
                          Shadow(
                            offset: Offset(2, -2),
                            color: Colors.white,
                            blurRadius: 1,
                          ),
                          Shadow(
                            offset: Offset(2, 2),
                            color: Colors.white,
                            blurRadius: 1,
                          ),
                          Shadow(
                            offset: Offset(-2, 2),
                            color: Colors.white,
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ⭐ CENTER ICON
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.black54, width: 4),
                      ),
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(level.iconPath, fit: BoxFit.cover),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ⭐ OPTIONS (CENTERED)
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: options.map((img) {
                        return GestureDetector(
                          onTap: () => checkAnswer(img),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color:
                                    answeredCorrectly &&
                                        img == level.correctImage
                                    ? Colors.green
                                    : (wrongImage == img
                                          ? Colors.red
                                          : Colors.transparent),
                                width: 4,
                              ),

                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                img,
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 100),

                    // ⭐ CONTINUE BUTTON
                    if (answeredCorrectly)
                      ElevatedButton(
                        onPressed: nextLevel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          isArabic ? "استمر ➜" : "Continue ➜",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
