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
  group('devtool sessions', () {
    final devtool = RiverpodDevtool.instance;

    tearDown(() => debugTrackProviderHistory = false);

    test('an abandoned session releases frame and terminal values', () {
      fakeAsync((async) {
        final session = devtool.openSession();
        final terminal = devtool.cache(Object(), sessionId: session);
        final frame = devtool.withFrameCache(
          session,
          () => devtool.cacheFrame(Object()),
        );
        async.elapse(const Duration(seconds: 29));
        expect(devtool.getCache(terminal), isNotNull);
        expect(devtool.getCache(frame), isNotNull);
        async.elapse(const Duration(seconds: 1));
        expect(() => devtool.getCache(terminal), throwsStateError);
        expect(() => devtool.getCache(frame), throwsStateError);
        expect(devtool.renewSession(session), isFalse);
        expect(
          () => devtool.cache(Object(), sessionId: session),
          throwsStateError,
        );
        expect(() => devtool.withFrameCache(session, () {}), throwsStateError);
        expect(() => devtool.deleteCache(terminal), returnsNormally);
      });
    });

    test('renewal extends the lease and close releases it immediately', () {
      fakeAsync((async) {
        final session = devtool.openSession();
        final key = devtool.cache(Object(), sessionId: session);
        async.elapse(const Duration(seconds: 20));
        expect(devtool.renewSession(session), isTrue);
        async.elapse(const Duration(seconds: 20));
        expect(devtool.getCache(key), isNotNull);
        devtool.closeSession(session);
        expect(() => devtool.getCache(key), throwsStateError);
        expect(devtool.renewSession(session), isFalse);
        expect(() => devtool.closeSession(session), returnsNormally);
        expect(async.nonPeriodicTimerCount, 0);
      });
    });

    test('renewed sessions also expire when heartbeats stop', () {
      fakeAsync((async) {
        final session = devtool.openSession();
        async.elapse(const Duration(seconds: 20));
        devtool.renewSession(session);
        async.elapse(const Duration(seconds: 29));
        expect(devtool.renewSession(session), isTrue);
        async.elapse(RiverpodDevtool.sessionLeaseDuration);
        expect(devtool.renewSession(session), isFalse);
      });
    });

    test('clients prune and close only their own exported values', () {
      fakeAsync((async) {
        final first = devtool.openSession();
        final second = devtool.openSession();
        final value = Object();
        final firstKey = devtool.withFrameCache(
          first,
          () => devtool.cacheFrame(value),
        );
        final secondKey = devtool.withFrameCache(
          second,
          () => devtool.cacheFrame(value),
        );
        expect(firstKey, isNot(secondKey));
        devtool.withFrameCache(first, () => devtool.cacheFrame(Object()));
        expect(() => devtool.getCache(firstKey), throwsStateError);
        expect(devtool.getCache(secondKey), same(value));
        devtool.closeSession(first);
        expect(devtool.getCache(secondKey), same(value));
        async.elapse(RiverpodDevtool.sessionLeaseDuration);
        expect(() => devtool.getCache(secondKey), throwsStateError);
      });
    });

    test('failed serialization preserves the displayed snapshot', () {
      fakeAsync((async) {
        final session = devtool.openSession();
        final previous = devtool.withFrameCache(
          session,
          () => devtool.cacheFrame(Object()),
        );
        late String partial;
        expect(
          () => devtool.withFrameCache(session, () {
            partial = devtool.cacheFrame(Object());
            throw StateError('serialization failed');
          }),
          throwsStateError,
        );
        expect(devtool.getCache(previous), isNotNull);
        expect(() => devtool.getCache(partial), throwsStateError);
        devtool.closeSession(session);
      });
    });

    test('expiry preserves explicitly recorded history', () {
      fakeAsync((async) {
        debugTrackProviderHistory = true;
        final container = ProviderContainer();
        container.read(Provider((ref) => Object()));
        async.flushMicrotasks();
        final frames = [...devtool.frames];
        final session = devtool.openSession();
        devtool.withFrameCache(session, () => devtool.cacheFrame(Object()));
        async.elapse(RiverpodDevtool.sessionLeaseDuration);
        expect(debugTrackProviderHistory, isTrue);
        expect(devtool.frames, frames);
        expect(devtool.renewSession(session), isFalse);
        container.dispose();
        async.flushMicrotasks();
      });
    });

    test('serialization requires an active client', () {
      expect(() => devtool.cacheFrame(Object()), throwsStateError);
    });
  });

  group('frame history', () {
    final devtool = RiverpodDevtool.instance;
    late String sessionId;

    setUp(() async {
      await _waitForDevtoolEvent();
      debugTrackProviderHistory = false;
      devtool.frames.clear();
      sessionId = devtool.openSession();
    });

    tearDown(() async {
      devtool.closeSession(sessionId);
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

      final cached = devtool.withFrameCache(
        sessionId,
        () => devtool.cacheFrame(Object()),
      );
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
      expect(() => devtool.getCache(cached), throwsStateError);
    });

    test('keeps displayed values until the next snapshot is serialized', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        final provider = NotifierProvider<_TestNotifier, int>(
          _TestNotifier.new,
        );
        container.read(provider);
        async.flushMicrotasks();

        final unchanged = Object();
        final terminalResult = Object();
        final terminalKey = devtool.cache(terminalResult, sessionId: sessionId);
        late String stateKey;
        late String unchangedKey;
        devtool.withFrameCache(sessionId, () {
          stateKey = devtool.cacheFrame(0);
          unchangedKey = devtool.cacheFrame(unchanged);
        });

        container.read(provider.notifier).increment();
        async.flushMicrotasks();
        // The application has advanced, but the devtool still displays frame 0.
        expect(devtool.getCache(stateKey), 0);
        devtool.withFrameCache(sessionId, () {
          devtool.cacheFrame(1);
          expect(devtool.cacheFrame(unchanged), unchangedKey);
        });
        expect(() => devtool.getCache(stateKey), throwsStateError);
        expect(devtool.getCache(unchangedKey), same(unchanged));
        expect(devtool.getCache(terminalKey), same(terminalResult));

        debugTrackProviderHistory = true;
        debugTrackProviderHistory = false;
        expect(() => devtool.getCache(unchangedKey), throwsStateError);
        expect(devtool.getCache(terminalKey), same(terminalResult));
        devtool.deleteCache(terminalKey);
        expect(() => devtool.getCache(terminalKey), throwsStateError);
        container.dispose();
        async.flushMicrotasks();
      });
    });

    test('retains historical cache values only while tracking history', () {
      fakeAsync((async) {
        final container = ProviderContainer();
        async.flushMicrotasks();
        debugTrackProviderHistory = true;
        final historicalKey = devtool.withFrameCache(
          sessionId,
          () => devtool.cacheFrame(0),
        );
        final latestKey = devtool.withFrameCache(
          sessionId,
          () => devtool.cacheFrame(1),
        );
        expect(devtool.getCache(historicalKey), 0);
        expect(devtool.getCache(latestKey), 1);
        debugTrackProviderHistory = false;
        expect(() => devtool.getCache(historicalKey), throwsStateError);
        expect(() => devtool.getCache(latestKey), throwsStateError);
        final nullKey = devtool.withFrameCache(
          sessionId,
          () => devtool.cacheFrame(null),
        );
        expect(devtool.getCache(nullKey), isNull);
        container.dispose();
        async.flushMicrotasks();
        devtool.clearFrameCache();
      });
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

      final devtool = RiverpodDevtool.instance;
      final sessionId = devtool.openSession();
      addTearDown(() => devtool.closeSession(sessionId));
      final (
        providerMetaBytes,
        originMetaBytes,
        simpleEventBytes,
        notifierEventBytes,
      ) = devtool.withFrameCache(
        sessionId,
        () => (
          ProviderMeta.from(simpleElement).toBytes(path: 'provider'),
          OriginMeta.from(simpleElement).toBytes(path: 'origin'),
          ProviderElementAddEvent(simpleElement).toBytes(path: 'simpleEvent'),
          ProviderElementAddEvent(
            notifierElement,
          ).toBytes(path: 'notifierEvent'),
        ),
      );

      expect(providerMetaBytes['provider.creationStackTrace.__present'], true);
      expect(originMetaBytes['origin.creationStackTrace.__present'], true);
      expect(simpleEventBytes['simpleEvent.notifier.__present'], false);
      expect(notifierEventBytes['notifierEvent.notifier.__present'], true);
    });
  });
}
