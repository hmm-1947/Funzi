import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/confetti_effects.dart';
import 'package:naif/helpers/emotion_game_levels.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/home.dart';

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
  bool showRedFlash = false;
  final Set<String> flashingButtons = {};

  List<String> options = []; // 👈 store once per level

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

  final Map<String, String> emojiMap = {
    'Happy': '😊',
    'Sad': '😢',
    'Angry': '😡',
    'Surprised': '😲',
    'Tired': '😴',
    'Scared': '😱',
    'Disgusted': '🤢',
    'Confused': '😕',
    'Shy': '😳',
    'Proud': '😌',
  };

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _generateOptionsForCurrentLevel();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _generateOptionsForCurrentLevel() {
    final level = levels[currentLevel];
    List<String> allEmotions = levels.map((e) => e.correctEmotion).toList();

    allEmotions.remove(level.correctEmotion);
    allEmotions.shuffle();
    List<String> selected = allEmotions.take(3).toList();
    selected.add(level.correctEmotion);
    selected.shuffle();

    setState(() {
      options = selected;
    });
  }

  Future<void> checkAnswer(String emotionKey) async {
    if (answeredCorrectly) return;

    setState(() => selectedEmotion = emotionKey);

    if (emotionKey == levels[currentLevel].correctEmotion) {
      setState(() => answeredCorrectly = true);
      _confettiController.play();
      await playCrossPlatformSound('assets/soundeffects/correct.mp3');
    } else {
      setState(() => flashingButtons.add(emotionKey));
      await playCrossPlatformSound('assets/soundeffects/wrong.mp3');

      // Remove flash after short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => flashingButtons.remove(emotionKey));
        }
      });
    }
  }

  void nextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        answeredCorrectly = false;
        selectedEmotion = null;
        _generateOptionsForCurrentLevel(); // 👈 new options for next level
      });
    } else {
      setState(() => allComplete = true);
      playCrossPlatformSound('assets/soundeffects/won.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (allComplete) {
      return CompleteScreen();
    }

    final level = levels[currentLevel];

    return Stack(
      children: [
        Container(
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
                isArabic ? 'تحديد العاطفة' : 'Identify the Emotion',
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

                // 🔴 red flash overlay
                if (showRedFlash)
                  AnimatedOpacity(
                    opacity: 0.7,
                    duration: const Duration(milliseconds: 100),
                    child: Container(color: Colors.red.withOpacity(0.6)),
                  ),

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
                            final isCorrect =
                                emotionKey == level.correctEmotion;

                            Color color;
                            if (answeredCorrectly && isCorrect) {
                              color = Colors.green;
                            } else if (flashingButtons.contains(emotionKey)) {
                              // temporarily flashing red
                              color = Colors.red;
                            } else {
                              color = const Color.fromARGB(255, 85, 85, 85);
                            }

                            final displayLabel = isArabic
                                ? arabicEmotions[emotionKey] ?? emotionKey
                                : emotionKey;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: ElevatedButton(
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
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      emojiMap[emotionKey] ?? "🙂",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      displayLabel,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 100),

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
        ),
      ],
    );
  }
}
