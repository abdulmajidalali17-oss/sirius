import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sirius/app/sirius_app.dart';
import 'package:sirius/features/auth/application/auth_providers.dart';

void main() {
  testWidgets('Sirius app launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(null)),
        ],
        child: const SiriusApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sirius'), findsOneWidget);
  });
}
