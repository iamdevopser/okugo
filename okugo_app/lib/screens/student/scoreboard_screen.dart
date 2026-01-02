import 'package:flutter/material.dart';
import 'package:okugo_app/models/cefr_level.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final level = app.currentLevel;

    final rows = app.books.map((b) {
      final p = app.progressFor(b.id);
      final examStatus = p.examPassed
          ? 'Geçti'
          : (p.examLocked ? 'Kilitli' : 'Hak: ${app.attemptsLeft(b)}/3');
      return DataRow(
        cells: [
          DataCell(Text(b.title)),
          DataCell(Text(b.level.label)),
          DataCell(Text('${p.pagesRead}/${b.pageCount}')),
          DataCell(Text(examStatus)),
        ],
      );
    }).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Genel Durum',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text('Toplam puan: ${app.studentPoints}'),
                Text('Puan kazandıran okunan sayfa: ${app.totalEarnedPages}'),
                Text('Geçilen sınav: ${app.passedExamCount}'),
                const SizedBox(height: 8),
                Text('Mevcut seviye: ${level.label}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Kitap Bazlı İlerleme',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Kitap')),
              DataColumn(label: Text('Seviye')),
              DataColumn(label: Text('Sayfa')),
              DataColumn(label: Text('Sınav')),
            ],
            rows: rows,
          ),
        ),
      ],
    );
  }
}

