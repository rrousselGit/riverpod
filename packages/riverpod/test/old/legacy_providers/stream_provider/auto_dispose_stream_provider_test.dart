import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show InternalProviderContainer;
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose', () {
    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = StreamProvider.autoDispose(
        (ref) => Stream.value(ref.watch(dep)),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      container.listen(provider, (p, n) {});

      await expectLater(container.read(provider.future), completion(42));
      expect(container.read(provider), const AsyncData(42));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
        final dep = StateProvider((ref) => Stream.value(42));
        final provider = StreamProvider.autoDispose((ref) => ref.watch(dep));
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();
        final controller = StreamController<int>();
        addTearDown(controller.close);

        container.listen(provider, (prev, value) {});

        await expectLater(container.read(provider.future), completion(42));
        expect(container.read(provider), const AsyncData<int>(42));

        container.read(dep.notifier).state = controller.stream;
        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(
          listener,
          listener(
            null,
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(42),
              isRefresh: false,
            ),
          ),
        );

        container.read(dep.notifier).state = Stream.value(21);

        verifyNoMoreInteractions(listener);

        await expectLater(container.read(provider.future), completion(21));
        expect(container.read(provider), const AsyncData<int>(21));
      },
    );

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = StreamProvider.autoDispose(
        (ref) => Stream.value(result),
      );

      container.listen(provider, (_, __) {});

      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));

      result = 1;
      expect(
        container.refresh(provider),
        const AsyncLoading<int>().copyWithPrevious(
          const AsyncValue<int>.data(0),
        ),
      );

      expect(await container.read(provider.future), 1);
      expect(container.read(provider), const AsyncValue.data(1));
    });

    test(
      'does not update dependents if the created stream did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = StreamProvider.autoDispose((ref) {
          ref.watch(dep);
          return const Stream<int>.empty();
        });
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue.loading()));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      '.future does not update dependents if the created future did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = StreamProvider.autoDispose((ref) {
          ref.watch(dep);
          return const Stream<int>.empty();
        });
        final listener = Listener<Future<int>>();

        container.listen(provider.future, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(any, any));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);

        // No value were emitted, so the future will fail. Catching the error to
        // avoid false positive.
        unawaited(container.read(provider.future).catchError((Object _) => 0));
      },
    );

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        container.listen(provider, (p, n) {});

        expect(await container.read(provider.future), 0);
        expect(container.read(provider), const AsyncValue.data(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });

      test('when using provider.overrideWithValue', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });

      test('when using provider.overrideWith', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref) => Stream.value(42))],
        );

        container.listen(provider, (p, n) {});

        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });
    });

    test('works', () async {
      var stream = Stream.value(42);
      final onDispose = OnDisposeMock();
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(onDispose.call);
        return stream;
      });
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      final sub = container.listen(
        provider,
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      sub.close();

      await container.pump();

      verifyOnly(onDispose, onDispose());

      stream = Stream.value(21);

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(21)),
      );
    });
  });
}
