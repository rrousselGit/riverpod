import 'dart:async';

import 'package:flutter/material.dart' as sdk;
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/frame_view.dart';
import 'package:riverpod_devtool_core/riverpod_devtool_core.dart';

import '../widget_test_helpers.dart';

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

  group('ProviderViewer', () {
    Widget viewer({required bool isCurrent}) {
      return ProviderScope(
        overrides: [
          // The application never answers: only the layout is under test.
          appConnectionProvider.overrideWith(
            (ref) => Completer<AppConnection>().future,
          ),
        ],
        child: testApp(
          ProviderViewer(
            isCurrent: isCurrent,
            element: ElementMeta(
              provider: ProviderMeta.test(elementId: 'element'),
              state: ProviderStateRef.test(cacheId: 'state'),
              notifier: ProviderStateRef.test(cacheId: 'notifier'),
              children: const {},
              parents: const {},
            ),
          ),
        ),
      );
    }

    IconButton invalidate(WidgetTester tester) => tester.widget<IconButton>(
      find.descendant(
        of: find.byType(InvalidateProviderButton),
        matching: find.byType(IconButton),
      ),
    );

    testWidgets('acts on the provider when showing its current state', (
      tester,
    ) async {
      await tester.pumpWidget(viewer(isCurrent: true));

      expect(find.text('Notifier'), findsOneWidget);
      expect(invalidate(tester).onPressed, isNotNull);
      expect(invalidate(tester).tooltip, 'Invalidate provider');
    });

    testWidgets(
      'tells that a past or disposed provider differs from the application',
      (tester) async {
        await tester.pumpWidget(viewer(isCurrent: false));

        // Frames record states, but not notifiers.
        expect(find.text('Notifier'), findsNothing);
        expect(find.text('Notifier (as it is now)'), findsOneWidget);
        expect(invalidate(tester).onPressed, isNull);
        expect(
          invalidate(tester).tooltip,
          'Only the current state of a provider can be invalidated',
        );
      },
    );
  });
}
