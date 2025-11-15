class PuzzlePiece {
  final String image; // asset path
  final int correctSlot; // grid index where it must be placed

  PuzzlePiece({required this.image, required this.correctSlot});
}

class PuzzleLevel {
  final int gridSize; // 2 = 2x2, 3 = 3x3, etc.
  final List<PuzzlePiece> pieces;

  PuzzleLevel({required this.gridSize, required this.pieces});
}

// ---------------------------------------------
// 10 Levels (Example Images)
// Replace with your actual image assets
// ---------------------------------------------
final List<PuzzleLevel> puzzleLevels = [
  // LEVEL 1 — 2x2 Puzzle
  PuzzleLevel(
    gridSize: 2,
    pieces: List.generate(
      4,
      (i) => PuzzlePiece(
        image: "assets/puzzles/2x2/elephant/image_part_00${i + 1}.png",
        correctSlot: i,
      ),
    ),
  ),
  // LEVEL 2 — 2x2 Puzzle
  PuzzleLevel(
    gridSize: 2,
    pieces: List.generate(
      4,
      (i) => PuzzlePiece(
        image: "assets/puzzles/2x2/car/image_part_00${i + 1}.png",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 3 — 2x2 Puzzle
  PuzzleLevel(
    gridSize: 2,
    pieces: List.generate(
      4,
      (i) => PuzzlePiece(
        image: "assets/puzzles/2x2/cat/image_part_00${i + 1}.png",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 4 — 3x3 Puzzle
  PuzzleLevel(
    gridSize: 3,
    pieces: List.generate(
      9,
      (i) => PuzzlePiece(
        image: "assets/puzzles/3x3/house/image_part_00${i + 1}.png",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 5 — 3x3 Puzzle
  PuzzleLevel(
    gridSize: 3,
    pieces: List.generate(
      9,
      (i) => PuzzlePiece(
        image: "assets/puzzles/3x3/ship/image_part_00${i + 1}.jpg",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 6 — 3x3 Puzzle
  PuzzleLevel(
    gridSize: 3,
    pieces: List.generate(
      9,
      (i) => PuzzlePiece(
        image: "assets/puzzles/3x3/tree/image_part_00${i + 1}.jpg",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 7 — 4x4 Puzzle
  PuzzleLevel(
    gridSize: 4,
    pieces: List.generate(
      16,
      (i) => PuzzlePiece(
        image:
            "assets/puzzles/4x4/lake/image_part_${(i + 1).toString().padLeft(3, '0')}.png",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 8 — 4x4 Puzzle
  PuzzleLevel(
    gridSize: 4,
    pieces: List.generate(
      16,
      (i) => PuzzlePiece(
        image:
            "assets/puzzles/4x4/playground/image_part_${(i + 1).toString().padLeft(3, '0')}.png",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 9 — 4x4 Puzzle
  PuzzleLevel(
    gridSize: 4,
    pieces: List.generate(
      16,
      (i) => PuzzlePiece(
        image:
            "assets/puzzles/4x4/santa/image_part_${(i + 1).toString().padLeft(3, '0')}.jpg",
        correctSlot: i,
      ),
    ),
  ),

  // LEVEL 10 — 4x4 Final Puzzle
  PuzzleLevel(
    gridSize: 4,
    pieces: List.generate(
      16,
      (i) => PuzzlePiece(
        image:
            "assets/puzzles/4x4/scenary/image_part_${(i + 1).toString().padLeft(3, '0')}.png",
        correctSlot: i,
      ),
    ),
  ),
];
