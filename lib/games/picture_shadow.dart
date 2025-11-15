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
      if (currentLevel < levels.length) {
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
      return const CompleteScreen();
    }

    final items = List<Map<String, String>>.from(
      levels[(currentLevel - 1) % levels.length],
    );

    final images = List<Map<String, String>>.from(items)..shuffle();
    final shadows = List<Map<String, String>>.from(items)..shuffle();

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: GameAppBar(),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GameBoard(
              images: images,
              shadows: shadows,
              matched: _matched,
              onCorrect: (imagePath) async {
                setState(() => _matched[imagePath] = true);
                await playCrossPlatformSound('assets/soundeffects/pluck.mp3');
                _checkLevelComplete();
              },
              onWrong: () async {
                await playCrossPlatformSound('assets/soundeffects/wrong.mp3');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isArabicNotifier.value ? 'حاول مرة أخرى!' : 'Try again!',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),

            CommonConfetti(controller: _confettiController),
            if (levelCompleted) ContinueButton(onPressed: _nextLevel),
          ],
        ),
      ),
    );
  }
}

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  const BackgroundContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 52, 52, 52),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        isArabicNotifier.value
            ? 'مطابقة الصورة والظل'
            : 'Picture & Shadow Matching',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'calibri',
        ),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  final List<Map<String, String>> images;
  final List<Map<String, String>> shadows;

  final Map<String, bool> matched;
  final Function(String imagePath) onCorrect;
  final VoidCallback onWrong;

  const GameBoard({
    super.key,
    required this.images,
    required this.shadows,
    required this.matched,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // IMAGES
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.map((item) {
              final imagePath = item['image']!;
              return DraggableImage(
                imagePath: imagePath,
                matched: matched[imagePath] == true,
              );
            }).toList(),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: shadows.map((item) {
              final imagePath = item['image']!;
              final shadowPath = item['shadow']!;
              return ShadowTarget(
                imagePath: imagePath,
                shadowPath: shadowPath,
                matched: matched[imagePath] == true,
                onCorrect: onCorrect,
                onWrong: onWrong,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DraggableImage extends StatelessWidget {
  final String imagePath;
  final bool matched;

  const DraggableImage({required this.imagePath, required this.matched});

  @override
  Widget build(BuildContext context) {
    if (matched) {
      return const SizedBox(width: 100, height: 100);
    }

    return Draggable<String>(
      data: imagePath,
      feedback: Image.asset(imagePath, width: 100),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: Image.asset(imagePath, width: 100),
      ),
      child: Image.asset(imagePath, width: 100),
    );
  }
}

class ShadowTarget extends StatelessWidget {
  final String imagePath;
  final String shadowPath;
  final bool matched;

  final Function(String imagePath) onCorrect;
  final VoidCallback onWrong;

  const ShadowTarget({
    required this.imagePath,
    required this.shadowPath,
    required this.matched,
    required this.onCorrect,
    required this.onWrong,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: (data) {
        if (data == imagePath) {
          onCorrect(imagePath);
        } else {
          onWrong();
        }
      },
      builder: (context, candidate, rejected) {
        return Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: matched ? Colors.green.shade100 : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: matched
              ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
              : Image.asset(shadowPath, width: 100),
        );
      },
    );
  }
}

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ContinueButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        child: Text(
          isArabicNotifier.value ? 'استمر ➜' : 'Continue ➜',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
