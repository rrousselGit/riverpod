import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:marvel/main.dart';
import 'package:marvel/src/configuration.dart';
import 'package:marvel/src/fake_marvel.dart';
import 'package:marvel/src/marvel.dart';
import 'package:material_ui/material_ui.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        dioProvider.overrideWithValue(FakeDio(null)),
        configurationsProvider.overrideWithValue(
          AsyncData(Configuration(publicKey: '42', privateKey: '42')),
        ),
      ],
      child: const MyApp(),
    ),
  );
  // Waits for the debounced request of the first page.
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump();
}

void main() {
  testWidgets('shows the characters', (tester) async {
    await _pumpApp(tester);

    expect(find.text('3-D Man'), findsOneWidget);
  });

  testWidgets('opens a character from its /characters/<id> route', (
    tester,
  ) async {
    await _pumpApp(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    unawaited(navigator.pushNamed('/characters/1009368'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Iron Man'), findsOneWidget);
  });

  testWidgets('tapping empty space unfocuses', (tester) async {
    await _pumpApp(tester);

    final node = FocusNode();
    addTearDown(node.dispose);
    final context = tester.element(find.text('3-D Man'));
    FocusScope.of(context).requestFocus(node);
    await tester.pump();
    expect(node.hasFocus, isTrue);

    await tester.tapAt(const Offset(1, 599));
    await tester.pump();

    expect(node.hasFocus, isFalse);
  });
}
