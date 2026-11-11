import 'package:riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool_core/src/frames.dart';
import 'package:riverpod_devtool_core/src/vm_service.dart';
import 'package:test/test.dart';

import '../utils.dart';

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

  group('against a real application', () {
    late TestApp app;
    setUpAll(() async => app = await startApp());

    test('frames start with a snapshot of the mounted providers', () async {
      final container = app.container();
      container.listen(framesProvider, (_, _) {});

      final frames = await container.read(framesProvider.future);

      expect(frames, hasLength(1));
      expect(
        frames.single.elements.values.map(
          (e) => (e.provider.origin.toStringValue, e.provider.argToStringValue),
        ),
        unorderedEquals([
          ('counterProvider', 'null'),
          ('doubleProvider', 'null'),
          ('userProvider', 'john'),
          ('valuesProvider', 'null'),
        ]),
      );
      expect(
        frames.single.elements.values.first.provider.origin.creationStackTrace,
        contains('test/fixtures/app.dart'),
      );
    });

    test('sync includes the changes that were just made', () async {
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);
      Future<String?> state() async {
        final frames = container.read(framesProvider).requireValue;
        final state = frames.last.elements[counter.provider.elementId]!.state;
        final value = await state.state.read(eval, isAlive: Disposable());
        return value.require.instance.valueAsString;
      }

      final before = int.parse((await state())!);
      await container.increment();
      await container.read(framesProvider.notifier).sync();

      expect(await state(), '${before + 1}');
    });

    test('time travel records a frame per change until stopped', () async {
      final container = app.container();
      container.listen(selectedFrameProvider, (_, _) {});
      container.listen(timeTravelProvider, (_, _) {});
      final counter = await container.element('counterProvider');
      final counterId = counter.provider.elementId;
      expect(await container.read(timeTravelProvider.future), isFalse);

      // Without time travel, changes replace the snapshot.
      await container.increment();
      final snapshot = await container.waitFor(
        framesProvider,
        (frames) => frames.last.elements[counterId]?.state != counter.state,
      );
      expect(snapshot, hasLength(1));
      expect(container.read(selectedFrameProvider)?.id, FrameId(0));

      await container.read(timeTravelProvider.notifier).setEnabled(true);
      expect(await container.read(timeTravelProvider.future), isTrue);

      await container.increment();
      final frames = await container.waitFor(
        framesProvider,
        (frames) => frames.length == 2,
      );
      expect(frames.last.previous, frames.first);
      expect(frames.last.statusOf(counterId), ProviderStatusInFrame.modified);
      expect(frames.first.statusOf(counterId), ProviderStatusInFrame.modified);
      // The selection follows the latest frame, until an older one is picked.
      expect(container.read(selectedFrameProvider)?.id, FrameId(1));
      container.read(selectedFrameIdProvider.notifier).state = FrameId(0);
      await container.increment();
      await container.waitFor(framesProvider, (frames) => frames.length == 3);
      expect(container.read(selectedFrameProvider)?.id, FrameId(0));

      await container.read(timeTravelProvider.notifier).setEnabled(false);
      final compacted = await container.waitFor(
        framesProvider,
        (frames) => frames.length == 1,
      );
      expect(compacted.single.previous, isNull);
      expect(await container.read(timeTravelProvider.future), isFalse);
      expect(container.read(selectedFrameProvider)?.id, FrameId(0));
    });
  });
}
