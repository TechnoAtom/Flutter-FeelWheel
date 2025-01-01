class UserEmotion {
  final String emotion1;
  final String emotion2;
  final String emotion3;
  final String createdAt;

  UserEmotion({
    required this.emotion1,
    required this.emotion2,
    required this.emotion3,
    required this.createdAt,
  });

  // JSON'dan gelen verileri bu modele dönüştüren bir factory constructor
  factory UserEmotion.fromJson(Map<String, dynamic> json) {
    return UserEmotion(
      emotion1: json['emotion1'] ?? '',
      emotion2: json['emotion2'] ?? '',
      emotion3: json['emotion3'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}
