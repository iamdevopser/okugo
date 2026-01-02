import 'package:flutter/material.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/screens/student/exam_screen.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  int _pageIndex1Based = 1;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final book = app.books.firstWhere((b) => b.id == widget.bookId);
    final p = app.progressFor(book.id);

    final currentPage = _pageIndex1Based.clamp(1, book.pageCount == 0 ? 1 : book.pageCount);
    final text = AppState.storyTextFor(book: book, pageIndex1Based: currentPage);

    final canMarkRead = p.pagesRead < book.pageCount;
    final canStartExam = app.canStartExam(book);

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${book.level.label} • Sayfa ${p.pagesRead}/${book.pageCount}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text('Puan: ${app.studentPoints}'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Text(text),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentPage <= 1
                        ? null
                        : () => setState(() => _pageIndex1Based = currentPage - 1),
                    child: const Text('Önceki'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: currentPage >= book.pageCount
                        ? null
                        : () => setState(() => _pageIndex1Based = currentPage + 1),
                    child: const Text('Sonraki'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: canMarkRead
                  ? () async {
                      final result = await context
                          .read<AppState>()
                          .markPageRead(book.id, book.pageCount);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    }
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('Sayfa Okundu (+5)'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: canStartExam
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ExamScreen(bookId: book.id)),
                      );
                    }
                  : null,
              icon: const Icon(Icons.quiz),
              label: Text(
                p.examPassed
                    ? 'Sınav Geçildi'
                    : (p.examLocked
                        ? 'Sınav Kilitli (yeniden oku)'
                        : 'Sınava Gir (${app.attemptsLeft(book)}/3 hak)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

