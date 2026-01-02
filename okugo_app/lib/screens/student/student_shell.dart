import 'package:flutter/material.dart';
import 'package:okugo_app/screens/student/book_list_screen.dart';
import 'package:okugo_app/screens/student/scoreboard_screen.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BookListScreen(),
      const ScoreboardScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Öğrenci'),
        actions: [
          TextButton(
            onPressed: () => context.read<AppState>().setRole(UserRole.admin),
            child: const Text('Admin'),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.library_books),
            label: 'Kitaplar',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events),
            label: 'Puan Tablosu',
          ),
        ],
      ),
    );
  }
}

