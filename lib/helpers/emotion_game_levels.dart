final List<EmotionLevel> emotionGameLevels = [
  EmotionLevel(
    imagePath: 'assets/emotions/happy_face.jpg',
    correctEmotion: 'Happy',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/surprised_face.jpg',
    correctEmotion: 'Surprised',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/sad_face.jpg',
    correctEmotion: 'Sad',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/angry_face.jpg',
    correctEmotion: 'Angry',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/tired_face.png',
    correctEmotion: 'Tired',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/scared_face.png',
    correctEmotion: 'Scared',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/disgusted_face.png',
    correctEmotion: 'Disgusted',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/confused_face.png',
    correctEmotion: 'Confused',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/shy_face.png',
    correctEmotion: 'Shy',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/proud_face.png',
    correctEmotion: 'Proud',
  ),
];

class EmotionLevel {
  final String imagePath;
  final String correctEmotion;

  EmotionLevel({required this.imagePath, required this.correctEmotion});
}
