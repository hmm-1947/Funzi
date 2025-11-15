class OddOneOutLevel {
  final String correctImage;
  final List<String> others;
  OddOneOutLevel({required this.correctImage, required this.others});
}

final List<OddOneOutLevel> oddOneOutLevels = [
  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_cat3.webp", // odd one out
    others: [
      "assets/oddone/oddone_cat1.webp",
      "assets/oddone/oddone_cat2.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_carrot.webp",
    others: [
      "assets/oddone/oddone_apple.webp",
      "assets/oddone/oddone_watermelon.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_watermelon.webp",
    others: ["assets/oddone/oddone_car.webp", "assets/oddone/oddone_bus.webp"],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_lion3.webp",
    others: [
      "assets/oddone/oddone_lion1.webp",
      "assets/oddone/oddone_lion2.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_cow.webp",
    others: [
      "assets/oddone/oddone_pigeon.webp",
      "assets/oddone/oddone_crow.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_shirt.webp",
    others: [
      "assets/oddone/oddone_square.webp",
      "assets/oddone/oddone_circle.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_apple.webp",
    others: [
      "assets/oddone/oddone_rose.webp",
      "assets/oddone/oddone_sunflower.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_elephant2.webp",
    others: [
      "assets/oddone/oddone_elephant1.webp",
      "assets/oddone/oddone_elephant3.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_rat.webp",
    others: [
      "assets/oddone/oddone_dog1.webp",
      "assets/oddone/oddone_dog2.webp",
    ],
  ),

  OddOneOutLevel(
    correctImage: "assets/oddone/oddone_redbaloon.webp",
    others: [
      "assets/oddone/oddone_ball1.webp",
      "assets/oddone/oddone_ball2.webp",
    ],
  ),
];
