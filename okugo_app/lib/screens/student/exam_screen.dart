import 'package:flutter/material.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, required this.bookId});

  final String bookId;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _index = 0;
  late List<int> _answers; // -1 = unanswered
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _answers = List.filled(20, -1);
  }

  Future<void> _submit(BuildContext context) async {
    final app = context.read<AppState>();
    final book = app.books.firstWhere((b) => b.id == widget.bookId);

    if (_answers.any((a) => a == -1)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm soruları cevaplayın.')),
      );
      return;
    }

    final correctCount = List.generate(book.questions.length, (i) {
      return _answers[i] == book.questions[i].correctIndex ? 1 : 0;
    }).fold(0, (a, b) => a + b);

    setState(() => _submitting = true);
    try {
      final result = await app.submitExam(book: book, correctCount: correctCount);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(result.passed ? 'Geçti' : 'Kaldı'),
          content: Text(
            '${result.message}\n\nDoğru sayısı: $correctCount/20',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tamam'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      Navigator.of(context).pop(); // back to reader
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final book = app.books.firstWhere((b) => b.id == widget.bookId);
    final q = book.questions[_index];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sınav • ${book.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Soru ${_index + 1}/20',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(q.prompt),
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < 4; i++)
              RadioListTile<int>(
                value: i,
                groupValue: _answers[_index],
                onChanged: _submitting ? null : (v) => setState(() => _answers[_index] = v ?? -1),
                title: Text(q.options[i]),
              ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting || _index == 0
                        ? null
                        : () => setState(() => _index--),
                    child: const Text('Geri'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _submitting
                        ? null
                        : () {
                            if (_index < 19) {
                              setState(() => _index++);
                            } else {
                              _submit(context);
                            }
                          },
                    child: Text(_index < 19 ? 'İleri' : 'Bitir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

