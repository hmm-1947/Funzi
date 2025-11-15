import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:naif/helpers/complete_screen.dart';
import 'package:naif/helpers/puzzle_levels.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/helpers/confetti_effects.dart';
import 'package:naif/home.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({super.key});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  int currentLevel = 0;
  bool levelComplete = false;
  bool allComplete = false;
  late List<PuzzlePiece> shuffledPieces;

  late ConfettiController _confettiController;
  Map<int, String?> placedPieces = {};
  final ScrollController _piecesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initLevel();
  }

  void _initLevel() {
    final level = puzzleLevels[currentLevel];

    placedPieces = {for (int i = 0; i < level.pieces.length; i++) i: null};
    levelComplete = false;

    // Shuffle the pieces ONCE for this level
    shuffledPieces = List.of(level.pieces)..shuffle();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkCompletion() {
    final level = puzzleLevels[currentLevel];

    for (var piece in level.pieces) {
      if (placedPieces[piece.correctSlot] != piece.image) return;
    }

    // All correct
    setState(() => levelComplete = true);
    playCrossPlatformSound('assets/soundeffects/correct.mp3');
    _confettiController.stop();
    _confettiController.play();
  }

  void nextLevel() {
    if (currentLevel < puzzleLevels.length - 1) {
      setState(() {
        currentLevel++;
        _initLevel();
      });
    } else {
      // Last level finished
      setState(() {
        allComplete = true;
      });
      playCrossPlatformSound('assets/soundeffects/won.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⭐ ALL LEVELS COMPLETED SCREEN (same style as SoundImageGame)
    if (allComplete) {
      return CompleteScreen();
    }

    // Normal level layout
    final level = puzzleLevels[currentLevel];
    final gridCount = level.gridSize * level.gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isArabic ? "حل اللغز" : "Solve the Puzzle",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'calibri',
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 52, 52, 52),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/cover.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // ⭐ Puzzle Grid
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: GridView.builder(
                        itemCount: gridCount,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: level.gridSize,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemBuilder: (_, slot) {
                          final placedImage = placedPieces[slot];

                          return DragTarget<String>(
                            onAccept: (img) {
                              setState(() {
                                placedPieces[slot] = img;
                              });

                              // Wait for the frame to update before checking
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                checkCompletion();
                              });

                              playCrossPlatformSound(
                                "assets/soundeffects/pluck.mp3",
                              );
                            },
                            builder: (_, __, ___) {
                              if (placedImage == null) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54),
                                  ),
                                );
                              }

                              return Draggable<String>(
                                data: placedImage,
                                feedback: Image.asset(
                                  placedImage,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                                childWhenDragging: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54),
                                  ),
                                ),
                                onDragStarted: () {
                                  setState(() => placedPieces[slot] = null);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black54),
                                  ),
                                  child: Image.asset(
                                    placedImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // ⭐ Pieces Row
                SizedBox(
                  height: 170,
                  child: Listener(
                    onPointerSignal: (pointerSignal) {
                      if (pointerSignal is PointerScrollEvent) {
                        // Convert vertical scroll → horizontal scroll
                        _piecesScrollController.jumpTo(
                          _piecesScrollController.offset -
                              pointerSignal.scrollDelta.dy,
                        );
                      }
                    },
                    child: SingleChildScrollView(
                      controller: _piecesScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: 150,
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: shuffledPieces.map((piece) {
                            bool used = placedPieces.containsValue(piece.image);
                            if (used) return const SizedBox.shrink();

                            return Draggable<String>(
                              data: piece.image,
                              feedback: Image.asset(
                                piece.image,
                                width: 90,
                                height: 90,
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.4,
                                child: Image.asset(
                                  piece.image,
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                              child: Image.asset(
                                piece.image,
                                width: 90,
                                height: 90,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                // ⭐ Continue Button
                if (levelComplete)
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
                      isArabic ? "استمر ➜" : "Continue ➜",
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),

                const SizedBox(height: 50),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: CommonConfetti(controller: _confettiController),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
