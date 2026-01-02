// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:okugo_app/main.dart';
import 'package:okugo_app/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App starts on role selection', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.init();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const OkugoApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Rol seçin'), findsOneWidget);
    expect(find.text('Öğrenci'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
  });
}
