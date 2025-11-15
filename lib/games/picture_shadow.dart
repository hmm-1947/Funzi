import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/picture_shadow_levels.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/home.dart';
import 'package:naif/helpers/confetti_effects.dart';

class PictureShadowGame extends StatefulWidget {
  const PictureShadowGame({super.key});

  @override
  State<PictureShadowGame> createState() => _PictureShadowGameState();
}

class _PictureShadowGameState extends State<PictureShadowGame> {
  int currentLevel = 1;
  final Map<String, bool> _matched = {};

  final levels = pictureShadowLevels;

  bool levelCompleted = false;
  bool allcomplete = false;
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

  void _checkLevelComplete() {
    final total = levels[currentLevel - 1].length;
    final matchedCount = _matched.values.where((v) => v == true).length;
    if (matchedCount == total && !levelCompleted) {
      _onLevelComplete();
    }
  }

  Future<void> _onLevelComplete() async {
    setState(() => levelCompleted = true);
    _confettiController.play();

    await playCrossPlatformSound('assets/soundeffects/correct.mp3');
  }

  void _nextLevel() async {
    setState(() {
      if (currentLevel < 10) {
        currentLevel++;
        _matched.clear();
        levelCompleted = false;
      } else {
        allcomplete = true;
      }
    });

    if (allcomplete) {
      await playCrossPlatformSound('assets/soundeffects/won.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allcomplete) {
      return CompleteScreen();
    }
    final items = List<Map<String, String>>.from(
      levels[(currentLevel - 1) % levels.length],
    );

    final images = List<Map<String, String>>.from(items)..shuffle();
    final shadows = List<Map<String, String>>.from(items)..shuffle();

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
            isArabic ? 'مطابقة الصورة والظل' : 'Picture & Shadow Matching',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,

              fontFamily: 'calibri',
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.map((item) {
                      final imagePath = item['image']!;
                      return Draggable<String>(
                        data: imagePath,
                        feedback: Image.asset(imagePath, width: 100),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: Image.asset(imagePath, width: 100),
                        ),
                        child: _matched[imagePath] == true
                            ? const SizedBox(width: 100, height: 100)
                            : Image.asset(imagePath, width: 100),
                      );
                    }).toList(),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: shadows.map((item) {
                      final imagePath = item['image']!;
                      final shadowPath = item['shadow']!;
                      final matched = _matched[imagePath] == true;

                      return DragTarget<String>(
                        onAccept: (data) async {
                          if (data == imagePath) {
                            setState(() => _matched[imagePath] = true);
                            await playCrossPlatformSound(
                              'assets/soundeffects/pluck.mp3',
                            );

                            _checkLevelComplete();
                          } else {
                            await playCrossPlatformSound(
                              'assets/soundeffects/wrong.mp3',
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic ? 'حاول مرة أخرى!' : 'Try again!',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: matched
                                  ? Colors.green.shade100
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: matched
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 40,
                                  )
                                : Image.asset(shadowPath, width: 100),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            CommonConfetti(controller: _confettiController),

            const SizedBox(height: 40),
            if (levelCompleted)
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: ElevatedButton(
                  onPressed: _nextLevel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    isArabic ? 'استمر ➜' : 'Continue ➜',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
