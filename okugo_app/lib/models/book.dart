import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/models/question.dart';

class Book {
  Book({
    required this.id,
    required this.title,
    required this.pageCount,
    required this.level,
    required this.questions,
  });

  final String id;
  final String title;
  final int pageCount;
  final CefrLevel level;
  final List<Question> questions; // expected: 20 items

  Book copyWith({
    String? title,
    int? pageCount,
    CefrLevel? level,
    List<Question>? questions,
  }) {
    return Book(
      id: id,
      title: title ?? this.title,
      pageCount: pageCount ?? this.pageCount,
      level: level ?? this.level,
      questions: questions ?? this.questions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'pageCount': pageCount,
        'level': level.toJson(),
        'questions': questions.map((q) => q.toJson()).toList(growable: false),
      };

  static Book fromJson(Map<String, dynamic> json) {
    final rawQuestions = (json['questions'] as List?) ?? const [];
    return Book(
      id: (json['id'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      pageCount: (json['pageCount'] as num?)?.toInt() ?? 0,
      level: CefrLevelX.fromJson((json['level'] as String?) ?? CefrLevel.a1a2.name),
      questions: rawQuestions
          .whereType<Map>()
          .map((m) => Question.fromJson(m.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }
}

