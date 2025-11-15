class VisualCatLevel {
  final String questionEn;
  final String questionAr;
  final String iconPath;
  final String correctImage;
  final List<String> distractors;

  VisualCatLevel({
    required this.questionEn,
    required this.questionAr,
    required this.iconPath,
    required this.correctImage,
    required this.distractors,
  });
}

final List<VisualCatLevel> visualCatLevels = [
  VisualCatLevel(
    questionEn: "Which item is used for cleaning?",
    questionAr: "العنصر المستخدم للتنظيف",
    iconPath: "assets/visualcat/clean.webp",
    correctImage: "assets/visualcat/visual_mop.png",
    distractors: [
      "assets/visualcat/visual_scissor.png",
      "assets/visualcat/visual_clock.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one is used for writing?",
    questionAr: "أي شيء يستخدم للكتابة؟",
    iconPath: "assets/visualcat/pen.webp",
    correctImage: "assets/visualcat/visual_pen.png",
    distractors: [
      "assets/visualcat/visual_pan.png",
      "assets/visualcat/visual_brush.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Who can fly?",
    questionAr: "من يستطيع الطيران؟",
    iconPath: "assets/visualcat/fly.avif",
    correctImage: "assets/visualcat/visual_bird.png",
    distractors: [
      "assets/visualcat/visual_apple.png",
      "assets/visualcat/visual_clock.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which item is used for cutting paper?",
    questionAr: "أي عنصر يستخدم لقص الورق؟",
    iconPath: "assets/visualcat/cut.webp",
    correctImage: "assets/visualcat/visual_scissor.png",
    distractors: [
      "assets/visualcat/visual_shoe.png",
      "assets/visualcat/visual_pan.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one do we wear on our feet?",
    questionAr: "ماذا نرتدي على أقدامنا؟",
    iconPath: "assets/visualcat/shoe.jpg",
    correctImage: "assets/visualcat/visual_shoe.png",
    distractors: [
      "assets/visualcat/visual_mop.png",
      "assets/visualcat/visual_pen.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one is used for cooking?",
    questionAr: "أي شيء يستخدم للطهي؟",
    iconPath: "assets/visualcat/cook.webp",
    correctImage: "assets/visualcat/visual_pan.png",
    distractors: [
      "assets/visualcat/visual_apple.png",
      "assets/visualcat/visual_bird.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one gives us light?",
    questionAr: "أي شيء يعطينا الضوء؟",
    iconPath: "assets/visualcat/light.webp",
    correctImage: "assets/visualcat/visual_lamp.png",
    distractors: [
      "assets/visualcat/visual_shoe.png",
      "assets/visualcat/visual_brush.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one is a fruit?",
    questionAr: "أي واحد هو فاكهة؟",
    iconPath: "assets/visualcat/fruit.jpg",
    correctImage: "assets/visualcat/visual_apple.png",
    distractors: [
      "assets/visualcat/visual_scissor.png",
      "assets/visualcat/visual_lamp.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one is used to tell time?",
    questionAr: "أي واحد يستخدم لمعرفة الوقت؟",
    iconPath: "assets/visualcat/watch.webp",
    correctImage: "assets/visualcat/visual_clock.png",
    distractors: [
      "assets/visualcat/visual_pen.png",
      "assets/visualcat/visual_mop.png",
    ],
  ),

  VisualCatLevel(
    questionEn: "Which one is used to brush teeth?",
    questionAr: "أي واحد يستخدم لتنظيف الأسنان؟",
    iconPath: "assets/visualcat/brush.webp",
    correctImage: "assets/visualcat/visual_brush.png",
    distractors: [
      "assets/visualcat/visual_apple.png",
      "assets/visualcat/visual_bird.png",
    ],
  ),
];
