import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose', () {
    test('can read and set current AsyncValue', () async {
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();
      late AutoDisposeStreamProviderRef<int> ref;
      final provider = StreamProvider.autoDispose<int>((r) {
        ref = r;
        return Stream.value(0);
      });

      container.listen(provider, listener);

      await container.read(provider.future);
      expect(ref.state, const AsyncData<int>(0));
      verifyOnly(
        listener,
        listener(
          const AsyncLoading(),
          const AsyncData(0),
        ),
      );

      ref.state = const AsyncLoading<int>();

      expect(
        ref.state,
        const AsyncData<int>(0, isRefreshing: true),
      );

      verifyOnly(
        listener,
        listener(
          const AsyncData(0),
          const AsyncData<int>(0, isRefreshing: true),
        ),
      );
    });

    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0);
      final provider = StreamProvider.autoDispose(
        (ref) => Stream.value(ref.watch(dep)),
        dependencies: [dep],
      );
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      await expectLater(container.read(provider.stream), emits(42));
      await expectLater(container.read(provider.future), completion(42));
      expect(container.read(provider), const AsyncData(42));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test(
        'when going from AsyncLoading to AsyncLoading, does not notify listeners',
        () async {
      final dep = StateProvider((ref) => Stream.value(42));
      final provider =
          StreamProvider.autoDispose((ref) => ref.watch(dep.state).state);
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, (prev, value) {});

      await expectLater(
        container.read(provider.stream),
        emits(42),
      );
      expect(
        container.read(provider),
        const AsyncData<int>(42),
      );

      final controller = StreamController<int>();
      addTearDown(controller.close);
      container.read(dep.state).state = controller.stream;

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(
        listener,
        listener(null, const AsyncData<int>(42, isRefreshing: true)),
      );

      container.read(dep.state).state = Stream.value(21);

      verifyNoMoreInteractions(listener);

      await expectLater(
        container.read(provider.stream),
        emits(21),
      );
      expect(
        container.read(provider),
        const AsyncData<int>(21),
      );
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = createContainer();
      final provider =
          StreamProvider.autoDispose((ref) => Stream.value(result));

      container.listen(provider, (_, __) {});

      expect(container.read(provider.stream), emits(0));
      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));

      result = 1;
      expect(
        container.refresh(provider),
        const AsyncValue<int>.data(0, isRefreshing: true),
      );

      expect(container.read(provider.stream), emits(1));
      expect(await container.read(provider.future), 1);
      expect(container.read(provider), const AsyncValue.data(1));
    });

    test('does not update dependents if the created stream did not change',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider.autoDispose((ref) {
        ref.watch(dep);
        return const Stream<int>.empty();
      });
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      container.read(dep.state).state++;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    test(
        '.stream does not update dependents if the created stream did not change',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider.autoDispose((ref) {
        ref.watch(dep);
        return const Stream<int>.empty();
      });
      final listener = Listener<Stream<int>>();

      container.listen(provider.stream, listener, fireImmediately: true);

      verifyOnly(listener, listener(any, any));

      container.read(dep.state).state++;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });

    test(
        '.future does not update dependents if the created future did not change',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider.autoDispose((ref) {
        ref.watch(dep);
        return const Stream<int>.empty();
      });
      final listener = Listener<Future<int>>();

      container.listen(provider.future, listener, fireImmediately: true);

      verifyOnly(listener, listener(any, any));

      container.read(dep.state).state++;
      await container.pump();

      verifyNoMoreInteractions(listener);

      // No value were emitted, so the future will fail. Catching the error to
      // avoid false positive.
      // ignore: unawaited_futures, avoid_types_on_closure_parameters
      container.read(provider.future).catchError((Object _) => 0);
    });

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [provider]);

        expect(await container.read(provider.stream).first, 0);
        expect(await container.read(provider.future), 0);
        expect(container.read(provider), const AsyncValue.data(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.future),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });

      test('when using provider.overrideWithValue', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        expect(await container.read(provider.stream).first, 42);
        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.future),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });

      test('when using provider.overrideWithProvider', () async {
        final provider = StreamProvider.autoDispose((ref) => Stream.value(0));
        final root = createContainer();
        final container = createContainer(parent: root, overrides: [
          provider.overrideWithProvider(
            FutureProvider.autoDispose((ref) async => 42),
          ),
        ]);

        expect(await container.read(provider.stream).first, 42);
        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.future),
            isA<ProviderElementBase>()
                .having((e) => e.origin, 'origin', provider.stream),
          ]),
        );
      });
    });

    test('works', () async {
      var stream = Stream.value(42);
      final onDispose = OnDisposeMock();
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(onDispose);
        return stream;
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      final sub = container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      sub.close();

      await container.pump();

      verifyOnly(onDispose, onDispose());

      stream = Stream.value(21);

      container.listen(
        provider,
        listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(21)),
      );
    });
  });
}
