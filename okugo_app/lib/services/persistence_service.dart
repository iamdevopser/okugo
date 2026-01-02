import 'dart:convert';

import 'package:okugo_app/models/book.dart';
import 'package:okugo_app/models/student_book_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const _key = 'okugo_state_v1';

  Future<AppPersistedData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return AppPersistedData.fromJson(decoded);
    } catch (_) {
      // Corrupt data: ignore and start fresh.
      return null;
    }
  }

  Future<void> save(AppPersistedData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data.toJson()));
  }
}

class AppPersistedData {
  AppPersistedData({
    required this.books,
    required this.studentPoints,
    required this.progressByBookId,
  });

  final List<Book> books;
  final int studentPoints;
  final Map<String, StudentBookProgress> progressByBookId;

  Map<String, dynamic> toJson() => {
        'books': books.map((b) => b.toJson()).toList(growable: false),
        'studentPoints': studentPoints,
        'progressByBookId': progressByBookId.map((k, v) => MapEntry(k, v.toJson())),
      };

  static AppPersistedData fromJson(Map<String, dynamic> json) {
    final booksRaw = (json['books'] as List?) ?? const [];
    final progressRaw = (json['progressByBookId'] as Map?) ?? const {};

    return AppPersistedData(
      books: booksRaw
          .whereType<Map>()
          .map((m) => Book.fromJson(m.cast<String, dynamic>()))
          .toList(growable: false),
      studentPoints: (json['studentPoints'] as num?)?.toInt() ?? 0,
      progressByBookId: progressRaw.map(
        (k, v) => MapEntry(
          k.toString(),
          StudentBookProgress.fromJson((v as Map).cast<String, dynamic>()),
        ),
      ),
    );
  }
}

