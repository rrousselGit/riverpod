import 'package:flutter/material.dart' as sdk;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/frame_view.dart';

void main() {
  group('InspectorSettingsButton', () {
    testWidgets('opens its dialog when hosted in the Material app of the SDK', (
      tester,
    ) async {
      // DevTools hosts extensions in the SDK's Material app, whose navigator
      // provides neither the theme nor the localizations of material_ui.
      await tester.pumpWidget(
        const ProviderScope(
          child: sdk.MaterialApp(
            home: sdk.Scaffold(
              body: MaterialApp(
                home: Scaffold(body: InspectorSettingsButton()),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InspectorSettingsButton));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Inspector settings'), findsOneWidget);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text('Inspector settings'), findsNothing);
    });
  });
}
