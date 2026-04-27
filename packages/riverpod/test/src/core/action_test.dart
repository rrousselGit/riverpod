import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  group('run', () {
    test('keeps autoDispose providers active while pending', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      final onDispose = OnDisposeMock();

      final provider = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(onDispose.call);
        return completer.future;
      });

      final future = run(() async {
        return container.read(provider.future);
      });

      final element = container.readProviderElement(provider);
      expect(element.isActive, true);

      await container.pump();

      expect(element.isActive, true);
      verifyZeroInteractions(onDispose);

      completer.complete(42);

      await expectLater(future, completion(42));
      await container.pump();

      verifyOnly(onDispose, onDispose());
      expect(container.pointerManager.readPointer(provider), isNull);
    });

    test(
      'keeps autoDispose providers active while pending with Ref.read',
      () async {
        final container = ProviderContainer.test();
        final completer = Completer<int>();
        final onDispose = OnDisposeMock();
        final notifier = DeferredNotifier<int>((ref, self) {
          return 0;
        });

        final holder = NotifierProvider<DeferredNotifier<int>, int>(
          () => notifier,
        );
        final provider = FutureProvider.autoDispose<int>((ref) {
          ref.onDispose(onDispose.call);
          return completer.future;
        });

        container.read(holder);

        final future = run(() async => notifier.ref.read(provider.future));

        final element = container.readProviderElement(provider);
        expect(element.isActive, true);

        await container.pump();

        expect(element.isActive, true);
        verifyZeroInteractions(onDispose);

        completer.complete(42);

        await expectLater(future, completion(42));
        await container.pump();

        verifyOnly(onDispose, onDispose());
        expect(container.pointerManager.readPointer(provider), isNull);
      },
    );

    test('deduplicates reads of the same provider within a run', () async {
      final container = ProviderContainer.test();
      var buildCount = 0;
      final provider = Provider.autoDispose((ref) {
        buildCount++;
        return 42;
      });

      final result = run(() async {
        expect(container.read(provider), 42);
        expect(container.read(provider), 42);
        return container.read(provider);
      });

      await expectLater(result, completion(42));
      expect(buildCount, 1);

      await container.pump();

      expect(container.pointerManager.readPointer(provider), isNull);
    });

    test('throws if Ref.watch is used inside a run', () async {
      final container = ProviderContainer.test();
      final notifier = DeferredNotifier<int>((ref, self) => 0);
      final holder = NotifierProvider<DeferredNotifier<int>, int>(
        () => notifier,
      );
      final provider = Provider((ref) => 42);

      container.read(holder);

      await expectLater(
        run(() async => notifier.ref.watch(provider)),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      'does not treat Ref.watch from providers initialized in a run as part of the run',
      () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 42);
        final provider = Provider.autoDispose((ref) => ref.watch(dep));

        await expectLater(
          run(() async => container.read(provider)),
          completion(42),
        );

        await container.pump();

        expect(container.pointerManager.readPointer(provider), isNull);
      },
    );

    test(
      'does not treat Ref.read from providers initialized in a run as part of the run',
      () async {
        final container = ProviderContainer.test();
        final providerCompleter = Completer<int>();
        final runCompleter = Completer<void>();
        final onDispose = OnDisposeMock();

        final dep = FutureProvider.autoDispose<int>((ref) {
          ref.onDispose(onDispose.call);
          return providerCompleter.future;
        });
        final provider = FutureProvider.autoDispose<Future<int>>(
          (ref) => ref.read(dep.future),
        );

        final future = run(() async {
          container.read(provider);
          await runCompleter.future;
        });

        await container.pump();

        verifyOnly(onDispose, onDispose());
        expect(container.pointerManager.readPointer(provider), isNotNull);
        expect(container.pointerManager.readPointer(dep), isNull);

        runCompleter.complete();
        await future;

        providerCompleter.complete(42);
      },
    );

    test(
      'does not close Ref.listen from providers initialized in a run when the run ends',
      () async {
        final container = ProviderContainer.test();
        final runCompleter = Completer<void>();
        final listener = Listener<int>();
        final dep = StateProvider((ref) => 0);

        final provider = Provider.autoDispose((ref) {
          ref.listen(dep, listener.call);
          return 42;
        });

        final future = run(() async {
          expect(container.read(provider), 42);
          await runCompleter.future;
        });

        await container.pump();

        final keepAlive = container.listen(provider, (_, _) {});

        runCompleter.complete();
        await future;

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(0, 1));

        keepAlive.close();
      },
    );

    test(
      'closes ProviderContainer.listen subscriptions when the run ends',
      () async {
        final container = ProviderContainer.test();
        final completer = Completer<void>();
        final listener = Listener<int>();
        final dep = StateProvider((ref) => 0);

        final future = run(() async {
          container.listen(dep, listener.call);
          await completer.future;
        });

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(0, 1));

        completer.complete();
        await future;

        container.read(dep.notifier).state++;

        verifyNoMoreInteractions(listener);
      },
    );

    test('closes Ref.listen subscriptions when the run ends', () async {
      final container = ProviderContainer.test();
      final completer = Completer<void>();
      final listener = Listener<int>();
      final dep = StateProvider((ref) => 0);
      final notifier = DeferredNotifier<int>((ref, self) => 0);
      final holder = NotifierProvider<DeferredNotifier<int>, int>(
        () => notifier,
      );

      container.read(holder);

      final future = run(() async {
        notifier.ref.listen(dep, listener.call);
        await completer.future;
      });

      container.read(dep.notifier).state++;

      verifyOnly(listener, listener(0, 1));

      completer.complete();
      await future;

      container.read(dep.notifier).state++;

      verifyNoMoreInteractions(listener);
    });
  });

  group('voidRun', () {
    test('returns a callback that runs inside run', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      final onDispose = OnDisposeMock();

      final provider = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(onDispose.call);
        return completer.future;
      });

      final callback = voidRun(() async {
        await container.read(provider.future);
      });

      unawaited(callback());

      final element = container.readProviderElement(provider);
      expect(element.isActive, true);

      await container.pump();

      verifyZeroInteractions(onDispose);
      expect(element.isActive, true);

      completer.complete(21);
      await Future<void>.delayed(Duration.zero);
      await container.pump();

      verifyOnly(onDispose, onDispose());
      expect(container.pointerManager.readPointer(provider), isNull);
    });
  });
}
