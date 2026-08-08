import 'package:flutter_test/flutter_test.dart';
import 'package:vision_companion/app.dart';

void main() {
  testWidgets('Vision Companion app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const VisionCompanionApp());

    expect(find.text('Vision Companion'), findsOneWidget);
  });
} 