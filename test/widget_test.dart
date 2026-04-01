import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:login/app.dart';

void main() {
  testWidgets('ShellFirstApp builds', (WidgetTester tester) async {
    final binding = tester.binding;
    await binding.setSurfaceSize(const Size(1440, 900));

    await tester.pumpWidget(const ShellFirstApp());
    await tester.pumpAndSettle();

    expect(find.text('SWorld'), findsOneWidget);

    await binding.setSurfaceSize(null);
  });
}
