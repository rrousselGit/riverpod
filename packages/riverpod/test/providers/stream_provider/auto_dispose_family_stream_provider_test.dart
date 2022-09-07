import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose.family', () {
    test('supports cacheTime', () async {
      final onDispose = cacheFamily<int, OnDisposeMock>(
        (key) => OnDisposeMock(),
      );
      await fakeAsync((async) async {
        final container = createContainer();
        final provider = StreamProvider.autoDispose.family<int, int>(
          cacheTime: 5 * 1000,
          (ref, value) {
            ref.onDispose(onDispose(value));
            return Stream.value(value);
          },
        );

        final sub = container.listen<Future<int>>(
          provider(42).future,
          (previous, next) {},
        );

        expect(await sub.read(), 42);

        verifyZeroInteractions(onDispose(42));

        sub.close();

        async.elapse(const Duration(seconds: 2));
        await container.pump();

        verifyZeroInteractions(onDispose(42));

        async.elapse(const Duration(seconds: 3));
        await container.pump();

        verifyOnly(onDispose(42), onDispose(42)());
      });
    });

    test('specifies `from` & `argument` for related providers', () {
      final provider = StreamProvider.autoDispose.family<int, int>(
        (ref, _) => Stream.value(0),
      );

      expect(provider(0).from, provider);
      expect(provider(0).argument, 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose
            .family<int, int>((ref, _) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(await container.read(provider(0).stream).first, 0);
        expect(await container.read(provider(0).future), 0);
        expect(container.read(provider(0)), const AsyncData(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider(0)),
          ]),
        );
      });
    });

    test('override', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(42)),
      );
    });

    test('overrideWithProvider', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
      });
      final container = ProviderContainer(
        overrides: [
          provider.overrideWithProvider((a) {
            return StreamProvider.autoDispose((ref) => Stream.value(a * 4));
          }),
        ],
      );
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(
          const AsyncLoading(),
          const AsyncValue.data(84),
        ),
      );
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = StreamProvider.autoDispose.family<int, int>(
        (ref, i) => Stream.value(ref.watch(dep) + i),
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      await expectLater(container.read(provider(10).stream), emits(52));
      await expectLater(container.read(provider(10).future), completion(52));
      expect(container.read(provider(10)), const AsyncData(52));

      expect(root.getAllProviderElements(), isEmpty);
    });
  });
}
