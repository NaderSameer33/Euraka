class HomeworkQuestionModel {
  final String id;
  String type;
  String questionText;
  List<String> options;
  int correctOptionIndex;
  String? modelAnswer;
  int score;
  int order;

  HomeworkQuestionModel({
    required this.id,
    required this.type,
    required this.questionText,
    List<String>? options,
    this.correctOptionIndex = 0,
    this.modelAnswer,
    this.score = 2,
    this.order = 1,
  }) : options = options ?? ['', '', '', ''];

  bool get isMcq => type == 'MCQ';
  bool get isEssay => type == 'ESSAY';

  factory HomeworkQuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedOptions = [];
    if (json['options'] is List) {
      parsedOptions = (json['options'] as List).map((e) => e.toString()).toList();
    } else if (json['options'] is String) {
      try {
        final raw = json['options'] as String;
        final cleaned = raw.replaceAll(RegExp(r'[\[\]"]'), '');
        parsedOptions = cleaned.split(',').map((e) => e.trim()).toList();
      } catch (_) {}
    }

    return HomeworkQuestionModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'MCQ',
      questionText: json['questionText'] as String? ?? '',
      options: parsedOptions.isNotEmpty ? parsedOptions : ['', '', '', ''],
      correctOptionIndex: json['correctOptionIndex'] as int? ?? 0,
      modelAnswer: json['modelAnswer'] as String?,
      score: json['score'] as int? ?? 2,
      order: json['order'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    if (isMcq) {
      return {
        'type': 'MCQ',
        'questionText': questionText.trim(),
        'options': options.map((e) => e.trim()).toList(),
        'correctOptionIndex': correctOptionIndex,
        'score': score,
        'order': order,
      };
    } else {
      return {
        'type': 'ESSAY',
        'questionText': questionText.trim(),
        'modelAnswer': modelAnswer?.trim() ?? '',
        'score': score,
        'order': order,
      };
    }
  }
}

