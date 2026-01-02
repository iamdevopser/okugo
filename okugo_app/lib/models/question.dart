class Question {
  Question({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  }) : assert(options.length == 4, 'Options must have exactly 4 items.');

  final String id;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  Question copyWith({
    String? prompt,
    List<String>? options,
    int? correctIndex,
  }) {
    return Question(
      id: id,
      prompt: prompt ?? this.prompt,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'options': options,
        'correctIndex': correctIndex,
      };

  static Question fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List?)?.cast<String>() ?? const <String>[];
    return Question(
      id: (json['id'] as String?) ?? '',
      prompt: (json['prompt'] as String?) ?? '',
      options: options.length == 4
          ? options
          : [
              ...options,
              ...List.filled(4 - options.length, ''),
            ].take(4).toList(growable: false),
      correctIndex: (json['correctIndex'] as num?)?.toInt() ?? 0,
    );
  }
}

