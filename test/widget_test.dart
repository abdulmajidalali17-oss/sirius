import 'package:flutter_test/flutter_test.dart';
import 'package:sirius/app/sirius_app.dart';

void main() {
  testWidgets('Sirius app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const SiriusApp());

    expect(find.text('Sirius'), findsOneWidget);
  });
}
