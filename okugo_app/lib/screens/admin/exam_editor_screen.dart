import 'package:flutter/material.dart';
import 'package:okugo_app/models/question.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class ExamEditorScreen extends StatelessWidget {
  const ExamEditorScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final book = app.books.firstWhere((b) => b.id == bookId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sınav Düzenle • ${book.title}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Bu kitap için ${book.questions.length}/20 soru var.',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...List.generate(book.questions.length, (index) {
            final q = book.questions[index];
            return Card(
              child: ListTile(
                title: Text('Soru ${index + 1}'),
                subtitle: Text(
                  q.prompt.isEmpty ? '(Boş)' : q.prompt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final updated = await Navigator.of(context).push<Question?>(
                    MaterialPageRoute(
                      builder: (_) => QuestionEditorScreen(
                        question: q,
                        questionNumber: index + 1,
                      ),
                    ),
                  );
                  if (updated == null) return;
                  final updatedList = [...book.questions];
                  updatedList[index] = updated;
                  await context.read<AppState>().updateBookQuestions(bookId, updatedList);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class QuestionEditorScreen extends StatefulWidget {
  const QuestionEditorScreen({
    super.key,
    required this.question,
    required this.questionNumber,
  });

  final Question question;
  final int questionNumber;

  @override
  State<QuestionEditorScreen> createState() => _QuestionEditorScreenState();
}

class _QuestionEditorScreenState extends State<QuestionEditorScreen> {
  late final TextEditingController _prompt;
  late final List<TextEditingController> _options;
  late int _correctIndex;

  @override
  void initState() {
    super.initState();
    _prompt = TextEditingController(text: widget.question.prompt);
    _options = List.generate(
      4,
      (i) => TextEditingController(text: widget.question.options[i]),
    );
    _correctIndex = widget.question.correctIndex;
  }

  @override
  void dispose() {
    _prompt.dispose();
    for (final c in _options) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final prompt = _prompt.text.trim();
    final opts = _options.map((c) => c.text.trim()).toList(growable: false);

    if (prompt.isEmpty || opts.any((o) => o.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen soru ve 4 seçeneği de doldurun.')),
      );
      return;
    }

    Navigator.of(context).pop(
      widget.question.copyWith(
        prompt: prompt,
        options: opts,
        correctIndex: _correctIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soru ${widget.questionNumber}'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Kaydet')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _prompt,
            decoration: const InputDecoration(
              labelText: 'Soru metni',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          const Text('Seçenekler (doğru seçeneği işaretleyin):'),
          const SizedBox(height: 8),
          for (var i = 0; i < 4; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio<int>(
                  value: i,
                  groupValue: _correctIndex,
                  onChanged: (v) => setState(() => _correctIndex = v ?? 0),
                ),
                Expanded(
                  child: TextField(
                    controller: _options[i],
                    decoration: InputDecoration(
                      labelText: 'Seçenek ${String.fromCharCode(65 + i)}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

