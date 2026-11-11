import 'package:riverpod/src/internals.dart' as internals;
import 'package:riverpod_devtool_core/src/elements.dart';
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

ProviderElementDisposeEvent disposeEvent(String elementId) {
  return ProviderElementDisposeEvent(
    provider: ProviderMeta.test(elementId: elementId),
  );
}

void main() {
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

    test('removes disposed elements from the frames after their disposal', () {
      final initial = FoldedFrame(
        frame: Frame.test(
          index: 0,
          events: [
            addEvent('disposed', stateId: 'state-1'),
            addEvent('alive'),
          ],
        ),
        previous: null,
      );
      final disposed = FoldedFrame(
        frame: Frame.test(index: 1, events: [disposeEvent('disposed')]),
        previous: initial,
      );
      final after = FoldedFrame(
        frame: Frame.test(index: 2, events: [updateEvent('alive')]),
        previous: disposed,
      );
      final later = FoldedFrame(
        frame: Frame.test(index: 3, events: const []),
        previous: after,
      );

      expect(after.elements.keys, [internals.ElementId('alive')]);
      expect(later.elements.keys, [internals.ElementId('alive')]);
      // Past frames are unaffected, including the one disposing the element,
      // which shows its last state.
      expect(initial.elements, hasLength(2));
      expect(disposed.elements, hasLength(2));
      expect(
        disposed
            .elements[internals.ElementId('disposed')]!
            .state
            .state
            .id
            .value,
        'state-1',
      );
    });

    test(
      'starts anew elements that are created again after their disposal',
      () {
        final id = internals.ElementId('provider-1');
        final initial = FoldedFrame(
          frame: Frame.test(
            index: 0,
            events: [
              addEvent('provider-1'),
              ProviderDependencyChangeEvent(
                elementId: id,
                dependents: const {},
                weakDependents: const {},
                dependencies: {internals.ElementId('parent')},
              ),
            ],
          ),
          previous: null,
        );
        final disposed = FoldedFrame(
          frame: Frame.test(index: 1, events: [disposeEvent('provider-1')]),
          previous: initial,
        );
        final recreated = FoldedFrame(
          frame: Frame.test(
            index: 2,
            events: [addEvent('provider-1', stateId: 'state-2')],
          ),
          previous: disposed,
        );

        final element = recreated.elements[id]!;
        expect(element.state.state.id.value, 'state-2');
        // What the disposed element depended on is not carried over.
        expect(element.parents, isEmpty);
      },
    );
  });

  group('ElementMeta.invalidate', () {
    test('rebuilds the provider in the application', () async {
      final app = await startApp();
      final container = app.container();
      final eval = await container.read(evalProvider.future);
      final isAlive = Disposable();
      await container.increment();
      Future<String?> state() async {
        final counter = await container.element('counterProvider');
        final value = await counter.state.state.read(eval, isAlive: isAlive);
        // Frames may be replaced while their values are being read.
        return value.valueOrNull?.valueAsString;
      }

      Stream<String?> states() {
        return Stream<void>.periodic(
          const Duration(milliseconds: 20),
        ).asyncMap((_) => state());
      }

      await expectLater(states(), emitsThrough('1'));

      await (await container.element(
        'counterProvider',
      )).invalidate(eval, isAlive: isAlive);

      await expectLater(states(), emitsThrough('0'));
    });

    test('fails when the element cannot be read anymore', () async {
      final app = await startApp();
      final container = app.container();
      final counter = await container.element('counterProvider');
      final eval = await container.read(evalProvider.future);
      final gone = ElementMeta(
        provider: ProviderMeta.test(
          elementId: 'gone',
          element: RootCachedObject(CacheId('${eval.sessionId}:gone')),
        ),
        state: counter.state,
        notifier: null,
        children: const {},
        parents: const {},
      );

      await expectLater(
        gone.invalidate(eval, isAlive: Disposable()),
        throwsA(
          isA<Exception>().having(
            (e) => '$e',
            'message',
            contains('no longer retained'),
          ),
        ),
      );
    });
  });
}
