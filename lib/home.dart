import 'package:flutter/material.dart';
import 'package:funzi/games/coloring_page.dart';
import 'package:funzi/games/emotion_game.dart';
import 'package:funzi/games/picture_shadow.dart';
import 'package:funzi/games/sound_image.dart';
import 'dart:io' show Platform;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

bool isArabic = false;

class _HomeState extends State<Home> {
  final bool isDesktop =
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/cover.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              children: [
                const Text(
                  'EN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                    fontFamily: 'calibri',
                  ),
                ),
                Switch(
                  value: isArabic,
                  onChanged: (value) {
                    setState(() {
                      isArabic = value;
                    });
                  },
                ),
                const Text(
                  'AR',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                    fontFamily: 'calibri',
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
          title: Text(
            isArabic ? 'اختر لعبة' : 'Choose a Game',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'calibri',
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isDesktop =
                  Platform.isWindows || Platform.isLinux || Platform.isMacOS;
              int crossAxisCount = isDesktop ? 4 : 2;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  GameCard(
                    imagePath: 'assets/logos/picture_shadow.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PictureShadowGame(),
                        ),
                      );
                    },
                  ),
                  GameCard(
                    imagePath: 'assets/logos/sound_matching.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SoundImageGame(),
                        ),
                      );
                    },
                  ),
                  GameCard(
                    imagePath: 'assets/logos/coloring_picture.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ColoringPage()),
                      );
                    },
                  ),
                  GameCard(
                    imagePath: 'assets/logos/emotion_faces.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmotionGamePage(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatefulWidget {
  final String imagePath;
  final VoidCallback onTap;

  const GameCard({super.key, required this.imagePath, required this.onTap});

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool isHovered = false;
  bool isPressed = false;

  void _setHovered(bool value) async {
    if (isHovered != value) {
      setState(() => isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool active = isHovered || isPressed;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          setState(() => isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          transform: active
              ? (Matrix4.identity()..scale(1.05))
              : Matrix4.identity(),
          child: Container(
            width: 200,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: active
                      ? Colors.blueAccent.withOpacity(0.4)
                      : Colors.black26,
                  blurRadius: active ? 20 : 10,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
