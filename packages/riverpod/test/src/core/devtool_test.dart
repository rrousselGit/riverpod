import 'package:fake_async/fake_async.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart' hide debugTrackProviderHistory;
import 'package:test/test.dart';

final class _TestNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

Future<void> _waitForDevtoolEvent() => Future<void>.delayed(Duration.zero);

void main() {
  group('frame history', () {
    final devtool = RiverpodDevtool.instance;

    setUp(() async {
      await _waitForDevtoolEvent();
      debugTrackProviderHistory = false;
      devtool.frames.clear();
    });

    tearDown(() async {
      debugTrackProviderHistory = false;
      await _waitForDevtoolEvent();
      devtool.frames.clear();
    });

    test('keeps current states and releases disposed providers', () async {
      final container = ProviderContainer.test();
      final provider = NotifierProvider<_TestNotifier, int>(_TestNotifier.new);
      final unchanged = Provider((ref) => Object());
      final unchangedValue = container.read(unchanged);
      container.read(provider);
      await _waitForDevtoolEvent();
      final initialFrame = devtool.frames.single;

      container.read(provider.notifier).increment();
      await _waitForDevtoolEvent();

      final snapshot = devtool.frames.single;
      expect(snapshot, isNot(same(initialFrame)));
      expect(snapshot.index, 0);
      expect(
        snapshot.events
            .whereType<ProviderElementUpdateEvent>()
            .single
            .next
            .state,
        1,
      );
      expect(
        snapshot.events.whereType<ProviderElementAddEvent>().single.state.state,
        same(unchangedValue),
      );

      container.dispose();
      await _waitForDevtoolEvent();
      expect(devtool.frames.single.events, isEmpty);
    });

    test('can enable history and release it immediately', () async {
      final container = ProviderContainer.test();
      final provider = NotifierProvider<_TestNotifier, int>(_TestNotifier.new);
      container.read(provider);
      await _waitForDevtoolEvent();
      final baseline = devtool.frames.single;

      debugTrackProviderHistory = true;
      container.read(provider.notifier).increment();
      await _waitForDevtoolEvent();
      container.read(provider.notifier).increment();
      await _waitForDevtoolEvent();
      expect(devtool.frames.map((frame) => frame.index), [0, 1, 2]);
      expect(devtool.frames.first, same(baseline));

      debugTrackProviderHistory = false;
      expect(devtool.frames.single.index, 0);
      expect(
        devtool.frames.single.events
            .whereType<ProviderElementUpdateEvent>()
            .single
            .next
            .state,
        2,
      );
    });

    test(
      'stop/start while a frame is pending keeps chronological timestamps',
      () {
        fakeAsync((async) {
          final container = ProviderContainer();
          final provider = NotifierProvider<_TestNotifier, int>(
            _TestNotifier.new,
          );
          container.read(provider);
          async.flushMicrotasks();
          final baselineTimestamp = devtool.frames.single.timestamp;
          debugTrackProviderHistory = true;
          container.read(provider.notifier).increment();
          debugTrackProviderHistory = false;
          expect(devtool.frames.single.timestamp, baselineTimestamp);
          debugTrackProviderHistory = true;
          async.flushMicrotasks();
          expect(devtool.frames.map((frame) => frame.index), [0, 1]);
          expect(
            devtool.frames.last.timestamp.isBefore(
              devtool.frames.first.timestamp,
            ),
            isFalse,
          );
          debugTrackProviderHistory = false;
          container.dispose();
          async.flushMicrotasks();
        });
      },
    );

    test('disposal before delivery does not leave a pending frame', () async {
      final container = ProviderContainer.test();
      container.read(Provider((ref) => Object()));
      container.dispose();
      await _waitForDevtoolEvent();
      expect(devtool.frames.single.events, isEmpty);

      final next = ProviderContainer.test();
      next.read(Provider((ref) => 42));
      await _waitForDevtoolEvent();
      expect(
        devtool.frames.single.events
            .whereType<ProviderElementAddEvent>()
            .single
            .state
            .state,
        42,
      );
      next.dispose();
    });

    test('records from startup when explicitly enabled', () async {
      debugTrackProviderHistory = true;
      final container = ProviderContainer.test();
      await _waitForDevtoolEvent();
      container.dispose();
      await _waitForDevtoolEvent();
      expect(devtool.frames.map((frame) => frame.index), [0, 1]);
      expect(
        devtool.frames.last.events.single,
        isA<ProviderContainerDisposeEvent>(),
      );
    });
  });

  group('ProviderDependencyChangeEvent', () {
    test('maps weakDependents from element.weakDependents', () {
      final container = ProviderContainer.test();
      final provider = Provider((ref) => 0);
      final dependent = Provider(
        name: 'dependent',
        (ref) => ref.watch(provider),
      );
      final weakDependent = Provider(name: 'weakDependent', (ref) {
        ref.listen(provider, weak: true, (previous, value) {});
      });

      final weakSubscription = container.listen(
        provider.select((value) => value),
        weak: true,
        (previous, value) {},
      );
      container.read(dependent);
      container.read(weakDependent);

      final providerElement = container.readProviderElement(provider);
      final event = ProviderDependencyChangeEvent(providerElement);

      final dependentElement = container.readProviderElement(dependent);
      final weakDependentElement = container.readProviderElement(weakDependent);

      expect(
        event.dependents.cast<ProviderNodeMeta>().map(
          (e) => e.provider.element,
        ),
        [dependentElement],
      );
      expect(event.weakDependents, [
        isA<ContainerNodeMeta>(),
        isA<ProviderNodeMeta>().having(
          (e) => e.provider.element,
          'provider element',
          weakDependentElement,
        ),
      ]);
    });
  });

  group('generated devtool bytes', () {
    test('writes presence markers for nullable fields', () {
      final previousDebugTrackProviderCreation = debugTrackProviderCreation;
      debugTrackProviderCreation = true;
      addTearDown(
        () => debugTrackProviderCreation = previousDebugTrackProviderCreation,
      );

      final simpleProvider = Provider((ref) => 0);
      final notifierProvider = NotifierProvider<_TestNotifier, int>(
        _TestNotifier.new,
      );
      final container = ProviderContainer.test();

      container.read(simpleProvider);
      container.read(notifierProvider);

      final simpleElement = container.readProviderElement(simpleProvider);
      final notifierElement = container.readProviderElement(notifierProvider);

      final providerMetaBytes = ProviderMeta.from(
        simpleElement,
      ).toBytes(path: 'provider');
      final originMetaBytes = OriginMeta.from(
        simpleElement,
      ).toBytes(path: 'origin');
      final simpleEventBytes = ProviderElementAddEvent(
        simpleElement,
      ).toBytes(path: 'simpleEvent');
      final notifierEventBytes = ProviderElementAddEvent(
        notifierElement,
      ).toBytes(path: 'notifierEvent');

      expect(providerMetaBytes['provider.creationStackTrace.__present'], true);
      expect(originMetaBytes['origin.creationStackTrace.__present'], true);
      expect(simpleEventBytes['simpleEvent.notifier.__present'], false);
      expect(notifierEventBytes['notifierEvent.notifier.__present'], true);
    });
  });
}
