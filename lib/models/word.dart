class Word {
  final int id;
  final int userId;
  final String englishWord;
  final String spanishMeaning;
  final String wordType;
  bool learned;
  final String? learningDate;
  final String createdAt;
  final String updatedAt;

  Word({
    required this.id,
    required this.userId,
    required this.englishWord,
    required this.spanishMeaning,
    required this.wordType,
    required this.learned,
    this.learningDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      userId: json['user_id'],
      englishWord: json['english_word'],
      spanishMeaning: json['spanish_meaning'],
      wordType: json['word_type'],
      learned: json['learned'] == 1,
      learningDate: json['learning_date'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}