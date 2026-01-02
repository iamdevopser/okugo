import 'package:flutter/foundation.dart';
import 'package:okugo_app/models/book.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/models/question.dart';
import 'package:okugo_app/models/student_book_progress.dart';
import 'package:okugo_app/services/persistence_service.dart';
import 'package:okugo_app/services/seed_data.dart';

enum UserRole { admin, student }

class AppState extends ChangeNotifier {
  final PersistenceService _persistence = PersistenceService();

  bool _ready = false;
  bool get isReady => _ready;

  UserRole? _role;
  UserRole? get role => _role;

  final List<Book> _books = [];
  List<Book> get books => List.unmodifiable(_books);

  int _studentPoints = 0;
  int get studentPoints => _studentPoints;

  final Map<String, StudentBookProgress> _progressByBookId = {};
  StudentBookProgress progressFor(String bookId) =>
      _progressByBookId[bookId] ?? StudentBookProgress(bookId: bookId);

  Future<void> init() async {
    final stored = await _persistence.load();
    if (stored == null) {
      _books
        ..clear()
        ..addAll(SeedData.initialBooks());
      _studentPoints = 0;
      _progressByBookId.clear();
    } else {
      _books
        ..clear()
        ..addAll(stored.books);
      _studentPoints = stored.studentPoints;
      _progressByBookId
        ..clear()
        ..addAll(stored.progressByBookId);
    }

    _ready = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    await _persistence.save(
      AppPersistedData(
        books: _books,
        studentPoints: _studentPoints,
        progressByBookId: _progressByBookId,
      ),
    );
  }

  void setRole(UserRole role) {
    _role = role;
    notifyListeners();
  }

  // ---- Admin operations ----
  Future<void> addBook({
    required String title,
    required int pageCount,
    required CefrLevel level,
  }) async {
    final bookId = _id('book');
    final questions = List.generate(
      20,
      (i) => Question(
        id: _id('q'),
        prompt: 'Soru ${i + 1}: ${title} kitabı ile ilgili örnek soru.',
        options: const [
          'A) Doğru seçenek',
          'B) Seçenek',
          'C) Seçenek',
          'D) Seçenek',
        ],
        correctIndex: 0,
      ),
    );

    _books.add(
      Book(
        id: bookId,
        title: title.trim(),
        pageCount: pageCount,
        level: level,
        questions: questions,
      ),
    );

    await _persist();
    notifyListeners();
  }

  Future<void> updateBookQuestions(String bookId, List<Question> questions) async {
    final idx = _books.indexWhere((b) => b.id == bookId);
    if (idx == -1) return;

    _books[idx] = _books[idx].copyWith(questions: List.unmodifiable(questions));
    await _persist();
    notifyListeners();
  }

  // ---- Student operations ----
  /// Adds +5 points for each newly-earned page.
  /// If exam is locked and the student completes the book again, exam unlocks
  /// and attempts reset to 0.
  Future<PageReadResult> markPageRead(String bookId, int pageCount) async {
    var p = progressFor(bookId);

    if (p.pagesRead >= pageCount) {
      return const PageReadResult(
        pointsAwarded: 0,
        examUnlockedNow: false,
        message: 'Bu kitap zaten tamamlandı.',
      );
    }

    final newPagesRead = p.pagesRead + 1;
    var pointsAwarded = 0;
    var newEarned = p.earnedPages;
    if (newPagesRead > p.earnedPages) {
      pointsAwarded = (newPagesRead - p.earnedPages) * 5;
      newEarned = newPagesRead;
      _studentPoints += pointsAwarded;
    }

    var examUnlockedNow = false;
    var newAttempts = p.examAttemptsUsed;
    var newLocked = p.examLocked;

    // Unlock exam only after reread is complete.
    if (p.examLocked && newPagesRead >= pageCount) {
      newLocked = false;
      newAttempts = 0;
      examUnlockedNow = true;
    }

    p = p.copyWith(
      pagesRead: newPagesRead,
      earnedPages: newEarned,
      examAttemptsUsed: newAttempts,
      examLocked: newLocked,
    );
    _progressByBookId[bookId] = p;

    await _persist();
    notifyListeners();

    return PageReadResult(
      pointsAwarded: pointsAwarded,
      examUnlockedNow: examUnlockedNow,
      message: pointsAwarded > 0
          ? '+$pointsAwarded puan kazandın.'
          : 'Sayfa okundu (puan yok).',
    );
  }

  bool canStartExam(Book book) {
    final p = progressFor(book.id);
    if (p.examPassed) return false;
    if (p.examLocked) return false;
    if (p.pagesRead < book.pageCount) return false;
    if (p.examAttemptsUsed >= 3) return false;
    return true;
  }

  int attemptsLeft(Book book) {
    final p = progressFor(book.id);
    final left = 3 - p.examAttemptsUsed;
    return left < 0 ? 0 : left;
  }

  Future<ExamSubmitResult> submitExam({
    required Book book,
    required int correctCount,
  }) async {
    final p0 = progressFor(book.id);
    if (!canStartExam(book)) {
      return const ExamSubmitResult(
        passed: false,
        pointsAwarded: 0,
        lockedAndReset: false,
        message: 'Sınava şu anda giremezsin.',
      );
    }

    final passed = correctCount >= 14; // 70% threshold (14/20)
    final nextAttemptsUsed = p0.examAttemptsUsed + 1;

    if (passed) {
      _studentPoints += 100;
      final p1 = p0.copyWith(
        examPassed: true,
        examAttemptsUsed: nextAttemptsUsed,
      );
      _progressByBookId[book.id] = p1;
      await _persist();
      notifyListeners();
      return ExamSubmitResult(
        passed: true,
        pointsAwarded: 100,
        lockedAndReset: false,
        message: 'Tebrikler! Sınavı geçtin. +100 puan.',
      );
    }

    // Failed attempt
    if (nextAttemptsUsed >= 3) {
      // Lock exam and reset reading progress; requires reread to unlock.
      final p1 = p0.copyWith(
        pagesRead: 0,
        examLocked: true,
        examAttemptsUsed: 3,
      );
      _progressByBookId[book.id] = p1;
      await _persist();
      notifyListeners();
      return const ExamSubmitResult(
        passed: false,
        pointsAwarded: 0,
        lockedAndReset: true,
        message:
            'Sınavdan 3. kez kaldın. Kitap ilerlemen sıfırlandı; kitabı yeniden okuyup sınavı tekrar açmalısın.',
      );
    }

    final left = 3 - nextAttemptsUsed;
    final p1 = p0.copyWith(examAttemptsUsed: nextAttemptsUsed);
    _progressByBookId[book.id] = p1;
    await _persist();
    notifyListeners();
    return ExamSubmitResult(
      passed: false,
      pointsAwarded: 0,
      lockedAndReset: false,
      message: 'Sınavdan kaldın. Kalan hak: $left',
    );
  }

  // ---- Scoreboard helpers ----
  int get totalEarnedPages =>
      _progressByBookId.values.fold(0, (sum, p) => sum + p.earnedPages);

  int get passedExamCount =>
      _progressByBookId.values.where((p) => p.examPassed).length;

  CefrLevel get currentLevel {
    // Highest level among passed exams; otherwise A1–A2.
    CefrLevel best = CefrLevel.a1a2;
    for (final b in _books) {
      final p = progressFor(b.id);
      if (p.examPassed) {
        if (b.level.index > best.index) best = b.level;
      }
    }
    return best;
  }

  static String storyTextFor({
    required Book book,
    required int pageIndex1Based,
  }) {
    final level = book.level.label;
    final page = pageIndex1Based;
    return [
      '${book.title}',
      'Seviye: $level',
      '',
      'Sayfa $page: Bu, okuma deneyimini simüle eden örnek metindir.',
      'Kısa cümleler ve anlaşılır bir yapı ile ilerlersin.',
      '',
      'Not: Admin panelinden kitap ekleyebilir, sınav sorularını düzenleyebilirsin.',
    ].join('\n');
  }

  static String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
}

class PageReadResult {
  const PageReadResult({
    required this.pointsAwarded,
    required this.examUnlockedNow,
    required this.message,
  });

  final int pointsAwarded;
  final bool examUnlockedNow;
  final String message;
}

class ExamSubmitResult {
  const ExamSubmitResult({
    required this.passed,
    required this.pointsAwarded,
    required this.lockedAndReset,
    required this.message,
  });

  final bool passed;
  final int pointsAwarded;
  final bool lockedAndReset;
  final String message;
}

