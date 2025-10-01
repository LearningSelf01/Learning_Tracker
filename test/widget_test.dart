// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:learning_tracker/main.dart';

void main() {
  testWidgets('App boots to LandingPage', (tester) async {
    // Build the app
    await tester.pumpWidget(const LearningTrackerApp());
    await tester.pumpAndSettle();

    // Verify landing UI appears
    expect(find.text('Welcome to Learning Tracker'), findsOneWidget);
    expect(find.text('Student Login'), findsOneWidget);
    expect(find.text('Teacher Login'), findsOneWidget);
  });
}
