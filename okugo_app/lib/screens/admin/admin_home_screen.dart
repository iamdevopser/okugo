import 'package:flutter/material.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/screens/admin/exam_editor_screen.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final _titleController = TextEditingController();
  final _pageController = TextEditingController();
  CefrLevel _level = CefrLevel.a1a2;
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _addBook(BuildContext context) async {
    final app = context.read<AppState>();
    final title = _titleController.text.trim();
    final pageCount = int.tryParse(_pageController.text.trim());

    if (title.isEmpty || pageCount == null || pageCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen kitap adı ve geçerli sayfa sayısı girin.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await app.addBook(title: title, pageCount: pageCount, level: _level);
      _titleController.clear();
      _pageController.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kitap eklendi.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin • Kitap Yönetimi'),
        actions: [
          TextButton(
            onPressed: () => context.read<AppState>().setRole(UserRole.student),
            child: const Text('Öğrenciye geç'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Kitap Ekle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Kitap adı',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _pageController,
            decoration: const InputDecoration(
              labelText: 'Sayfa sayısı',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 12),
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Dil seviyesi',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CefrLevel>(
                isExpanded: true,
                value: _level,
                items: CefrLevel.values
                    .map(
                      (l) => DropdownMenuItem(
                        value: l,
                        child: Text(l.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (v) => setState(() => _level = v ?? CefrLevel.a1a2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _saving ? null : () => _addBook(context),
            child: Text(_saving ? 'Ekleniyor...' : 'Kitap Ekle'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Mevcut Kitaplar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          if (app.books.isEmpty)
            const Text('Henüz kitap yok.')
          else
            ...app.books.map(
              (b) => Card(
                child: ListTile(
                  title: Text(b.title),
                  subtitle: Text('${b.level.label} • ${b.pageCount} sayfa • ${b.questions.length} soru'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ExamEditorScreen(bookId: b.id),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

