import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/confetti_effects.dart';
import 'package:naif/helpers/odd_one_levels.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/home.dart';

class OddOne extends StatefulWidget {
  const OddOne({super.key});

  @override
  State<OddOne> createState() => _OddOneState();
}

class _OddOneState extends State<OddOne> {
  final levels = oddOneOutLevels;

  int currentLevel = 0;
  bool answeredCorrectly = false;
  bool allComplete = false;

  int? wrongIndex; // ⭐ ADDED

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
    List<String> temp = [level.correctImage, level.others[0], level.others[1]];
    temp.shuffle();
    options = temp;
  }

  Future<void> checkAnswer(int index) async {
    if (answeredCorrectly) return;

    final level = levels[currentLevel];
    final correctIndex = options.indexOf(level.correctImage);

    if (index == correctIndex) {
      setState(() {
        answeredCorrectly = true;
        wrongIndex = null; // clear wrong highlight
      });

      _confettiController.play();
      playCrossPlatformSound("assets/soundeffects/correct.mp3");
    } else {
      setState(() {
        wrongIndex = index; // ⭐ MARK WRONG ANSWER
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic ? "حاول مرة أخرى" : "Try Again"),
          duration: const Duration(seconds: 2),
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
        wrongIndex = null; // reset wrong border
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
            isArabic ? "ابحث عن المختلف" : "Find the odd one out",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'calibri',
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
                    const SizedBox(height: 80),

                    // ⭐ CENTERED IMAGE GRID
                    Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: List.generate(options.length, (index) {
                          final img = options[index];
                          final correctIndex = options.indexOf(
                            level.correctImage,
                          );

                          final isCorrect =
                              answeredCorrectly && index == correctIndex;

                          final isWrong = wrongIndex == index;

                          return GestureDetector(
                            onTap: () => checkAnswer(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: isCorrect
                                      ? Colors.green
                                      : (isWrong
                                            ? Colors.red
                                            : Colors.transparent),
                                  width: 4,
                                ),
                                borderRadius: BorderRadius.circular(15),
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
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 300),

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
