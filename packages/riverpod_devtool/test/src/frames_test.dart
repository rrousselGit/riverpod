import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool/src/elements.dart';
import 'package:riverpod_devtool/src/frames.dart';
import 'package:riverpod_devtool/src/vm_service.dart';

import '../test_helpers.dart';

ProviderElementAddEvent addEvent(
  String elementId, {
  String stateId = 'state',
  String? notifierId,
}) {
  return ProviderElementAddEvent(
    provider: providerMeta(elementId: elementId),
    state: stateRef(stateId),
    notifier: notifierId == null ? null : stateRef(notifierId),
  );
}

ProviderElementUpdateEvent updateEvent(
  String elementId, {
  String nextId = 'next',
  String? notifierId,
}) {
  return ProviderElementUpdateEvent(
    provider: providerMeta(elementId: elementId),
    next: stateRef(nextId),
    notifier: notifierId == null ? null : stateRef(notifierId),
  );
}

ProviderElementDisposeEvent disposeEvent(String elementId) {
  return ProviderElementDisposeEvent(
    provider: providerMeta(elementId: elementId),
  );
}

void main() {
  group('FoldedFrame', () {
    test('requires the first frame to start at index zero', () {
      expect(
        () => FoldedFrame(
          frame: devtoolFrame(index: 1, events: const []),
          previous: null,
        ),
        throwsStateError,
      );
    });

    test('requires timestamps to stay chronological', () {
      final first = FoldedFrame(
        frame: devtoolFrame(
          index: 0,
          timestamp: DateTime(2026, 1, 1, 12),
          events: const [],
        ),
        previous: null,
      );

      expect(
        () => FoldedFrame(
          frame: devtoolFrame(
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
        frame: devtoolFrame(index: 0, events: const []),
        previous: null,
      );

      expect(
        () => FoldedFrame(
          frame: devtoolFrame(index: 2, events: const []),
          previous: first,
        ),
        throwsStateError,
      );
    });

    test('statusOf and hasStateChanges reflect frame events', () {
      final addedProvider = providerMeta(elementId: 'added');
      final updatedProvider = providerMeta(elementId: 'updated');
      final disposedProvider = providerMeta(elementId: 'disposed');
      final frame = FoldedFrame(
        frame: devtoolFrame(
          index: 0,
          events: [
            ProviderContainerAddEvent(
              container: cacheObject('container'),
              containerId: internals.ContainerId('container'),
              parentIds: const [],
            ),
            ProviderElementAddEvent(
              provider: addedProvider,
              state: stateRef('state-added'),
              notifier: null,
            ),
            ProviderElementUpdateEvent(
              provider: updatedProvider,
              next: stateRef('state-updated'),
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
        frame: devtoolFrame(
          index: 0,
          events: [
            ProviderContainerAddEvent(
              container: cacheObject('container'),
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
        frame: devtoolFrame(
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
        provider: providerMeta(elementId: 'child'),
      );
      final initial = FoldedFrame(
        frame: devtoolFrame(
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
        frame: devtoolFrame(
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
        provider: providerMeta(elementId: 'child'),
      );
      final weakDependent = ContainerNodeMeta(
        containerId: internals.ContainerId('container-1'),
      );
      final initial = FoldedFrame(
        frame: devtoolFrame(
          index: 0,
          events: [addEvent('provider-1', stateId: 'state-1')],
        ),
        previous: null,
      );
      final changed = FoldedFrame(
        frame: devtoolFrame(
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
        frame: devtoolFrame(
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
        frame: devtoolFrame(
          index: 0,
          events: [addEvent('provider-1', stateId: 'state-1')],
        ),
        previous: null,
      );
      final disposed = FoldedFrame(
        frame: devtoolFrame(index: 1, events: [disposeEvent('provider-1')]),
        previous: initial,
      );

      final meta = disposed.elements[internals.ElementId('provider-1')];

      expect(meta, isNotNull);
      expect(meta!.state.state.id.value, 'state-1');
    });
  });
}
