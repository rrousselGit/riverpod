import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

void main() {
  late StreamController<int> controller;
  final provider = StreamProvider((ref) => controller.stream);
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
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
      final subMock = MockSubscription<int>();
      when(subMock.cancel())
          .thenAnswer((realInvocation) => Future<void>.value());
      final streamMock = MockStream<int>();

      when(streamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).thenReturn(subMock);

      final container = ProviderContainer(overrides: [
        provider.overrideWithProvider(StreamProvider((ref) => streamMock)),
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

      verify(subMock.cancel()).called(1);
    });

    test('throws StateError if the stream is closed before a value was emitted',
        () async {
      final subMock = MockSubscription<int>();
      when(subMock.cancel())
          .thenAnswer((realInvocation) => Future<void>.value());
      final streamMock = MockStream<int>();

      when(streamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).thenReturn(subMock);

      final container = ProviderContainer(overrides: [
        provider.overrideWithProvider(StreamProvider((ref) => streamMock)),
      ]);

      final last = container.read(provider.last);

      final onDone = verify(streamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: captureAnyNamed('onDone'),
      )).captured.first as void Function();

      onDone();

      await expectLater(
        last,
        throwsA(
          isA<StateError>().having((e) => e.message, 'message',
              'The stream was closed before emitting a value'),
        ),
      );

      verifyZeroInteractions(subMock);

      container.dispose();

      verify(subMock.cancel()).called(1);
    });

    test('reports the error if an error is pushed into the stream', () async {
      final subMock = MockSubscription<int>();
      when(subMock.cancel())
          .thenAnswer((realInvocation) => Future<void>.value());
      final streamMock = MockStream<int>();

      when(streamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).thenReturn(subMock);

      final container = ProviderContainer(overrides: [
        provider.overrideWithProvider(StreamProvider((ref) => streamMock)),
      ]);

      final last = container.read(provider.last);

      final onError = verify(streamMock.listen(
        any,
        onError: captureAnyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).captured.first as void Function(Object, StackTrace);

      final error = Error();
      final stack = StackTrace.current;

      onError(error, stack);

      // TODO(rrousselGit) test that the stacktrace is preserved
      await expectLater(last, throwsA(error));

      verifyZeroInteractions(subMock);

      container.dispose();

      verify(subMock.cancel()).called(1);
    });

    test('reports the first value emitted', () async {
      final subMock = MockSubscription<int>();
      when(subMock.cancel())
          .thenAnswer((realInvocation) => Future<void>.value());
      final streamMock = MockStream<int>();

      when(streamMock.listen(
        any,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).thenReturn(subMock);

      final container = ProviderContainer(overrides: [
        provider.overrideWithProvider(StreamProvider((ref) => streamMock)),
      ]);

      final last = container.read(provider.last);

      final onValue = verify(streamMock.listen(
        captureAny,
        onError: anyNamed('onError'),
        onDone: anyNamed('onDone'),
      )).captured.first as void Function(int);

      onValue(42);

      await expectLater(last, completion(42));

      verifyZeroInteractions(subMock);

      container.dispose();

      verify(subMock.cancel()).called(1);
    });
  });

  test('the created stream does not leak on dispose', () async {
    final container = ProviderContainer();
    var didCloseSub = false;
    final controller = StreamController<int>(
      onCancel: () => didCloseSub = true,
    );
    addTearDown(controller.close);

    final provider = StreamProvider((ref) => controller.stream);

    var didCloseProxy = false;
    container
        .read(provider.stream)
        .listen((_) {}, onDone: () => didCloseProxy = true);

    await Future(() {});
    expect(didCloseProxy, false);
    expect(didCloseSub, false);

    container.dispose();
    await Future(() {});

    expect(didCloseProxy, true);
    expect(didCloseSub, true);
  });

  test('the created stream does not leak on autoDispose providers', () async {
    final container = ProviderContainer();
    var didCloseSub = false;
    final controller = StreamController<int>(
      onCancel: () => didCloseSub = true,
    );
    addTearDown(controller.close);

    final provider = StreamProvider.autoDispose((ref) => controller.stream);

    var didCloseProxy = false;

    final sub = container.listen(provider.stream);
    sub.read().listen((_) {}, onDone: () => didCloseProxy = true);

    await Future(() {});
    expect(didCloseProxy, false);
    expect(didCloseSub, false);

    container.dispose();
    await Future(() {});

    expect(didCloseProxy, true);
    expect(didCloseSub, true);
  });

  test('the created stream does not leak on refresh', () async {
    final container = ProviderContainer();
    var didCloseSub = false;
    final controller = StreamController<int>(
      onCancel: () => didCloseSub = true,
    );
    var stream = controller.stream;
    addTearDown(controller.close);

    final provider = StreamProvider((ref) => stream);

    var didClose = false;
    container
        .read(provider.stream)
        .listen((_) {}, onDone: () => didClose = true);

    await Future(() {});
    expect(didCloseSub, false);
    expect(didClose, false);

    stream = const Stream.empty();
    container.refresh(provider);
    await Future(() {});

    expect(didClose, true);
    expect(didCloseSub, true);
  });

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

  test('does not filter identical values', () {
    final sub = container.listen(provider);

    expect(sub.read(), const AsyncValue<int>.loading());

    controller.add(42);

    expect(sub.flush(), true);
    expect(sub.read(), const AsyncValue<int>.data(42));

    controller.add(42);

    expect(sub.flush(), true);
    expect(sub.read(), const AsyncValue<int>.data(42));
  });

  test('provider.stream is a broadcast stream', () async {
    controller = StreamController<int>();

    final sub = container.listen(provider.stream);

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

  test(
      'StreamProvider does not update dependents if the created stream did not change',
      () {
    final dep = StateProvider((ref) => 0);
    final provider = StreamProvider((ref) {
      ref.watch(dep);
      return const Stream<int>.empty();
    });

    final sub = container.listen(provider);
    sub.read();

    container.read(dep).state++;

    expect(sub.flush(), false);
  });

  test(
      'StreamProvider.stream does not update dependents if the created stream did not change',
      () {
    final dep = StateProvider((ref) => 0);
    final provider = StreamProvider((ref) {
      ref.watch(dep);
      return const Stream<int>.empty();
    });

    final sub = container.listen(provider);
    sub.read();

    container.read(dep).state++;

    expect(sub.flush(), false);
  });

  group('overrideWithValue(T)', () {
    test('.stream is a broadcast stream a', () async {
      final provider = StreamProvider((ref) => controller.stream);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.data(42)),
      ]);

      final sub = container.listen(provider.stream);

      await expectLater(sub.read(), emits(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.data(21)),
      ]);

      await expectLater(sub.read(), emits(21));
    });

    test('.stream emits done when the container is disposed', () async {
      final provider = StreamProvider.autoDispose((ref) => controller.stream);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.data(42)),
      ]);

      final sub = container.listen(provider.stream);

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
