import 'package:flutter/material.dart';
import 'package:okugo_app/screens/admin/admin_home_screen.dart';
import 'package:okugo_app/screens/role_select_screen.dart';
import 'package:okugo_app/screens/student/student_shell.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    if (!app.isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = app.role;
    if (role == null) return const RoleSelectScreen();
    if (role == UserRole.admin) return const AdminHomeScreen();
    return const StudentShell();
  }
}

