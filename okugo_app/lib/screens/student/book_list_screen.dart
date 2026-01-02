import 'package:flutter/material.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/screens/student/reader_screen.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    if (app.books.isEmpty) {
      return const Center(child: Text('Henüz kitap yok.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: app.books.length,
      itemBuilder: (context, index) {
        final book = app.books[index];
        final p = app.progressFor(book.id);
        final progress = book.pageCount == 0 ? 0.0 : (p.pagesRead / book.pageCount).clamp(0.0, 1.0);
        final attemptsLeft = app.attemptsLeft(book);

        String status;
        if (p.examPassed) {
          status = 'Sınav: Geçti';
        } else if (p.examLocked) {
          status = 'Sınav: Kilitli (yeniden oku)';
        } else {
          status = 'Sınav hak: $attemptsLeft/3';
        }

        return Card(
          child: ListTile(
            title: Text(book.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                Text('${book.level.label} • ${p.pagesRead}/${book.pageCount} sayfa'),
                const SizedBox(height: 6),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 6),
                Text(status),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ReaderScreen(bookId: book.id)),
              );
            },
          ),
        );
      },
    );
  }
}

