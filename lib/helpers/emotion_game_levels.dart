final List<EmotionLevel> emotionGameLevels = [
  EmotionLevel(
    imagePath: 'assets/emotions/happy_face.webp',
    correctEmotion: 'Happy',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/surprised_face.webp',
    correctEmotion: 'Surprised',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/sad_face.webp',
    correctEmotion: 'Sad',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/angry_face.webp',
    correctEmotion: 'Angry',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/tired_face.webp',
    correctEmotion: 'Tired',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/scared_face.webp',
    correctEmotion: 'Scared',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/disgusted_face.webp',
    correctEmotion: 'Disgusted',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/confused_face.webp',
    correctEmotion: 'Confused',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/shy_face.webp',
    correctEmotion: 'Shy',
  ),
  EmotionLevel(
    imagePath: 'assets/emotions/proud_face.webp',
    correctEmotion: 'Proud',
  ),
];

class EmotionLevel {
  final String imagePath;
  final String correctEmotion;

  EmotionLevel({required this.imagePath, required this.correctEmotion});
}
