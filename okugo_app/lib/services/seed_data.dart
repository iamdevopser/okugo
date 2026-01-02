import 'package:okugo_app/models/book.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/models/question.dart';

class SeedData {
  static List<Book> initialBooks() {
    return [
      _book('A1-A2: Parkta Bir Gün', 10, CefrLevel.a1a2),
      _book('A2-B1: Şehrin Küçük Sırrı', 12, CefrLevel.a2b1),
      _book('B1-B2: Eski Defter', 14, CefrLevel.b1b2),
      _book('B2-C1: Gölgedeki Mektup', 16, CefrLevel.b2c1),
      _book('C1-C2: Zamanın Kıyısında', 18, CefrLevel.c1c2),
    ];
  }

  static Book _book(String title, int pages, CefrLevel level) {
    final id = _id('book', title);
    return Book(
      id: id,
      title: title,
      pageCount: pages,
      level: level,
      questions: List.generate(20, (i) => _placeholderQuestion(id, i + 1)),
    );
  }

  static Question _placeholderQuestion(String bookId, int number) {
    final qid = _id('q', '$bookId-$number');
    return Question(
      id: qid,
      prompt: 'Soru $number: Bu kitapla ilgili örnek bir soru metni.',
      options: const [
        'A) Örnek doğru seçenek',
        'B) Örnek seçenek',
        'C) Örnek seçenek',
        'D) Örnek seçenek',
      ],
      correctIndex: 0,
    );
  }

  static String _id(String prefix, String seed) {
    final safe = seed
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    final ts = DateTime.now().microsecondsSinceEpoch.toString();
    return '$prefix-$safe-$ts';
  }
}

