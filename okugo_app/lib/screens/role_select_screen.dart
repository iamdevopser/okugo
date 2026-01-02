import 'package:flutter/material.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Okugo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rol seçin',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'Bu MVP sürümünde gerçek giriş yoktur. Sadece Admin veya Öğrenci rolünü seçip devam edebilirsiniz.',
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => app.setRole(UserRole.student),
              icon: const Icon(Icons.menu_book),
              label: const Text('Öğrenci'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => app.setRole(UserRole.admin),
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}

