class StudentBookProgress {
  StudentBookProgress({
    required this.bookId,
    this.pagesRead = 0,
    this.earnedPages = 0,
    this.examAttemptsUsed = 0,
    this.examPassed = false,
    this.examLocked = false,
  });

  final String bookId;
  final int pagesRead; // current progress (can be reset to 0)
  final int earnedPages; // max unique pages ever counted for points
  final int examAttemptsUsed; // 0..3 (resets after reread when locked)
  final bool examPassed; // once true, exam cannot be taken again
  final bool examLocked; // after 3 fails, locked until reread complete

  StudentBookProgress copyWith({
    int? pagesRead,
    int? earnedPages,
    int? examAttemptsUsed,
    bool? examPassed,
    bool? examLocked,
  }) {
    return StudentBookProgress(
      bookId: bookId,
      pagesRead: pagesRead ?? this.pagesRead,
      earnedPages: earnedPages ?? this.earnedPages,
      examAttemptsUsed: examAttemptsUsed ?? this.examAttemptsUsed,
      examPassed: examPassed ?? this.examPassed,
      examLocked: examLocked ?? this.examLocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'bookId': bookId,
        'pagesRead': pagesRead,
        'earnedPages': earnedPages,
        'examAttemptsUsed': examAttemptsUsed,
        'examPassed': examPassed,
        'examLocked': examLocked,
      };

  static StudentBookProgress fromJson(Map<String, dynamic> json) {
    return StudentBookProgress(
      bookId: (json['bookId'] as String?) ?? '',
      pagesRead: (json['pagesRead'] as num?)?.toInt() ?? 0,
      earnedPages: (json['earnedPages'] as num?)?.toInt() ?? 0,
      examAttemptsUsed: (json['examAttemptsUsed'] as num?)?.toInt() ?? 0,
      examPassed: (json['examPassed'] as bool?) ?? false,
      examLocked: (json['examLocked'] as bool?) ?? false,
    );
  }
}

