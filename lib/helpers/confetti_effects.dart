import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class CommonConfetti extends StatelessWidget {
  final ConfettiController controller;
  final double blastDirection;
  final bool shouldLoop;

  const CommonConfetti({
    super.key,
    required this.controller,
    this.blastDirection = -pi / 2,
    this.shouldLoop = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.directional,
      blastDirection: blastDirection,
      minBlastForce: 13,
      maxBlastForce: 23,
      emissionFrequency: 0.0,
      numberOfParticles: 20,
      gravity: 0.4,
      colors: const [Colors.red, Colors.blue, Colors.green, Colors.yellow],
    );
  }
}
