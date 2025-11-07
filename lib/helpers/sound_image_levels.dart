final List<SoundImageLevel> soundImageLevels = [
  SoundImageLevel(
    soundPath: 'assets/sounds/duck.mp3',
    imagePaths: [
      'assets/sounds/duck.png',
      'assets/sounds/cow.png',
      'assets/sounds/train.png',
    ],
    correctIndex: 0,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/cat.mp3',
    imagePaths: [
      'assets/sounds/elephant.png',
      'assets/sounds/cow.png',
      'assets/sounds/cat.png',
    ],
    correctIndex: 2,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/elephant.mp3',
    imagePaths: [
      'assets/sounds/rooster.png',
      'assets/sounds/elephant.png',
      'assets/sounds/bell.png',
    ],
    correctIndex: 1,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/train.mp3',
    imagePaths: [
      'assets/sounds/train.png',
      'assets/sounds/cow.png',
      'assets/sounds/phone.png',
    ],
    correctIndex: 0,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/phone.mp3',
    imagePaths: [
      'assets/sounds/lion.png',
      'assets/sounds/cat.png',
      'assets/sounds/phone.png',
    ],
    correctIndex: 2,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/lion.mp3',
    imagePaths: [
      'assets/sounds/duck.png',
      'assets/sounds/elephant.png',
      'assets/sounds/lion.png',
    ],
    correctIndex: 2,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/dog_bark.mp3',
    imagePaths: [
      'assets/picture_shadow/dog.png',
      'assets/picture_shadow/cat.png',
      'assets/picture_shadow/car.png',
    ],
    correctIndex: 0,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/car_horn.mp3',
    imagePaths: [
      'assets/sounds/train.png',
      'assets/picture_shadow/car.png',
      'assets/sounds/bird.png',
    ],
    correctIndex: 1,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/cow_moo.mp3',
    imagePaths: [
      'assets/sounds/cow.png',
      'assets/sounds/lion.png',
      'assets/sounds/duck.png',
    ],
    correctIndex: 0,
  ),
  SoundImageLevel(
    soundPath: 'assets/sounds/rooster.mp3',
    imagePaths: [
      'assets/sounds/rooster.png',
      'assets/sounds/elephant.png',
      'assets/picture_shadow/dog.png',
    ],
    correctIndex: 0,
  ),
];

class SoundImageLevel {
  final String soundPath;
  final List<String> imagePaths;
  final int correctIndex;

  SoundImageLevel({
    required this.soundPath,
    required this.imagePaths,
    required this.correctIndex,
  });
}
