import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/time_in_range_graph/tir_vu.dart';

void main() {
  testWidgets('Test TIRVU rendering', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TIRVU()));
    expect(find.byType(TIRVU), findsOneWidget);
    if (tester.takeException() != null) {
      throw tester.takeException()!;
    }
  });
}
