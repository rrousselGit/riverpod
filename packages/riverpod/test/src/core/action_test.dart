import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../matrix.dart';
import '../utils.dart';

void main() {
  group('action', () {
    test('keeps autoDispose providers active while pending', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      final onDispose = OnDisposeMock();

      final provider = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(onDispose.call);
        return completer.future;
      });

      final future = action(() async {
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

        final future = action(() async => notifier.ref.read(provider.future));

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

    test('deduplicates reads of the same provider within an action', () async {
      final container = ProviderContainer.test();
      var buildCount = 0;
      final provider = Provider.autoDispose((ref) {
        buildCount++;
        return 42;
      });

      final result = action(() async {
        expect(container.read(provider), 42);
        expect(container.read(provider), 42);
        return container.read(provider);
      });

      await expectLater(result, completion(42));
      expect(buildCount, 1);

      await container.pump();

      expect(container.pointerManager.readPointer(provider), isNull);
    });

    test('throws if Ref.watch is used inside an action', () async {
      final container = ProviderContainer.test();
      final notifier = DeferredNotifier<int>((ref, self) => 0);
      final holder = NotifierProvider<DeferredNotifier<int>, int>(
        () => notifier,
      );
      final provider = Provider((ref) => 42);

      container.read(holder);

      await expectLater(
        action(() async => notifier.ref.watch(provider)),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      'closes ProviderContainer.listen subscriptions when the action ends',
      () async {
        final container = ProviderContainer.test();
        final completer = Completer<void>();
        final listener = Listener<int>();
        final dep = StateProvider((ref) => 0);

        final future = action(() async {
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

    test('closes Ref.listen subscriptions when the action ends', () async {
      final container = ProviderContainer.test();
      final completer = Completer<void>();
      final listener = Listener<int>();
      final dep = StateProvider((ref) => 0);
      final notifier = DeferredNotifier<int>((ref, self) => 0);
      final holder = NotifierProvider<DeferredNotifier<int>, int>(
        () => notifier,
      );

      container.read(holder);

      final future = action(() async {
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

  group('voidAction', () {
    test('returns a callback that runs inside action', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      final onDispose = OnDisposeMock();

      final provider = FutureProvider.autoDispose<int>((ref) {
        ref.onDispose(onDispose.call);
        return completer.future;
      });

      final callback = voidAction(() async {
        await container.read(provider.future);
      });

      callback();

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
