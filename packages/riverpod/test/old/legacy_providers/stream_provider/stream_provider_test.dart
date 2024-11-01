// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElement;
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('supports overrideWith', () {
    final provider = StreamProvider<int>(
      (ref) {
        ref.state = const AsyncData(0);
        return Stream.value(1);
      },
    );
    final autoDispose = StreamProvider.autoDispose<int>(
      (ref) {
        ref.state = const AsyncData(0);
        return Stream.value(1);
      },
    );
    final container = ProviderContainer.test(
      overrides: [
        provider.overrideWith((ref) {
          ref.state = const AsyncData(42);
          return Stream.value(43);
        }),
        autoDispose.overrideWith((ref) {
          ref.state = const AsyncData(84);
          return Stream.value(85);
        }),
      ],
    );

    expect(container.read(provider).value, 42);
    expect(container.read(autoDispose).value, 84);
  });

  test('supports family overrideWith', () {
    final family = StreamProvider.family<String, int>((ref, arg) {
      ref.state = AsyncData('0 $arg');
      return Stream.value('1 $arg');
    });
    final autoDisposeFamily = StreamProvider.autoDispose.family<String, int>(
      (ref, arg) {
        ref.state = AsyncData('0 $arg');
        return Stream.value('1 $arg');
      },
    );
    final container = ProviderContainer.test(
      overrides: [
        family.overrideWith(
          (ref, int arg) {
            ref.state = AsyncData('42 $arg');
            return Stream.value('43 $arg');
          },
        ),
        autoDisposeFamily.overrideWith(
          (ref, int arg) {
            ref.state = AsyncData('84 $arg');
            return Stream.value('85 $arg');
          },
        ),
      ],
    );

    expect(container.read(family(10)).value, '42 10');
    expect(container.read(autoDisposeFamily(10)).value, '84 10');
  });

  test('Emits AsyncLoading before the create function is executed', () async {
    final container = ProviderContainer.test();
    late AsyncValue<int> state;
    final provider = StreamProvider<int>((ref) {
      state = ref.state;
      return Stream.value(0);
    });

    container.listen(provider, (p, n) {});

    expect(state, const AsyncLoading<int>());

    await container.read(provider.future);
    container.refresh(provider);

    expect(
      state,
      const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(0)),
    );
  });

  group('When going back to AsyncLoading', () {
    test(
        'sets isRefreshing to true if triggered by a ref.invalidate/ref.refresh',
        () async {
      final container = ProviderContainer.test();
      var count = 0;
      final provider = StreamProvider((ref) => Stream.value(count++));

      container.listen(provider, (p, n) {});

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      expect(
        container.refresh(provider),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(0)),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));

      container.invalidate(provider);

      expect(
        container.read(provider),
        const AsyncLoading<int>().copyWithPrevious(const AsyncData(1)),
      );
      await expectLater(container.read(provider.future), completion(2));
      expect(container.read(provider), const AsyncData(2));
    });

    test('does not set isRefreshing if triggered by a dependency change',
        () async {
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider((ref) => Stream.value(ref.watch(dep)));

      container.listen(provider, (p, n) {});

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      container.read(dep.notifier).state++;
      expect(
        container.read(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));
    });

    test(
        'does not set isRefreshing if both triggered by a dependency change and ref.refresh',
        () async {
      final container = ProviderContainer.test();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider((ref) => Stream.value(ref.watch(dep)));

      container.listen(provider, (p, n) {});

      await expectLater(container.read(provider.future), completion(0));
      expect(container.read(provider), const AsyncData(0));

      container.read(dep.notifier).state++;
      expect(
        container.refresh(provider),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      );

      await expectLater(container.read(provider.future), completion(1));
      expect(container.read(provider), const AsyncData(1));
    });
  });

  test('can read and set current AsyncValue', () async {
    final container = ProviderContainer.test();
    final listener = Listener<AsyncValue<int>>();
    late Ref ref;
    final provider = StreamProvider<int>((r) {
      ref = r;
      return Stream.value(0);
    });

    container.listen(provider, listener.call);
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
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(0), isRefresh: false),
    );

    verifyOnly(
      listener,
      listener(
        const AsyncData(0),
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(0), isRefresh: false),
      ),
    );
  });

  test('can be auto-scoped', () async {
    final dep = Provider(
      (ref) => 0,
      dependencies: const [],
    );
    final provider = StreamProvider(
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
    final provider = StreamProvider((ref) => ref.watch(dep));
    final container = ProviderContainer.test();
    final listener = Listener<AsyncValue<int>>();
    final controller = StreamController<int>();
    addTearDown(controller.close);

    container.listen(provider, (p, n) {});
    await expectLater(
      container.read(provider.future),
      completion(42),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(42),
    );

    container.read(dep.notifier).state = controller.stream;
    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(
      listener,
      listener(
        null,
        const AsyncLoading<int>()
            .copyWithPrevious(const AsyncData(42), isRefresh: false),
      ),
    );

    container.read(dep.notifier).state = Stream.value(21);

    verifyNoMoreInteractions(listener);

    await expectLater(
      container.read(provider.future),
      completion(21),
    );
    expect(
      container.read(provider),
      const AsyncData<int>(21),
    );
  });

  test('can be refreshed', () async {
    var result = 0;
    final container = ProviderContainer.test();
    final provider = StreamProvider((ref) => Stream.value(result));

    container.listen(provider, (p, n) {});
    expect(await container.read(provider.future), 0);
    expect(container.read(provider), const AsyncValue.data(0));

    result = 1;
    expect(
      container.refresh(provider),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(0)),
    );

    expect(await container.read(provider.future), 1);
    expect(container.read(provider), const AsyncValue.data(1));
  });

  group('scoping an override overrides all the associated sub-providers', () {
    test('when passing the provider itself', () async {
      final provider = StreamProvider(
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
      final provider = StreamProvider(
        (ref) => Stream.value(0),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ],
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

    test('when using provider.overrideWith', () async {
      final provider = StreamProvider(
        (ref) => Stream.value(0),
        dependencies: const [],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [
          provider.overrideWith((ref) => Stream.value(42)),
        ],
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

  test('Loading to data', () {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    addTearDown(() => controller.close);
    final provider = StreamProvider((ref) => controller.stream);

    container.listen(provider, (p, n) {});

    expect(container.read(provider), const AsyncValue<int>.loading());

    controller.add(42);

    expect(container.read(provider), const AsyncValue<int>.data(42));
  });

  test('Loading to error', () {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    addTearDown(() => controller.close);
    final provider = StreamProvider((ref) => controller.stream);

    container.listen(provider, (p, n) {});

    expect(container.read(provider), const AsyncValue<int>.loading());

    final stack = StackTrace.current;
    controller.addError(42, stack);

    expect(
      container.read(provider),
      AsyncValue<int>.error(42, stack),
    );
  });

  group('.future', () {
    final provider = StreamProvider<int>((ref) async* {});

    test(
        'throws StateError if the provider is disposed before a value was emitted',
        () async {
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWithValue(const AsyncLoading()),
        ],
      );

      final future = container.read(provider.future);

      container.dispose();

      await expectLater(
        future,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            equalsIgnoringHashCodes(
              'The provider StreamProvider<int>#00000 was disposed during loading state, '
              'yet no value could be emitted.',
            ),
          ),
        ),
      );
    });

    test('supports loading then error then loading', () async {
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWithValue(const AsyncLoading()),
        ],
      );

      var future = container.read(provider.future);

      final error = Error();

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
      ]);

      container.listen(provider, (p, n) {});
      expect(container.read(provider.future), future);

      await expectLater(future, throwsA(error));
      expect(await future.stackTrace, StackTrace.empty);

      final error2 = Error();

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      future = container.read(provider.future);

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error2, StackTrace.empty)),
      ]);

      expect(container.read(provider.future), future);

      await expectLater(future, throwsA(error2));
      expect(await future.stackTrace, StackTrace.empty);
    });

    test('supports loading then error then another error', () async {
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWithValue(const AsyncLoading()),
        ],
      );

      container.listen(provider, (p, n) {});
      var future = container.read(provider.future);

      final error = Error();

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
      ]);

      expect(container.read(provider.future), future);

      await expectLater(future, throwsA(error));
      expect(await future.stackTrace, StackTrace.empty);

      final error2 = Error();

      // error without passing by an intermediary loading state
      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error2, StackTrace.empty)),
      ]);

      future = container.read(provider.future);

      await expectLater(future, throwsA(error2));
      expect(await future.stackTrace, StackTrace.empty);
    });

    test('supports loading then data then loading', () async {
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWithValue(const AsyncLoading()),
        ],
      );

      container.listen(provider, (p, n) {});
      var future = container.read(provider.future);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(container.read(provider.future), future);
      await expectLater(future, completion(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      future = container.read(provider.future);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      expect(container.read(provider.future), future);
      await expectLater(future, completion(21));
    });

    test('supports loading then data then another data', () async {
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWithValue(const AsyncLoading()),
        ],
      );

      container.listen(provider, (p, n) {});
      var future = container.read(provider.future);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(container.read(provider.future), future);
      await expectLater(future, completion(42));

      // data without passing by an intermediary loading state
      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      future = container.read(provider.future);

      await expectLater(future, completion(21));
    });
  });

  test('does not filter identical values', () async {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    addTearDown(() => controller.close);
    final provider = StreamProvider((ref) => controller.stream);

    final sub = container.listen(provider, (_, __) {});

    expect(sub.read(), const AsyncValue<int>.loading());

    controller.add(42);
    await container.pump();

    expect(sub.read(), const AsyncValue<int>.data(42));

    controller.add(42);
    await container.pump();

    expect(sub.read(), const AsyncValue<int>.data(42));
  });

  test('throwing inside "create" result in an AsyncValue.error', () {
    final container = ProviderContainer.test();

    // ignore: only_throw_errors
    final provider = StreamProvider<int>((ref) => throw 42);

    expect(
      container.read(provider),
      isA<AsyncError<int>>().having((s) => s.error, 'error', 42),
    );
  });

  test('does not update dependents if the created stream did not change',
      () async {
    final container = ProviderContainer.test();

    final dep = StateProvider((ref) => 0);
    final provider = StreamProvider((ref) {
      ref.watch(dep);
      return const Stream<int>.empty();
    });
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue.loading()));

    container.read(dep.notifier).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  test(
      '.future does not update dependents if the created future did not change',
      () async {
    final container = ProviderContainer.test();

    final dep = StateProvider((ref) => 0);

    final provider = StreamProvider((ref) {
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
  });

  group('overrideWithValue(T)', () {
    test(
        'when overridden with an error but provider.stream is not listened to, it should not emit an error to the zone',
        () async {
      final error = Error();
      final stream = StreamProvider<int>((ref) => const Stream.empty());

      final container = ProviderContainer(
        overrides: [
          stream.overrideWithValue(AsyncValue.error(error, StackTrace.empty)),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(stream),
        AsyncValue<int>.error(error, StackTrace.empty),
      );
    });
  });

  test('StreamProvider.family', () async {
    final provider = StreamProvider.family<String, int>((ref, a) {
      return Stream.value('$a');
    });
    final container = ProviderContainer.test();

    container.listen(provider(0), (p, n) {});

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await container.pump();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('0'),
    );
  });

  test('can specify name', () {
    final provider = StreamProvider(
      (_) => const Stream<int>.empty(),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = StreamProvider((_) => const Stream<int>.empty());

    expect(provider2.name, isNull);
  });

  test('subscribe exposes loading synchronously then value on change',
      () async {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

    controller.add(42);

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue<int>.data(42)),
    );

    controller.add(21);

    verifyOnly(
      listener,
      listener(const AsyncValue.data(42), const AsyncValue<int>.data(21)),
    );

    await controller.close();
  });

  test('errors', () async {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = Listener<AsyncValue<int>>();
    final error = Error();
    final stack = StackTrace.current;

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

    controller.addError(error, stack);

    verifyOnly(
      listener,
      listener(
        const AsyncValue.loading(),
        AsyncValue<int>.error(error, stack),
      ),
    );

    controller.add(21);

    verifyOnly(
      listener,
      listener(
        AsyncError<int>(error, stack),
        const AsyncValue.data(21).copyWithPrevious(
          AsyncError(error, stack),
        ),
      ),
    );

    await controller.close();
  });

  test('stops subscription', () async {
    final container = ProviderContainer.test();
    final controller = StreamController<int>(sync: true);
    final dispose = OnDisposeMock();
    final provider = StreamProvider((ref) {
      ref.onDispose(dispose.call);
      return controller.stream;
    });
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

    controller.add(42);

    verifyOnly(
      listener,
      listener(const AsyncValue.loading(), const AsyncValue<int>.data(42)),
    );
    verifyNoMoreInteractions(dispose);

    container.dispose();

    verify(dispose()).called(1);
    verifyNoMoreInteractions(dispose);

    // if the listener wasn't removed, this would throw because markNeedsNotifyListeners
    // cannot be called once the provider was disposed.
    controller.add(21);

    await controller.close();
  });

  group('StreamProvider.future', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = ProviderContainer.test();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        controller.add(42);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before after value', () async {
        final container = ProviderContainer.test();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before first error', () async {
        final container = ProviderContainer.test();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        controller.addError(42);

        await expectLater(future, throwsA(42));

        await controller.close();
      });

      test('read currentValue before after error', () async {
        final container = ProviderContainer.test();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.addError(42);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, throwsA(42));

        await controller.close();
      });
    });

    group('from StreamProvider.overrideWithValue', () {
      test('read currentValue before first value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(
          overrides: [
            provider.overrideWithValue(const AsyncValue.loading()),
          ],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        await expectLater(future, completion(42));
      });

      test('read currentValue before after value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(
          overrides: [
            provider.overrideWithValue(const AsyncValue.loading()),
          ],
        );

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, completion(42));
      });

      test('read currentValue before first error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(
          overrides: [
            provider.overrideWithValue(const AsyncValue.loading()),
          ],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        container.updateOverrides([
          provider
              .overrideWithValue(const AsyncValue.error(42, StackTrace.empty)),
        ]);

        await expectLater(future, throwsA(42));
      });

      test('read currentValue before after error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(
          overrides: [
            provider.overrideWithValue(const AsyncValue.loading()),
          ],
        );

        container.updateOverrides([
          provider
              .overrideWithValue(const AsyncValue.error(42, StackTrace.empty)),
        ]);

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, throwsA(42));
      });

      test('synchronous first event', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(
          overrides: [
            provider.overrideWithValue(const AsyncValue.data(42)),
          ],
        );

        container.listen(provider, (p, n) {});
        final future = container.read(provider.future);

        await expectLater(future, completion(42));
      });
    });
  });
}

extension on Future<Object?> {
  Future<StackTrace?> get stackTrace async {
    try {
      await this;
      return null;
    } catch (e, s) {
      return s;
    }
  }
}
