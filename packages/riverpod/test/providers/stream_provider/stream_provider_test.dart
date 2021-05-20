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
          isA<StateError>().having((e) => e.message, 'message',
              'The provider was disposed the stream could emit a value'),
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

  test('myProvider.stream receives all values, errors and done events',
      () async {
    int? lastValue;
    Object? lastError;
    StackTrace? lastStack;
    var isClosed = false;

    final sub = container.read(provider.stream).listen(
          (value) => lastValue = value,
          // ignore: avoid_types_on_closure_parameters
          onError: (Object err, StackTrace stack) {
            lastError = err;
            lastStack = stack;
          },
          onDone: () => isClosed = true,
        );
    addTearDown(sub.cancel);

    controller.add(42);
    await Future(() {});

    expect(lastValue, 42);

    final stack = StackTrace.current;

    controller.addError(21, stack);
    await Future(() {});

    expect(lastError, 21);
    expect(lastStack, stack);

    await controller.close();

    expect(isClosed, isTrue);
  });

  // test('does not filter identical values', () {
  //   final sub = container.listen(provider);

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

  //   final sub = container.listen(provider);
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

  //   final sub = container.listen(provider);
  //   sub.read();

  //   container.read(dep).state++;

  //   expect(sub.flush(), false);
  // });

  group('overrideWithValue(T)', () {
    test('.stream is a broadcast stream a', () async {
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
