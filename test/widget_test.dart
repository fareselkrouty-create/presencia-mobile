import 'package:flutter_test/flutter_test.dart';

import 'package:presencia_mobile/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const PresenciaApp());
    // Vérifie que l'app démarre sans crash
    expect(find.byType(PresenciaApp), findsOneWidget);
  });
}
