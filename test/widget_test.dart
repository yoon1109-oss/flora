import 'package:flutter_test/flutter_test.dart';
import 'package:flora/main.dart';

void main() {
  testWidgets('App renders FLORA title', (WidgetTester tester) async {
    await tester.pumpWidget(const FloraApp(defaultFlowerName: '자나 장미'));
    expect(find.text('FLORA'), findsOneWidget);
  });
}
