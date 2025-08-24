import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_app/main.dart';

void main() {
  testWidgets('App loads QuizApp and shows title', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const QuizApp());

    // Verify that the AppBar title exists
    expect(find.text('IQS Quiz'), findsOneWidget);
  });
}
