import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:playly/helpers/confetti_effects.dart';
import 'package:playly/helpers/emotion_game_levels.dart';
import 'package:playly/helpers/sound_handles.dart';
import 'package:playly/home.dart';

class EmotionGamePage extends StatefulWidget {
  const EmotionGamePage({super.key});

  @override
  State<EmotionGamePage> createState() => _EmotionGamePageState();
}

class _EmotionGamePageState extends State<EmotionGamePage> {
  final levels = emotionGameLevels;

  int currentLevel = 0;
  bool answeredCorrectly = false;
  String? selectedEmotion;
  late ConfettiController _confettiController;
  bool allComplete = false;

  final Map<String, String> arabicEmotions = {
    'Happy': 'سعيد',
    'Sad': 'حزين',
    'Angry': 'غاضب',
    'Surprised': 'مندهش',
    'Tired': 'متعب',
    'Scared': 'خائف',
    'Disgusted': 'مشمئز',
    'Confused': 'مرتبك',
    'Shy': 'خجول',
    'Proud': 'فخور',
  };

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

  void checkAnswer(String emotionKey) async {
    setState(() {
      selectedEmotion = emotionKey;
    });

    if (emotionKey == levels[currentLevel].correctEmotion) {
      setState(() {
        answeredCorrectly = true;
      });

      _confettiController.play();
      await playCrossPlatformSound('assets/soundeffects/correct.mp3');
    }
  }

  void nextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        answeredCorrectly = false;
        selectedEmotion = null;
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

  List<String> getOptionsForLevel(EmotionLevel level) {
    List<String> allEmotions = levels.map((e) => e.correctEmotion).toList();

    allEmotions.remove(level.correctEmotion);

    allEmotions.shuffle();
    List<String> selected = allEmotions.take(3).toList();

    selected.add(level.correctEmotion);
    selected.shuffle();

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    final level = levels[currentLevel];
    final options = getOptionsForLevel(level);

    if (allComplete) {
      return Scaffold(
        backgroundColor: Colors.lightBlue.shade50,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isArabic
                    ? '🎉 تم إكمال جميع المستويات! 🎉'
                    : '🎉 All Levels Complete! 🎉',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
                child: Text(
                  isArabic ? 'العودة إلى الصفحة الرئيسية' : 'Back to Home',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
          title: Center(
            child: Text(
              isArabic ? 'تحديد العاطفة' : 'Identify the Emotion',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'calibri',
              ),
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

            // Main content
            SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    // Emotion Image
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          level.imagePath,
                          width: MediaQuery.of(context).size.width < 500
                              ? 200
                              : 250,
                          height: MediaQuery.of(context).size.width < 500
                              ? 200
                              : 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      alignment: WrapAlignment.center,
                      children: options.map((emotionKey) {
                        final isCorrect = emotionKey == level.correctEmotion;
                        final isSelected = emotionKey == selectedEmotion;

                        Color color;
                        if (answeredCorrectly && isCorrect) {
                          color = Colors.green;
                        } else if (isSelected && !isCorrect) {
                          color = Colors.red;
                        } else {
                          color = const Color.fromARGB(255, 85, 85, 85);
                        }

                        final displayLabel = isArabic
                            ? arabicEmotions[emotionKey] ?? emotionKey
                            : emotionKey;

                        return ElevatedButton(
                          onPressed: () => checkAnswer(emotionKey),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            displayLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    if (answeredCorrectly)
                      ElevatedButton(
                        onPressed: nextLevel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          isArabic ? 'استمر ➜' : 'Continue ➜',
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
