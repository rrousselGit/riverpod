import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  late StreamController<int> controller;
  final provider = StreamProvider((ref) => controller.stream);
  late ProviderContainer container;

  setUp(() {
    container = createContainer();
    controller = StreamController<int>(sync: true);
  });
  tearDown(() {
    container.dispose();
    controller.close();
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

    expect(container.read(provider), AsyncValue<int>.error(42, stack));
  });

  group('.last', () {
    test(
        'throws StateError if the provider is disposed before a value was emitted',
        () async {
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncLoading()),
      ]);

      final last = container.read(provider.last);

      container.dispose();

      await expectLater(
        last,
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            equalsIgnoringHashCodes(
              'The provider StreamProvider<int>#00000 was disposed before a value was emitted.',
            ),
          ),
        ),
      );
    });

    test('supports loading then error then loading', () async {
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncLoading()),
      ]);

      var last = container.read(provider.last);

      final error = Error();

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error)),
      ]);

      expect(container.read(provider.last), last);

      // TODO(rrousselGit) test that the stacktrace is preserved
      await expectLater(last, throwsA(error));

      final error2 = Error();

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      last = container.read(provider.last);

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error2)),
      ]);

      expect(container.read(provider.last), last);

      // TODO(rrousselGit) test that the stacktrace is preserved
      await expectLater(last, throwsA(error2));
    });

    test('supports loading then error then another error', () async {
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncLoading()),
      ]);

      var last = container.read(provider.last);

      final error = Error();

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error)),
      ]);

      expect(container.read(provider.last), last);

      // TODO(rrousselGit) test that the stacktrace is preserved
      await expectLater(last, throwsA(error));

      final error2 = Error();

      // error without passing by an intermediary loading state
      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(error2)),
      ]);

      last = container.read(provider.last);

      // TODO(rrousselGit) test that the stacktrace is preserved
      await expectLater(last, throwsA(error2));
    });

    test('supports loading then data then loading', () async {
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncLoading()),
      ]);

      var last = container.read(provider.last);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(container.read(provider.last), last);
      await expectLater(last, completion(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      last = container.read(provider.last);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      expect(container.read(provider.last), last);
      await expectLater(last, completion(21));
    });

    test('supports loading then data then another data', () async {
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncLoading()),
      ]);

      var last = container.read(provider.last);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(container.read(provider.last), last);
      await expectLater(last, completion(42));

      // data without passing by an intermediary loading state
      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      last = container.read(provider.last);

      await expectLater(last, completion(21));
    });
  });

  test('can be refreshed', () {}, skip: true);

  test('myProvider.stream emits done on dispose', () async {
    final stream = container.read(provider.stream);

    container.dispose();

    await expectLater(stream, emitsDone);
  });

  test('myProvider.stream re-create a new stream when re-entering loading',
      () async {
    final container = createContainer(overrides: [
      provider.overrideWithValue(const AsyncValue.data(42)),
    ]);

    final stream = container.read(provider.stream);

    await expectLater(stream, emits(42));

    container.updateOverrides([
      provider.overrideWithValue(const AsyncValue.loading()),
    ]);

    final stream2 = container.read(provider.stream);

    expect(stream2, isNot(stream));
    await expectLater(stream, emitsDone);

    container.updateOverrides([
      provider.overrideWithValue(const AsyncValue.data(21)),
    ]);

    await expectLater(stream2, emits(21));

    container.dispose();

    await expectLater(stream2, emitsDone);
  });

  test('myProvider.stream works across provider rebuild', () async {
    final another = StateProvider((ref) => const AsyncValue<int>.data(42));

    final container = createContainer(overrides: [
      provider.overrideWithProvider(
        Provider((ref) {
          return ref.watch(another).state;
        }),
      ),
    ]);

    final stream = container.read(provider.stream);
    final controller = container.read(another);

    await expectLater(stream, emits(42));

    controller.state = const AsyncValue.data(21);

    await expectLater(stream, emits(21));
  });

  // test('does not filter identical values', () {
  //   final sub = container.listen(provider, (_) {});

  //   expect(sub.read(), const AsyncValue<int>.loading());

  //   controller.add(42);

  //   expect(sub.flush(), true);
  //   expect(sub.read(), const AsyncValue<int>.data(42));

  //   controller.add(42);

  //   expect(sub.flush(), true);
  //   expect(sub.read(), const AsyncValue<int>.data(42));
  // });

  test('provider.stream is a broadcast stream', () async {
    controller = StreamController<int>();

    final sub = container.listen(provider.stream, (_) {});

    controller.add(42);

    await expectLater(sub.read(), emits(42));
  });

  test('throwing inside "create" result in an AsyncValue.error', () {
    // ignore: only_throw_errors
    final provider = StreamProvider<int>((ref) => throw 42);

    expect(
      container.read(provider),
      isA<AsyncError>().having((s) => s.error, 'error', 42),
    );
  });

  // test(
  //     'StreamProvider does not update dependents if the created stream did not change',
  //     () {
  //   final dep = StateProvider((ref) => 0);
  //   final provider = StreamProvider((ref) {
  //     ref.watch(dep);
  //     return const Stream<int>.empty();
  //   });

  //   final sub = container.listen(provider, (_) {});
  //   sub.read();

  //   container.read(dep).state++;

  //   expect(sub.flush(), false);
  // });

  // test(
  //     'StreamProvider.stream does not update dependents if the created stream did not change',
  //     () {
  //   final dep = StateProvider((ref) => 0);
  //   final provider = StreamProvider((ref) {
  //     ref.watch(dep);
  //     return const Stream<int>.empty();
  //   });

  //   final sub = container.listen(provider, (_) {});
  //   sub.read();

  //   container.read(dep).state++;

  //   expect(sub.flush(), false);
  // });

  group('overrideWithValue(T)', () {
    test('.stream is a broadcast stream', () async {
      final provider = StreamProvider((ref) => controller.stream);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.data(42)),
      ]);

      final sub = container.listen(provider.stream, (_) {});

      await expectLater(sub.read(), emits(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.data(21)),
      ]);

      await expectLater(sub.read(), emits(21));
    });

    test('.stream queues events when there are no listeners', () async {
      final provider = StreamProvider((ref) => controller.stream);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.data(42)),
      ]);

      final sub = container.listen(provider.stream, (_) {});

      await expectLater(sub.read(), emits(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.data(21)),
      ]);
      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.data(22)),
      ]);

      // This await would normally prevent the test from reading the "21" event
      // unless the event is queued
      await container.pump();

      await expectLater(
        sub.read(),
        emitsInOrder(<Object?>[21, 22]),
      );
    });

    test('.stream emits done when the container is disposed', () async {
      final provider = StreamProvider.autoDispose((ref) => controller.stream);
      final container = createContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.data(42)),
      ]);

      final sub = container.listen(provider.stream, (_) {});

      final stream = sub.read();

      container.dispose();

      await expectLater(stream, emits(42));
      await expectLater(stream, emitsDone);
    });
  });

  test(
      'when overriden with an error but provider.stream is not listened, it should not emit an error to the zone',
      () async {
    final error = Error();
    final stream = StreamProvider<int>((ref) => const Stream.empty());

    final container = ProviderContainer(overrides: [
      stream.overrideWithValue(AsyncValue.error(error)),
    ]);
    addTearDown(container.dispose);

    expect(
      container.read(stream),
      AsyncValue<int>.error(error),
    );
  });

  // test('StreamProvider.autoDispose', () async {
  //   var stream = Stream.value(42);
  //   final onDispose = DisposeMock();
  //   final provider = StreamProvider.autoDispose((ref) {
  //     ref.onDispose(onDispose);
  //     return stream;
  //   });
  //   final container = createContainer();
  //   final listener = ListenerMock();

  //   final removeListener = provider.watchOwner(container, listener);

  //   verify(listener(const AsyncValue.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   removeListener();

  //   await container.pump();

  //   verify(onDispose()).called(1);
  //   verifyNoMoreInteractions(onDispose);

  //   stream = Stream.value(21);

  //   provider.watchOwner(container, listener);

  //   verify(listener(const AsyncValue.loading())).called(1);

  //   await container.pump();

  //   verify(listener(const AsyncValue.data(21))).called(1);
  //   verifyNoMoreInteractions(listener);
  // });

  // test('StreamProvider.autoDispose.family override', () async {
  //   final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
  //     return Stream.value(a * 2);
  //   });
  //   final container = createContainer();
  //   final listener = ListenerMock();

  //   provider(21).watchOwner(container, listener);

  //   verify(listener(const AsyncValue.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   await container.pump();

  //   verify(listener(const AsyncValue.data(42))).called(1);
  //   verifyNoMoreInteractions(listener);
  // });

  // test('StreamProvider.autoDispose.family override', () async {
  //   final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
  //     return Stream.value(a * 2);
  //   });
  //   final container = ProviderContainer(overrides: [
  //     provider.overrideWithProvider((ref, a) => Stream.value(a * 4)),
  //   ]);
  //   final listener = ListenerMock();

  //   provider(21).watchOwner(container, listener);

  //   verify(listener(const AsyncValue.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   await container.pump();

  //   verify(listener(const AsyncValue.data(84))).called(1);
  //   verifyNoMoreInteractions(listener);
  // });

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

  test('StreamProvider.family override', () async {
    final provider = StreamProvider.family<String, int>((ref, a) {
      return Stream.value('$a');
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider(
        (a) => StreamProvider((ref) => Stream.value('override $a')),
      ),
    ]);

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await container.pump();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('override 0'),
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

    expect(provider, isA<AlwaysAliveProviderBase>());
  });

  // test('subscribe exposes loading synchronously then value on change',
  //     () async {
  //   final container = createContainer();
  //   final controller = StreamController<int>(sync: true);
  //   final provider = StreamProvider((_) => controller.stream);
  //   final listener = ListenerMock();

  //   final sub = provider.addLazyListener(
  //     container,
  //     mayHaveChanged: () {},
  //     onChange: listener,
  //   );

  //   verify(listener(const AsyncValue<int>.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   controller.add(42);

  //   verifyNoMoreInteractions(listener);
  //   sub.flush();
  //   verify(listener(const AsyncValue.data(42))).called(1);
  //   verifyNoMoreInteractions(listener);

  //   controller.add(21);

  //   verifyNoMoreInteractions(listener);
  //   sub.flush();
  //   verify(listener(const AsyncValue.data(21))).called(1);
  //   verifyNoMoreInteractions(listener);

  //   await controller.close();
  //   container.dispose();
  // });

  // test('errors', () async {
  //   final container = createContainer();
  //   final controller = StreamController<int>(sync: true);
  //   final provider = StreamProvider((_) => controller.stream);
  //   final listener = ListenerMock();
  //   final error = Error();
  //   final stack = StackTrace.current;

  //   final sub = provider.addLazyListener(
  //     container,
  //     mayHaveChanged: () {},
  //     onChange: listener,
  //   );

  //   verify(listener(const AsyncValue<int>.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   controller.addError(error, stack);

  //   verifyNoMoreInteractions(listener);
  //   sub.flush();
  //   verify(listener(AsyncValue.error(error, stack)));
  //   verifyNoMoreInteractions(listener);

  //   controller.add(21);

  //   verifyNoMoreInteractions(listener);
  //   sub.flush();
  //   verify(listener(const AsyncValue.data(21))).called(1);
  //   verifyNoMoreInteractions(listener);

  //   await controller.close();
  //   container.dispose();
  // });

  // test('stops subscription', () async {
  //   final container = createContainer();
  //   final controller = StreamController<int>(sync: true);
  //   final dispose = DisposeMock();
  //   final provider = StreamProvider((ref) {
  //     ref.onDispose(dispose);
  //     return controller.stream;
  //   });
  //   final listener = ListenerMock();

  //   final sub = provider.addLazyListener(
  //     container,
  //     mayHaveChanged: () {},
  //     onChange: listener,
  //   );

  //   verify(listener(const AsyncValue<int>.loading())).called(1);
  //   verifyNoMoreInteractions(listener);

  //   controller.add(42);

  //   verifyNoMoreInteractions(listener);
  //   sub.flush();
  //   verify(listener(const AsyncValue.data(42))).called(1);
  //   verifyNoMoreInteractions(listener);
  //   verifyNoMoreInteractions(dispose);

  //   container.dispose();

  //   verify(dispose()).called(1);
  //   verifyNoMoreInteractions(dispose);

  //   // if the listener wasn't removed, this would throw because markNeedsNotifyListeners
  //   // cannot be called once the provider was disposed.
  //   controller.add(21);

  //   await controller.close();
  // });

  group('StreamProvider().future', () {
    test('does not update dependents when the future completes', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      final provider = StreamProvider((_) => controller.stream);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });

      container.listen(dependent, (_) {});

      expect(callCount, 1);

      controller.add(42);
      // just making sure the dependent isn't updated asynchronously
      await container.pump();

      expect(callCount, 1);
    });

    // test('update dependents when the future changes', () async {
    //   final streamProvider = StateProvider((ref) => Stream.value(42));
    //   // a StreamProvider that can rebuild with a new future
    //   final provider = StreamProvider((ref) => ref.watch(streamProvider).state);
    //   var callCount = 0;
    //   final dependent = Provider((ref) {
    //     callCount++;
    //     return ref.watch(provider.stream);
    //   });
    //   final container = createContainer();
    //   final streamController = container.read(streamProvider);

    //   await expectLater(container.read(dependent), emits(42));
    //   expect(callCount, 1);

    //   streamController.state = Stream.value(21);

    //   await expectLater(container.read(dependent), emits(21));
    //   expect(callCount, 2);
    // });

    test('.name is the listened name.stream', () {
      expect(
        StreamProvider<int>((ref) async* {}, name: 'hey').stream.name,
        'hey.stream',
      );
      expect(
        StreamProvider<int>((ref) async* {}).stream.name,
        null,
      );
    });

    test('.name is the listened name.last', () {
      expect(
        StreamProvider<int>((ref) async* {}, name: 'hey').last.name,
        'hey.last',
      );
      expect(
        StreamProvider<int>((ref) async* {}).stream.name,
        null,
      );
    });
  });

  group('StreamProvider.autoDispose().stream', () {
    test('.name is the listened name.stream', () {
      expect(
        StreamProvider.autoDispose<int>((ref) async* {}, name: 'hey')
            .stream
            .name,
        'hey.stream',
      );
      expect(
        StreamProvider.autoDispose<int>((ref) async* {}).stream.name,
        null,
      );
    });

    test('.name is the listened name.last', () {
      expect(
        StreamProvider.autoDispose<int>((ref) async* {}, name: 'hey').last.name,
        'hey.last',
      );
      expect(
        StreamProvider.autoDispose<int>((ref) async* {}).stream.name,
        null,
      );
    });

    test('update dependents when the stream changes', () async {
      final streamStateProvider =
          StateProvider((ref) => Stream.value(42), name: 'stateProvider');
      // a StreamProvider that can rebuild with a new future
      final streamProvider = StreamProvider.autoDispose((ref) {
        return ref.watch(streamStateProvider).state;
      }, name: 'streamProvider');
      var callCount = 0;
      final dependent = Provider.autoDispose((ref) {
        callCount++;
        return ref.watch(streamProvider.stream);
      }, name: 'dependent');
      final container = createContainer();

      final streamController = container.read(streamStateProvider);
      container.read(streamProvider.stream);
      final sub = container.listen(dependent, (_) {});

      await expectLater(sub.read(), emits(42));
      expect(callCount, 1);

      streamController.state = Stream.value(21);

      final stream = sub.read();
      container.read(streamProvider.stream);

      expect(callCount, 2);
      await expectLater(stream, emits(21));
    });

    test('does not update dependents when the future completes', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      final provider = StreamProvider.autoDispose((_) => controller.stream);
      final container = createContainer();
      var callCount = 0;
      final dependent = Provider.autoDispose((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });

      container.listen(dependent, (_) {});

      expect(callCount, 1);

      controller.add(42);

      // just making sure the dependent isn't updated asynchronously
      await container.pump();

      expect(callCount, 1);
    });

    test('disposes the main provider when no-longer used', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      var didDispose = false;
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(() => didDispose = true);
        return controller.stream;
      });
      final container = createContainer();
      final sub = container.listen(provider.stream, (_) {});

      expect(didDispose, false);

      await container.pump();
      expect(didDispose, false);

      sub.close();

      await container.pump();
      expect(didDispose, true);
    });
  });

  group('StreamProvider.last', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.last);

        controller.add(42);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before after value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        final future = container.read(provider.last);

        await expectLater(future, completion(42));

        await controller.close();
      });

      test('read currentValue before first error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.last);

        controller.addError(42);

        await expectLater(future, throwsA(42));

        await controller.close();
      });

      test('read currentValue before after error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.addError(42);

        final future = container.read(provider.last);

        await expectLater(future, throwsA(42));

        await controller.close();
      });
    });

    group('from StreamProvider.overrideWithValue', () {
      test('read currentValue before first value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final future = container.read(provider.last);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        await expectLater(future, completion(42));
      });

      test('read currentValue before after value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final future = container.read(provider.last);

        await expectLater(future, completion(42));
      });

      test('read currentValue before first error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final future = container.read(provider.last);

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42)),
        ]);

        await expectLater(future, throwsA(42));
      });

      test('read currentValue before after error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42)),
        ]);

        final future = container.read(provider.last);

        await expectLater(future, throwsA(42));
      });

      test('synchronous first event', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final future = container.read(provider.last);

        await expectLater(future, completion(42));
      });
    });
  });

  group('StreamProvider.stream', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

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

        final stream = container.read(provider.stream);

        await expectLater(stream, emits(42));

        await controller.close();
      });

      test('read currentValue before first error', () async {
        final container = createContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

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

        final stream = container.read(provider.stream);

        await expectLater(stream, emitsError(42));

        await controller.close();
      });
    });

    group('from StreamProvider.overrideWithValue', () {
      test('loading to data to loading creates a new stream too', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream0 = container.read(provider.stream);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final stream1 = container.read(provider.stream);

        expect(stream0, stream1);
        await expectLater(stream1, emits(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream2 = container.read(provider.stream);

        expect(stream2, isNot(stream1));
        await expectLater(stream1, emitsDone);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        await expectLater(stream2, emits(21));
      });

      test('data to loading creates a new stream', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final stream1 = container.read(provider.stream);

        await expectLater(stream1, emits(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream2 = container.read(provider.stream);

        expect(stream2, isNot(stream1));
        await expectLater(stream1, emitsDone);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        await expectLater(stream2, emits(21));
      });

      test('error to loading creates a new stream', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(AsyncValue.error(42)),
        ]);

        final stream1 = container.read(provider.stream);

        await expectLater(stream1, emitsError(42));

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream2 = container.read(provider.stream);

        expect(stream2, isNot(stream1));
        await expectLater(stream1, emitsDone);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(21)),
        ]);

        await expectLater(stream2, emits(21));
      });

      test('read currentValue before first value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream = container.read(provider.stream);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        await expectLater(stream, emits(42));
      });

      test('read currentValue before after value', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        container.updateOverrides([
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final stream = container.read(provider.stream);

        await expectLater(stream, emits(42));
      });

      test('read currentValue before first error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        final stream = container.read(provider.stream);

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42)),
        ]);

        await expectLater(stream, emitsError(42));
      });

      test('read currentValue before after error', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.loading()),
        ]);

        container.updateOverrides([
          provider.overrideWithValue(AsyncValue.error(42)),
        ]);

        final stream = container.read(provider.stream);

        await expectLater(stream, emitsError(42));
      });

      test('synchronous first event', () async {
        final provider = StreamProvider<int>((_) async* {});
        final container = ProviderContainer(overrides: [
          provider.overrideWithValue(const AsyncValue.data(42)),
        ]);

        final stream = container.read(provider.stream);

        await expectLater(stream, emits(42));
      });
    });
  });

  group('mock as value', () {
    test('value immediatly then other value', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), const AsyncValue.data(42));
      await expectLater(stream, emits(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      expect(sub.read(), const AsyncValue.data(21));
      await expectLater(stream, emits(21));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('value immediatly then error', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), const AsyncValue.data(42));
      await expectLater(stream, emits(42));

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(21)),
      ]);

      expect(sub.read(), AsyncValue<int>.error(21));
      expect(sub.read(), AsyncValue<int>.error(21));
      await expectLater(stream, emitsError(21));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('value immediatly then loading', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), const AsyncValue.data(42));
      await expectLater(stream, emits(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);

      expect(sub.read(), const AsyncValue<int>.loading());

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('loading immediatly then value', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), const AsyncValue<int>.loading());

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(sub.read(), const AsyncValue.data(42));
      await expectLater(stream, emits(42));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('loading immediatly then error', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), const AsyncValue<int>.loading());

      final stackTrace = StackTrace.current;

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      await expectLater(stream, emitsError(42));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    // test('loading immediatly then loading', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final container = ProviderContainer(overrides: [
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);
    //   final stream = container.read(provider.stream);

    //   final sub = container.listen(provider, (_) {});

    //   expect(sub.read(), const AsyncValue<int>.loading());

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue<int>.loading()),
    //   ]);

    //   expect(sub.flush(), false);

    //   container.updateOverrides([
    //     provider.overrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   expect(sub.read(), const AsyncValue.data(42));

    //   await expectLater(stream, emits(42));

    //   container.dispose();

    //   await expectLater(stream, emitsDone);
    // });

    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));
      await expectLater(stream, emitsError(42));

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue<int>.error(21, stackTrace)),
      ]);

      expect(sub.read(), AsyncValue<int>.error(21, stackTrace));
      await expectLater(stream, emitsError(21));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('error immediatly then different stacktrace', () async {
      final stackTrace = StackTrace.current;
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));
      await expectLater(stream, emitsError(42));

      final stackTrace2 = StackTrace.current;
      container.updateOverrides([
        provider.overrideWithValue(
          AsyncValue<int>.error(42, stackTrace2),
        ),
      ]);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace2));
      await expectLater(stream, emitsError(42));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('error immediatly then data', () async {
      final stackTrace = StackTrace.current;
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));
      await expectLater(stream, emitsError(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      expect(sub.read(), const AsyncValue.data(21));
      await expectLater(stream, emits(21));

      container.dispose();

      await expectLater(stream, emitsDone);
    });

    test('error immediatly then loading', () async {
      final stackTrace = StackTrace.current;
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider, (_) {});

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));
      await expectLater(stream, emitsError(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);

      expect(sub.read(), const AsyncValue<int>.loading());

      container.dispose();

      await expectLater(stream, emitsDone);
    });
  });
}

class MockStream<T> extends Mock implements Stream<T> {
  @override
  StreamSubscription<T> listen(
    void Function(T event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return super.noSuchMethod(
      Invocation.method(
        #listen,
        [onData],
        {
          #onError: onError,
          #onDone: onDone,
          #cancelOnError: cancelOnError,
        },
      ),
      returnValue: MockSubscription<T>(),
      returnValueForMissingStub: MockSubscription<T>(),
    ) as StreamSubscription<T>;
  }
}

class MockSubscription<T> extends Mock implements StreamSubscription<T> {
  @override
  Future<void> cancel() {
    return super.noSuchMethod(
      Invocation.method(#cancel, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    ) as Future<void>;
  }
}
