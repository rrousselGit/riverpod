// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  late StreamController<int> controller;
  final provider = StreamProvider((ref) => controller.stream);
  late ProviderContainer container;

  // TODO remove this setup/teardown
  setUp(() {
    container = createContainer();
    controller = StreamController<int>(sync: true);
  });
  tearDown(() {
    container.dispose();
    controller.close();
  });

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
    final container = createContainer(
      overrides: [
        provider.overrideWith((StreamProviderRef<int> ref) {
          ref.state = const AsyncData(42);
          return Stream.value(43);
        }),
        autoDispose.overrideWith((AutoDisposeStreamProviderRef<int> ref) {
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
    final container = createContainer(
      overrides: [
        family.overrideWith(
          (StreamProviderRef<String> ref, int arg) {
            ref.state = AsyncData('42 $arg');
            return Stream.value('43 $arg');
          },
        ),
        autoDisposeFamily.overrideWith(
          (AutoDisposeStreamProviderRef<String> ref, int arg) {
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
    final container = createContainer();
    late AsyncValue<int> state;
    final provider = StreamProvider<int>((ref) {
      state = ref.state;
      return Stream.value(0);
    });

    container.read(provider);

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
      final container = createContainer();
      var count = 0;
      final provider = StreamProvider((ref) => Stream.value(count++));

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
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider((ref) => Stream.value(ref.watch(dep)));

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
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = StreamProvider((ref) => Stream.value(ref.watch(dep)));

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
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    late StreamProviderRef<int> ref;
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
    final dep = Provider((ref) => 0);
    final provider = StreamProvider(
      (ref) => Stream.value(ref.watch(dep)),
      dependencies: [dep],
    );
    final root = createContainer();
    final container = createContainer(
      parent: root,
      overrides: [dep.overrideWithValue(42)],
    );

    // ignore: deprecated_member_use_from_same_package
    await expectLater(container.read(provider.stream), emits(42));
    await expectLater(container.read(provider.future), completion(42));
    expect(container.read(provider), const AsyncData(42));

    expect(root.getAllProviderElements(), isEmpty);
  });

  test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
    final dep = StateProvider((ref) => Stream.value(42));
    final provider = StreamProvider((ref) => ref.watch(dep));
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();
    final controller = StreamController<int>();
    addTearDown(controller.close);

    await expectLater(
      // ignore: deprecated_member_use_from_same_package
      container.read(provider.stream),
      emits(42),
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
      // ignore: deprecated_member_use_from_same_package
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
    final provider = StreamProvider((ref) => Stream.value(result));

    // ignore: deprecated_member_use_from_same_package
    expect(container.read(provider.stream), emits(0));
    expect(await container.read(provider.future), 0);
    expect(container.read(provider), const AsyncValue.data(0));

    result = 1;
    expect(
      container.refresh(provider),
      const AsyncLoading<int>().copyWithPrevious(const AsyncValue<int>.data(0)),
    );

    // ignore: deprecated_member_use_from_same_package
    expect(container.read(provider.stream), emits(1));
    expect(await container.read(provider.future), 1);
    expect(container.read(provider), const AsyncValue.data(1));
  });

  group('scoping an override overrides all the associated subproviders', () {
    test('when passing the provider itself', () async {
      final provider = StreamProvider((ref) => Stream.value(0));
      final root = createContainer();
      final container = createContainer(parent: root, overrides: [provider]);

      // ignore: deprecated_member_use_from_same_package
      expect(await container.read(provider.stream).first, 0);
      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider),
        ]),
      );
    });

    // test('when using provider.overrideWithValue', () async {
    //   final provider = StreamProvider((ref) => Stream.value(0));
    //   final root = createContainer();
    //   final container = createContainer(parent: root, overrides: [
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   expect(await container.read(provider.stream).first, 42);
    //   expect(await container.read(provider.future), 42);
    //   expect(container.read(provider), const AsyncValue.data(42));
    //   expect(root.getAllProviderElements(), isEmpty);
    //   expect(
    //     container.getAllProviderElements(),
    //     unorderedEquals(<Object?>[
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider),
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider.future),
    //       isA<ProviderElementBase<Object?>>()
    //           .having((e) => e.origin, 'origin', provider.stream),
    //     ]),
    //   );
    // });

    test('when using provider.overrideWithProvider', () async {
      final provider = StreamProvider((ref) => Stream.value(0));
      final root = createContainer();
      final container = createContainer(
        parent: root,
        overrides: [
          provider
              // ignore: deprecated_member_use_from_same_package
              .overrideWithProvider(StreamProvider((ref) => Stream.value(42))),
        ],
      );

      // ignore: deprecated_member_use_from_same_package
      expect(await container.read(provider.stream).first, 42);
      expect(await container.read(provider.future), 42);
      expect(container.read(provider), const AsyncValue.data(42));
      expect(root.getAllProviderElements(), isEmpty);
      expect(
        container.getAllProviderElements(),
        unorderedEquals(<Object?>[
          isA<ProviderElementBase<Object?>>()
              .having((e) => e.origin, 'origin', provider),
        ]),
      );
    });
  });

  test('Loading to data', () {
    expect(container.read(provider), const AsyncValue<int>.loading());

    controller.add(42);

    expect(container.read(provider), const AsyncValue<int>.data(42));
  });

  test('Loading to error', () {
    expect(container.read(provider), const AsyncValue<int>.loading());

    final stack = StackTrace.current;
    controller.addError(42, stack);

    expect(
      container.read(provider),
      AsyncValue<int>.error(42, stack),
    );
  });

  group('.future', () {
    // test(
    //     'throws StateError if the provider is disposed before a value was emitted',
    //     () async {
    //   final container = createContainer(overrides: [
    //     provider.overrideWithValue(const AsyncLoading()),
    //   ]);

    //   final future = container.read(provider.future);

    //   container.dispose();

    //   await expectLater(
    //     future,
    //     throwsA(
    //       isA<StateError>().having(
    //         (e) => e.message,
    //         'message',
    //         equalsIgnoringHashCodes(
    //           'The provider StreamProvider<int>#00000 was disposed before a value was emitted.',
    //         ),
    //       ),
    //     ),
    //   );
    // });

    //   test('supports loading then error then loading', () async {
    //     final container = createContainer(overrides: [
    //       provider.overrideWithValue(const AsyncLoading()),
    //     ]);

    //     var future = container.read(provider.future);

    //     final error = Error();

    //     container.updateOverrides([
    //       provider.overrideWithValue(AsyncValue.error(error)),
    //     ]);

    //     expect(container.read(provider.future), future);

    //     // TODO(rrousselGit) test that the stacktrace is preserved
    //     await expectLater(future, throwsA(error));

    //     final error2 = Error();

    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.loading()),
    //     ]);

    //     future = container.read(provider.future);

    //     container.updateOverrides([
    //       provider.overrideWithValue(AsyncValue.error(error2)),
    //     ]);

    //     expect(container.read(provider.future), future);

    //     // TODO(rrousselGit) test that the stacktrace is preserved
    //     await expectLater(future, throwsA(error2));
    //   });

    //   test('supports loading then error then another error', () async {
    //     final container = createContainer(overrides: [
    //       provider.overrideWithValue(const AsyncLoading()),
    //     ]);

    //     var future = container.read(provider.future);

    //     final error = Error();

    //     container.updateOverrides([
    //       provider.overrideWithValue(AsyncValue.error(error)),
    //     ]);

    //     expect(container.read(provider.future), future);

    //     // TODO(rrousselGit) test that the stacktrace is preserved
    //     await expectLater(future, throwsA(error));

    //     final error2 = Error();

    //     // error without passing by an intermediary loading state
    //     container.updateOverrides([
    //       provider.overrideWithValue(AsyncValue.error(error2)),
    //     ]);

    //     future = container.read(provider.future);

    //     // TODO(rrousselGit) test that the stacktrace is preserved
    //     await expectLater(future, throwsA(error2));
    //   });

    //   test('supports loading then data then loading', () async {
    //     final container = createContainer(overrides: [
    //       provider.overrideWithValue(const AsyncLoading()),
    //     ]);

    //     var future = container.read(provider.future);

    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.data(42)),
    //     ]);

    //     expect(container.read(provider.future), future);
    //     await expectLater(future, completion(42));

    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.loading()),
    //     ]);

    //     future = container.read(provider.future);

    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.data(21)),
    //     ]);

    //     expect(container.read(provider.future), future);
    //     await expectLater(future, completion(21));
    //   });

    //   test('supports loading then data then another data', () async {
    //     final container = createContainer(overrides: [
    //       provider.overrideWithValue(const AsyncLoading()),
    //     ]);

    //     var future = container.read(provider.future);

    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.data(42)),
    //     ]);

    //     expect(container.read(provider.future), future);
    //     await expectLater(future, completion(42));

    //     // data without passing by an intermediary loading state
    //     container.updateOverrides([
    //       provider.overrideWithValue(const AsyncValue.data(21)),
    //     ]);

    //     future = container.read(provider.future);

    //     await expectLater(future, completion(21));
    //   });
  });

  // test('myProvider.stream emits done on dispose', () async {
  //   final stream = container.read(provider.stream);

  //   container.dispose();

  //   await expectLater(stream, emitsDone);
  // });

  // test('myProvider.stream re-create a new stream when re-entering loading',
  //     () async {
  //   final container = createContainer(overrides: [
  //     provider.overrideWithValue(const AsyncValue.data(42)),
  //   ]);

  //   final stream = container.read(provider.stream);

  //   await expectLater(stream, emits(42));

  //   container.updateOverrides([
  //     provider.overrideWithValue(const AsyncValue.loading()),
  //   ]);

  //   final stream2 = container.read(provider.stream);

  //   expect(stream2, isNot(stream));
  //   await expectLater(stream, emitsDone);

  //   container.updateOverrides([
  //     provider.overrideWithValue(const AsyncValue.data(21)),
  //   ]);

  //   await expectLater(stream2, emits(21));

  //   container.dispose();

  //   await expectLater(stream2, emitsDone);
  // });

  // test('myProvider.stream works across provider rebuild', () async {
  //   final container = createContainer(overrides: [
  //     provider.overrideWithValue(const AsyncValue.data(42)),
  //   ]);

  //   final stream = container.read(provider.stream);

  //   await expectLater(stream, emits(42));

  //   container.updateOverrides(
  //     [provider.overrideWithValue(const AsyncValue.data(21))],
  //   );

  //   await expectLater(stream, emits(21));
  // });

  test('does not filter identical values', () async {
    final sub = container.listen(provider, (_, __) {});

    expect(sub.read(), const AsyncValue<int>.loading());

    controller.add(42);
    await container.pump();

    expect(sub.read(), const AsyncValue<int>.data(42));

    controller.add(42);
    await container.pump();

    expect(sub.read(), const AsyncValue<int>.data(42));
  });

  test('provider.stream is a broadcast stream', () async {
    controller = StreamController<int>();

    // ignore: deprecated_member_use_from_same_package
    final sub = container.listen(provider.stream, (_, __) {});

    controller.add(42);

    await expectLater(sub.read(), emits(42));
  });

  test('throwing inside "create" result in an AsyncValue.error', () {
    // ignore: only_throw_errors
    final provider = StreamProvider<int>((ref) => throw 42);

    expect(
      container.read(provider),
      isA<AsyncError<int>>().having((s) => s.error, 'error', 42),
    );
  });

  test('does not update dependents if the created stream did not change',
      () async {
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
      '.stream does not update dependents if the created stream did not change',
      () async {
    final dep = StateProvider((ref) => 0);
    final provider = StreamProvider((ref) {
      ref.watch(dep);
      return const Stream<int>.empty();
    });
    final listener = Listener<Stream<int>>();

    // ignore: deprecated_member_use_from_same_package
    container.listen(provider.stream, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(any, any));

    container.read(dep.notifier).state++;
    await container.pump();

    verifyNoMoreInteractions(listener);
  });

  test(
      '.future does not update dependents if the created future did not change',
      () async {
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
    // ignore: unawaited_futures
    container.read(provider.future).catchError((Object _) => 0);
  });

  group('overrideWithValue(T)', () {
    // test('.stream is a broadcast stream', () async {
    //   final provider = StreamProvider((ref) => controller.stream);
    //   final container = createContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.data(42)),
    //   ]);

    //   final sub = container.listen(provider.stream, (_, __) {});

    //   await expectLater(sub.read(), emits(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.data(21)),
    //   ]);

    //   await expectLater(sub.read(), emits(21));
    // });

    // test('.stream queues events when there are no listeners', () async {
    //   final provider = StreamProvider((ref) => controller.stream);
    //   final container = createContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.data(42)),
    //   ]);

    //   final sub = container.listen(provider.stream, (_, __) {});

    //   await expectLater(sub.read(), emits(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.data(21)),
    //   ]);
    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.data(22)),
    //   ]);

    //   // This await would normally prevent the test from reading the "21" event
    //   // unless the event is queued
    //   await container.pump();

    //   await expectLater(
    //     sub.read(),
    //     emitsInOrder(<Object?>[21, 22]),
    //   );
    // });

    //   test('.stream emits done when the container is disposed', () async {
    //     final provider = StreamProvider.autoDispose((ref) => controller.stream);
    //     final container = createContainer(overrides: [
    //       provider.overrideWithValue(const AsyncValue<int>.data(42)),
    //     ]);

    //     final sub = container.listen(provider.stream, (_, __) {});

    //     final stream = sub.read();

    //     container.dispose();

    //     await expectLater(stream, emits(42));
    //     await expectLater(stream, emitsDone);
    //   });
    // });

    // test(
    //     'when overridden with an error but provider.stream is not listened to, it should not emit an error to the zone',
    //     () async {
    //   final error = Error();
    //   final stream = StreamProvider<int>((ref) => const Stream.empty());

    //   final container = ProviderContainer(overrides: [
    //     stream.overrideWithValue(AsyncValue.error(error)),
    //   ]);
    //   addTearDown(container.dispose);

    //   expect(
    //     container.read(stream),
    //     AsyncValue<int>.error(error),
    //   );
  });

  test('StreamProvider.family', () async {
    final provider = StreamProvider.family<String, int>((ref, a) {
      return Stream.value('$a');
    });
    final container = createContainer();

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

  test('is AlwaysAliveProviderBase', () {
    final provider = StreamProvider<int>((_) async* {});

    expect(provider, isA<AlwaysAliveProviderBase<AsyncValue<int>>>());
  });

  test('subscribe exposes loading synchronously then value on change',
      () async {
    final container = createContainer();
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
    final container = createContainer();
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
    final container = createContainer();
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

  group('StreamProvider().future', () {
    test('does not update dependents when the future completes', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      final provider = StreamProvider((_) => controller.stream);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        // ignore: deprecated_member_use_from_same_package
        return ref.watch(provider.stream);
      });

      container.listen(dependent, (_, __) {});

      expect(callCount, 1);

      controller.add(42);
      // just making sure the dependent isn't updated asynchronously
      await container.pump();

      expect(callCount, 1);
    });

    test('.stream creates the stream once and it contains all events',
        () async {
      final currentStream = StateProvider((ref) => Stream.value(42));
      // a StreamProvider that can rebuild with a new future
      final streamProvider = StreamProvider((ref) => ref.watch(currentStream));
      final container = createContainer();
      final listener = Listener<Stream<int>>();

      final sub = container.listen(
        // ignore: deprecated_member_use_from_same_package
        streamProvider.stream,
        listener.call,
        fireImmediately: true,
      );

      final stream = sub.read();

      verifyOnly(listener, listener(null, sub.read()));
      await expectLater(stream, emits(42));

      container.read(currentStream.notifier).state = Stream.value(21);
      await expectLater(stream, emits(21));

      // Making sure providers are disposed, sending done events to ".stream".
      container.dispose();

      await expectLater(stream, emitsDone);
      verifyNoMoreInteractions(listener);
    });
  });

  group('StreamProvider.autoDispose().stream', () {
    test('does not update dependents when the future completes', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      final provider = StreamProvider.autoDispose((_) => controller.stream);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider.autoDispose((ref) {
        callCount++;
        // ignore: deprecated_member_use_from_same_package
        return ref.watch(provider.stream);
      });

      container.listen(dependent, (_, __) {});

      expect(callCount, 1);

      controller.add(42);

      // just making sure the dependent isn't updated asynchronously
      await container.pump();

      expect(callCount, 1);
    });

    test('disposes the main provider when no longer used', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      var didDispose = false;
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(() => didDispose = true);
        return controller.stream;
      });
      final container = createContainer();
      // ignore: deprecated_member_use_from_same_package
      final sub = container.listen(provider.stream, (_, __) {});

      expect(didDispose, false);

      await container.pump();
      expect(didDispose, false);

      sub.close();

      await container.pump();
      expect(didDispose, true);
    });
  });

  group('StreamProvider.future', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.future);

        controller.add(42);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before after value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        final future = container.read(provider.future);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before first error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.future);

        controller.addError(42);

        await expectLater(future, throwsA(42));

        await controller.close();
      });

      test('read currentValue before after error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.addError(42);

        final future = container.read(provider.future);

        await expectLater(future, throwsA(42));

        await controller.close();
      });
    });

    group('from StreamProvider.overrideWithValue', () {
      //   test('read currentValue before first value', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final future = container.read(provider.future);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     await expectLater(future, completion(42));
      //   });

      //   test('read currentValue before after value', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final future = container.read(provider.future);

      //     await expectLater(future, completion(42));
      //   });

      //   test('read currentValue before first error', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final future = container.read(provider.future);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.error(42)),
      //     ]);

      //     await expectLater(future, throwsA(42));
      //   });

      //   test('read currentValue before after error', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.error(42)),
      //     ]);

      //     final future = container.read(provider.future);

      //     await expectLater(future, throwsA(42));
      //   });

      //   test('synchronous first event', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final future = container.read(provider.future);

      //     await expectLater(future, completion(42));
      //   });
    });
  });

  group('StreamProvider.stream', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        // ignore: deprecated_member_use_from_same_package
        final stream = container.read(provider.stream);

        controller.add(42);

        await expectLater(stream, emits(42));

        await controller.close();
      });

      test('read currentValue before after value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        // ignore: deprecated_member_use_from_same_package
        final stream = container.read(provider.stream);

        await expectLater(stream, emits(42));

        await controller.close();
      });

      test('read currentValue before first error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        // ignore: deprecated_member_use_from_same_package
        final stream = container.read(provider.stream);

        controller.addError(42);

        await expectLater(stream, emitsError(42));

        await controller.close();
      });

      test('read currentValue before after error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.addError(42);

        // ignore: deprecated_member_use_from_same_package
        final stream = container.read(provider.stream);

        await expectLater(stream, emitsError(42));

        await controller.close();
      });
    });

    group('from StreamProvider.overrideWithValue', () {
      //   test('loading to data to loading creates a new stream too', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream0 = container.read(provider.stream);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final stream1 = container.read(provider.stream);

      //     expect(stream0, stream1);
      //     await expectLater(stream1, emits(42));

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream2 = container.read(provider.stream);

      //     expect(stream2, isNot(stream1));
      //     await expectLater(stream1, emitsDone);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(21)),
      //     ]);

      //     await expectLater(stream2, emits(21));
      //   });

      //   test('data to loading creates a new stream', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final stream1 = container.read(provider.stream);

      //     await expectLater(stream1, emits(42));

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream2 = container.read(provider.stream);

      //     expect(stream2, isNot(stream1));
      //     await expectLater(stream1, emitsDone);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(21)),
      //     ]);

      //     await expectLater(stream2, emits(21));
      //   });

      //   test('error to loading creates a new stream', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.error(42)),
      //     ]);

      //     final stream1 = container.read(provider.stream);

      //     await expectLater(stream1, emitsError(42));

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream2 = container.read(provider.stream);

      //     expect(stream2, isNot(stream1));
      //     await expectLater(stream1, emitsDone);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(21)),
      //     ]);

      //     await expectLater(stream2, emits(21));
      //   });

      //   test('read currentValue before first value', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream = container.read(provider.stream);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     await expectLater(stream, emits(42));
      //   });

      //   test('read currentValue before after value', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final stream = container.read(provider.stream);

      //     await expectLater(stream, emits(42));
      //   });

      //   test('read currentValue before first error', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     final stream = container.read(provider.stream);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.error(42)),
      //     ]);

      //     await expectLater(stream, emitsError(42));
      //   });

      //   test('read currentValue before after error', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.loading()),
      //     ]);

      //     container.updateOverrides([
      //       provider.overrideWithValue(const AsyncValue.error(42)),
      //     ]);

      //     final stream = container.read(provider.stream);

      //     await expectLater(stream, emitsError(42));
      //   });

      //   test('synchronous first event', () async {
      //     final provider = StreamProvider<int>((_) async* {});
      //     final container = ProviderContainer(overrides: [
      //       provider.overrideWithValue(const AsyncValue.data(42)),
      //     ]);

      //     final stream = container.read(provider.stream);

      //     await expectLater(stream, emits(42));
      //   });
    });
  });

  group('mock as value', () {
    // test('value immediately then other value', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), const AsyncValue.data(42));
    //   await expectLater(stream, emits(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.data(21)),
    //   ]);

    //   expect(sub.read(), const AsyncValue.data(21));
    //   await expectLater(stream, emits(21));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('value immediately then error', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), const AsyncValue.data(42));
    //   await expectLater(stream, emits(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.error(21)),
    //   ]);

    //   expect(
    //     sub.read(),
    //     const AsyncValue<int>.error(21).copyWithPrevious(const AsyncData(42)),
    //   );
    //   // TODO why call "read" twice?
    //   expect(
    //     sub.read(),
    //     const AsyncValue<int>.error(21).copyWithPrevious(const AsyncData(42)),
    //   );
    //   await expectLater(stream, emitsError(21));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('value immediately then loading', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), const AsyncValue.data(42));
    //   await expectLater(stream, emits(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);

    //   expect(
    //     sub.read(),
    //     const AsyncLoading<int>()
    //         .copyWithPrevious(const AsyncValue<int>.data(42)),
    //   );

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('loading immediately then value', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), const AsyncValue<int>.loading());

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   expect(sub.read(), const AsyncValue.data(42));
    //   await expectLater(stream, emits(42));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('loading immediately then error', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), const AsyncValue<int>.loading());

    //   final stackTrace = StackTrace.current;

    //   container.updateOverrides([
    //     provider.overrideWithValue(
    //         AsyncValue<int>.error(42, stackTrace: stackTrace)),
    //   ]);

    //   expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));

    //   await expectLater(stream, emitsError(42));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('loading immediately then loading', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);
    //   final stream = container.read(provider.stream);
    //   final listener = Listener<AsyncValue<int>>();

    //   container.listen(provider, listener, fireImmediately: true);

    //   verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);

    //   verifyNoMoreInteractions(listener);

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   verifyOnly(
    //     listener,
    //     listener(const AsyncValue.loading(), const AsyncValue<int>.data(42)),
    //   );

    //   await expectLater(stream, emits(42));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('error immediately then different error', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(
    //         AsyncValue<int>.error(42, stackTrace: stackTrace)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));
    //   await expectLater(stream, emitsError(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(
    //         AsyncValue<int>.error(21, stackTrace: stackTrace)),
    //   ]);

    //   expect(sub.read(), AsyncValue<int>.error(21, stackTrace: stackTrace));
    //   await expectLater(stream, emitsError(21));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('error immediately then different stacktrace', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(
    //         AsyncValue<int>.error(42, stackTrace: stackTrace)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));
    //   await expectLater(stream, emitsError(42));

    //   final stackTrace2 = StackTrace.current;
    //   container.updateOverrides([
    //     provider.overrideWithValue(
    //       AsyncValue<int>.error(42, stackTrace: stackTrace2),
    //     ),
    //   ]);

    //   expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace2));
    //   await expectLater(stream, emitsError(42));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('error immediately then data', () async {
    //   const stackTrace = StackTrace.empty;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(
    //         const AsyncValue<int>.error(42, stackTrace: stackTrace)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(
    //     sub.read(),
    //     const AsyncValue<int>.error(42, stackTrace: stackTrace),
    //   );
    //   await expectLater(stream, emitsError(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.data(21)),
    //   ]);

    //   expect(
    //     sub.read(),
    //     const AsyncValue.data(21)
    //         .copyWithPrevious(const AsyncError(42, stackTrace: stackTrace)),
    //   );
    //   await expectLater(stream, emits(21));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    // test('error immediately then loading', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(
    //         AsyncValue<int>.error(42, stackTrace: stackTrace)),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_, __) {});

    //   expect(sub.read(), AsyncValue<int>.error(42, stackTrace: stackTrace));
    //   await expectLater(stream, emitsError(42));

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);

    //   expect(
    //     sub.read(),
    //     const AsyncLoading<int>()
    //         .copyWithPrevious(AsyncError<int>(42, stackTrace: stackTrace)),
    //   );

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });
  });
}

// class MockStream<T> extends Mock implements Stream<T> {
//   @override
//   StreamSubscription<T> listen(
//     void Function(T event)? onData, {
//     Function? onError,
//     void Function()? onDone,
//     bool? cancelOnError,
//   }) {
//     return super.noSuchMethod(
//       Invocation.method(
//         #listen,
//         [onData],
//         {
//           #onError: onError,
//           #onDone: onDone,
//           #cancelOnError: cancelOnError,
//         },
//       ),
//       returnValue: MockSubscription<T>(),
//       returnValueForMissingStub: MockSubscription<T>(),
//     ) as StreamSubscription<T>;
//   }
// }

// class MockSubscription<T> extends Mock implements StreamSubscription<T> {
//   @override
//   Future<void> cancel() {
//     return super.noSuchMethod(
//       Invocation.method(#cancel, []),
//       returnValue: Future<void>.value(),
//       returnValueForMissingStub: Future<void>.value(),
//     ) as Future<void>;
//   }
// }
