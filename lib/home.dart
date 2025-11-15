import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:naif/games/coloring_page.dart';
import 'package:naif/games/emotion_game.dart';
import 'package:naif/games/odd_one.dart';
import 'package:naif/games/picture_shadow.dart';
import 'package:naif/games/puzzle_game.dart';
import 'package:naif/games/sound_image.dart';
import 'package:naif/games/visual_cat.dart';

// GLOBAL language state (replaces isArabic)
ValueNotifier<bool> isArabicNotifier = ValueNotifier(false);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;

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
          backgroundColor: const Color.fromARGB(255, 52, 52, 52),
          title: ValueListenableBuilder<bool>(
            valueListenable: isArabicNotifier,
            builder: (context, isArabic, _) {
              return Text(
                isArabic ? 'اختر لعبة' : 'Choose a Game',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'calibri',
                ),
              );
            },
          ),
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
                ValueListenableBuilder<bool>(
                  valueListenable: isArabicNotifier,
                  builder: (context, isArabic, _) {
                    return Switch(
                      value: isArabic,
                      onChanged: (value) {
                        isArabicNotifier.value = value;
                      },
                    );
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
        ),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = isDesktop ? 4 : 2;

              return ValueListenableBuilder<bool>(
                valueListenable: isArabicNotifier,
                builder: (context, isArabic, _) {
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.1,
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/shadow_arabic.png'
                            : 'assets/logos/picture_shadow.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PictureShadowGame(),
                          ),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/sound_arabic.png'
                            : 'assets/logos/sound_matching.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SoundImageGame(),
                          ),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/coloring_arabic.png'
                            : 'assets/logos/coloring_picture.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColoringPage(),
                          ),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/emotion_arabic.png'
                            : 'assets/logos/emotion_faces.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmotionGamePage(),
                          ),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/visual_cat_arabic.png'
                            : 'assets/logos/visual_cat.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VisualCat()),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/odd_one_arabic.png'
                            : 'assets/logos/odd_one.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OddOne()),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/puzzles_arabic.png'
                            : 'assets/logos/puzzles.png',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PuzzleGame()),
                        ),
                      ),
                      GameCard(
                        imagePath: isArabic
                            ? 'assets/logos/soon_arabic.png'
                            : 'assets/logos/soon.png',
                        onTap: () => (),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback onTap;

  const GameCard({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _HoverScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}

class _HoverScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _HoverScale({required this.child, required this.onTap});

  @override
  State<_HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<_HoverScale> {
  bool hovering = false;
  bool pressed = false;

  double get scale {
    if (pressed) return 0.95; // Press shrink
    if (hovering) return 1.05; // Hover enlarge
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) {
          setState(() => pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: hovering
                    ? Colors
                          .blueAccent // ⭐ Hover glow
                    : Colors.black26, // Normal shadow
                blurRadius: hovering ? 20 : 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 150),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
