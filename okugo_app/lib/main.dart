import 'package:flutter/material.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:okugo_app/ui/app_root.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  await appState.init();

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const OkugoApp(),
    ),
  );
}

class OkugoApp extends StatelessWidget {
  const OkugoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okugo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}
