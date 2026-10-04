import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/vm_service.dart';

import '../widget_test_helpers.dart';

class _Tracking extends TimeTravelNotifier {
  final changes = <bool>[];

  @override
  Future<bool> build() async => false;

  @override
  Future<void> setEnabled(bool enabled) async {
    changes.add(enabled);
    state = AsyncData(enabled);
  }
}

void main() {
  testWidgets(
    'start/stop toggles frame navigation without disabling live inspection',
    (tester) async {
      final tracking = _Tracking();
      final frames = foldFrames(const [], [
        Frame.test(index: 0, events: []),
        Frame.test(index: 1, events: []),
      ]);
      final selections = <FrameId>[];
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            timeTravelProvider.overrideWith(() => tracking),
            filteredFramesProvider.overrideWith((ref) => AsyncData(frames)),
          ],
          child: testApp(
            FrameStepper(
              onSelect: selections.add,
              selectedFrame: frames.last,
              selectedElement: null,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      IconButton previous() => tester.widget<IconButton>(
        find.byWidgetPredicate(
          (widget) =>
              widget is IconButton && widget.tooltip == 'Previous frame',
        ),
      );
      expect(previous().onPressed, isNull);
      expect(tester.widget<Opacity>(find.byType(Opacity).first).opacity, 0.4);
      await tester.tap(find.byTooltip('Previous frame'), warnIfMissed: false);
      expect(selections, isEmpty);

      await tester.tap(
        find.byTooltip('Start time travel and record future frames'),
      );
      await tester.pumpAndSettle();
      expect(tracking.changes, [true]);
      expect(
        find.byTooltip('Stop time travel and discard previous frames'),
        findsOneWidget,
      );
      expect(previous().onPressed, isNotNull);
      await tester.tap(find.byTooltip('Previous frame'));
      await tester.pumpAndSettle();
      expect(selections, [frames.first.id]);

      await tester.tap(
        find.byTooltip('Stop time travel and discard previous frames'),
      );
      await tester.pumpAndSettle();
      expect(tracking.changes, [true, false]);
      expect(previous().onPressed, isNull);
      expect(
        find.byTooltip('Start time travel and record future frames'),
        findsOneWidget,
      );
    },
  );

  testWidgets('can start recording before any provider frames exist', (
    tester,
  ) async {
    final tracking = _Tracking();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          timeTravelProvider.overrideWith(() => tracking),
          filteredFramesProvider.overrideWith((ref) => const AsyncData([])),
        ],
        child: testApp(
          FrameStepper(
            onSelect: (_) {},
            selectedFrame: null,
            selectedElement: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byTooltip('Start time travel and record future frames'),
    );
    await tester.pumpAndSettle();
    expect(tracking.changes, [true]);
    expect(
      find.byTooltip('Stop time travel and discard previous frames'),
      findsOneWidget,
    );
  });
}
