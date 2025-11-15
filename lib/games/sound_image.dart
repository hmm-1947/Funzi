import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/confetti_effects.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/helpers/sound_image_levels.dart';
import 'package:naif/home.dart';

final soundLevels = soundImageLevels;

class SoundImageGame extends StatefulWidget {
  const SoundImageGame({super.key});

  @override
  State<SoundImageGame> createState() => _SoundImageGameState();
}

class _SoundImageGameState extends State<SoundImageGame> {
  int currentLevel = 0;
  bool answeredCorrectly = false;
  bool allComplete = false;
  int? wrongIndex;

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void playSound() {
    playCrossPlatformSound(soundLevels[currentLevel].soundPath);
  }

  Future<void> checkAnswer(int index) async {
    if (answeredCorrectly) return;

    if (index == soundLevels[currentLevel].correctIndex) {
      setState(() {
        answeredCorrectly = true;
        wrongIndex = null; // clear any previous wrong
      });
      _confettiController.play();
      await playCrossPlatformSound('assets/soundeffects/correct.mp3');
    } else {
      setState(() {
        wrongIndex = index; // same style as correct logic
      });
      await playCrossPlatformSound('assets/soundeffects/wrong.mp3');
    }
  }

  void nextLevel() {
    if (currentLevel < soundLevels.length - 1) {
      setState(() {
        currentLevel++;
        answeredCorrectly = false;
      });
    } else {
      setState(() {
        allComplete = true;
      });
    }
    if (allComplete) {
      playCrossPlatformSound('assets/soundeffects/won.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allComplete) {
      return CompleteScreen();
    }

    final level = soundLevels[currentLevel];

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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            isArabic ? 'مطابقة الصورة والصوت' : 'Picture & Sound Matching',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: ElevatedButton(
                      onPressed: playSound,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          115,
                          255,
                          103,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(
                        Icons.volume_up,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: List.generate(level.imagePaths.length, (index) {
                        return GestureDetector(
                          onTap: () => checkAnswer(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    answeredCorrectly &&
                                        index == level.correctIndex
                                    ? Colors.green
                                    : (wrongIndex == index
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
                            child: Image.asset(
                              level.imagePaths[index],
                              width: 120,
                              height: 120,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 100),
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
                        isArabic ? 'استمر ➜' : 'Continue ➜',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
