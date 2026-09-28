import 'package:flutter_test/flutter_test.dart';

import 'package:questly/main.dart';

void main() {
  testWidgets('Splash screen shows the Questly logo text', (tester) async {
    await tester.pumpWidget(const QuestlyApp());
    expect(find.text('QUESTLY'), findsOneWidget);
    // Let the splash animation finish and navigate to the app.
    await tester.pumpAndSettle();
    expect(find.text('Quests'), findsWidgets);
  });
}
