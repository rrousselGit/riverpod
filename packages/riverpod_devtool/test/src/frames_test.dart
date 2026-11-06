import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_devtool/src/elements.dart';
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/vm_service.dart';

import '../widget_test_helpers.dart';

ProviderElementAddEvent addEvent(
  String elementId, {
  String stateId = 'state',
  String? notifierId,
}) {
  return ProviderElementAddEvent(
    provider: ProviderMeta.test(elementId: elementId),
    state: ProviderStateRef.test(cacheId: stateId),
    notifier: notifierId == null
        ? null
        : ProviderStateRef.test(cacheId: notifierId),
  );
}

ProviderElementUpdateEvent updateEvent(
  String elementId, {
  String nextId = 'next',
  String? notifierId,
}) {
  return ProviderElementUpdateEvent(
    provider: ProviderMeta.test(elementId: elementId),
    next: ProviderStateRef.test(cacheId: nextId),
    notifier: notifierId == null
        ? null
        : ProviderStateRef.test(cacheId: notifierId),
  );
}

ProviderElementDisposeEvent disposeEvent(String elementId) {
  return ProviderElementDisposeEvent(
    provider: ProviderMeta.test(elementId: elementId),
  );
}

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
  test('snapshots replace history and recording appends to the baseline', () {
    final initial = foldFrames(const [], [
      Frame.test(index: 0, events: [addEvent('old')]),
    ]);
    final snapshot = foldFrames(initial, [
      Frame.test(index: 0, events: [addEvent('current')]),
    ]);
    expect(snapshot, hasLength(1));
    expect(snapshot.single.previous, isNull);
    expect(snapshot.single.elements.keys, ['current']);

    final history = foldFrames(snapshot, [
      Frame.test(index: 1, events: [updateEvent('current')]),
    ]);
    expect(history, hasLength(2));
    expect(history.last.previous, same(snapshot.single));

    final stopped = foldFrames(history, [Frame.test(index: 0, events: [])]);
    expect(stopped, hasLength(1));
    expect(stopped.single.elements, isEmpty);
    expect(stopped.single.previous, isNull);
  });

  group('FoldedFrame', () {
    test('requires the first frame to start at index zero', () {
      expect(
        () => FoldedFrame(
          frame: Frame.test(index: 1, events: const []),
          previous: null,
        ),
        throwsStateError,
      );
    });

    test('requires timestamps to stay chronological', () {
      final first = FoldedFrame(
        frame: Frame(
          index: 0,
          timestamp: DateTime(2026, 1, 1, 12),
          events: const [],
        ),
        previous: null,
      );

      expect(
        () => FoldedFrame(
          frame: Frame(
            index: 1,
            timestamp: DateTime(2026, 1, 1, 11),
            events: const [],
          ),
          previous: first,
        ),
        throwsStateError,
      );
    });

    test('requires consecutive indexes', () {
      final first = FoldedFrame(
        frame: Frame.test(index: 0, events: const []),
        previous: null,
      );

      expect(
        () => FoldedFrame(
          frame: Frame.test(index: 2, events: const []),
          previous: first,
        ),
        throwsStateError,
      );
    });

    test('statusOf and hasStateChanges reflect frame events', () {
      final addedProvider = ProviderMeta.test(elementId: 'added');
      final updatedProvider = ProviderMeta.test(elementId: 'updated');
      final disposedProvider = ProviderMeta.test(elementId: 'disposed');
      final frame = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            ProviderContainerAddEvent(
              container: RootCachedObject(CacheId('container')),
              containerId: internals.ContainerId('container'),
              parentIds: const [],
            ),
            ProviderElementAddEvent(
              provider: addedProvider,
              state: ProviderStateRef.test(cacheId: 'state-added'),
              notifier: null,
            ),
            ProviderElementUpdateEvent(
              provider: updatedProvider,
              next: ProviderStateRef.test(cacheId: 'state-updated'),
              notifier: null,
            ),
            ProviderElementDisposeEvent(provider: disposedProvider),
          ],
        ),
        previous: null,
      );

      expect(
        frame.statusOf(internals.ElementId('added')),
        ProviderStatusInFrame.added,
      );
      expect(
        frame.statusOf(internals.ElementId('updated')),
        ProviderStatusInFrame.modified,
      );
      expect(
        frame.statusOf(internals.ElementId('disposed')),
        ProviderStatusInFrame.disposed,
      );
      expect(frame.statusOf(internals.ElementId('missing')), isNull);
      expect(frame.hasStateChanges, isTrue);
    });

    test('hasStateChanges is false for non-state events', () {
      final frame = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            ProviderContainerAddEvent(
              container: RootCachedObject(CacheId('container')),
              containerId: internals.ContainerId('container'),
              parentIds: const [],
            ),
          ],
        ),
        previous: null,
      );

      expect(frame.hasStateChanges, isFalse);
    });
  });

  group('computeElementsForFrame', () {
    test('records newly added elements', () {
      final frame = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            addEvent(
              'provider-1',
              stateId: 'state-1',
              notifierId: 'notifier-1',
            ),
          ],
        ),
        previous: null,
      );

      final elements = computeElementsForFrame(frame);
      final meta = elements[internals.ElementId('provider-1')];

      expect(meta, isNotNull);
      expect(meta!.provider.elementId, internals.ElementId('provider-1'));
      expect(meta.state.state.id.value, 'state-1');
      expect(meta.notifier?.state.id.value, 'notifier-1');
      expect(meta.parents, isEmpty);
      expect(meta.children, isEmpty);
    });

    test('preserves previous dependency graph when state updates', () {
      final dependent = ProviderNodeMeta(
        provider: ProviderMeta.test(elementId: 'child'),
      );
      final initial = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            addEvent('provider-1', stateId: 'state-1'),
            ProviderDependencyChangeEvent(
              elementId: internals.ElementId('provider-1'),
              dependents: {dependent},
              weakDependents: const {},
              dependencies: {internals.ElementId('parent')},
            ),
          ],
        ),
        previous: null,
      );

      final updated = FoldedFrame(
        frame: Frame.test(
          index: 1,
          events: [updateEvent('provider-1', nextId: 'state-2')],
        ),
        previous: initial,
      );

      final meta = updated.elements[internals.ElementId('provider-1')];

      expect(meta, isNotNull);
      expect(meta!.state.state.id.value, 'state-2');
      expect(meta.parents, {internals.ElementId('parent')});
      expect(meta.children, {dependent});
    });

    test('updates dependencies and dependents when graph changes', () {
      final dependent = ProviderNodeMeta(
        provider: ProviderMeta.test(elementId: 'child'),
      );
      final weakDependent = ContainerNodeMeta(
        containerId: internals.ContainerId('container-1'),
      );
      final initial = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [addEvent('provider-1', stateId: 'state-1')],
        ),
        previous: null,
      );
      final changed = FoldedFrame(
        frame: Frame.test(
          index: 1,
          events: [
            ProviderDependencyChangeEvent(
              elementId: internals.ElementId('provider-1'),
              dependents: {dependent},
              weakDependents: {weakDependent},
              dependencies: {
                internals.ElementId('parent-1'),
                internals.ElementId('parent-2'),
              },
            ),
          ],
        ),
        previous: initial,
      );

      final meta = changed.elements[internals.ElementId('provider-1')];

      expect(meta, isNotNull);
      expect(meta!.parents, {
        internals.ElementId('parent-1'),
        internals.ElementId('parent-2'),
      });
      expect(meta.children, {dependent, weakDependent});
    });

    test('throws if dependency changes reference an unknown element', () {
      final frame = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            ProviderDependencyChangeEvent(
              elementId: internals.ElementId('missing'),
              dependents: const {},
              weakDependents: const {},
              dependencies: const {},
            ),
          ],
        ),
        previous: null,
      );

      expect(() => frame.elements, throwsStateError);
    });

    test('ignores dispose events and keeps previous state snapshot', () {
      final initial = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [addEvent('provider-1', stateId: 'state-1')],
        ),
        previous: null,
      );
      final disposed = FoldedFrame(
        frame: Frame.test(index: 1, events: [disposeEvent('provider-1')]),
        previous: initial,
      );

      final meta = disposed.elements[internals.ElementId('provider-1')];

      expect(meta, isNotNull);
      expect(meta!.state.state.id.value, 'state-1');
    });
  });

  group('FrameStepper', () {
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
  });
}
