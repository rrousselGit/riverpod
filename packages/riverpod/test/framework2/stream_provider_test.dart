import 'dart:async';

import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../uni_directional_test.dart';

void main() {
  StreamController<int> controller;
  final provider = StreamProvider((ref) => controller.stream);
  ProviderContainer container;

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

  test(
      'StreamProvider does not accept null (as provider.stream is non-nullable)',
      () {
    final provider = StreamProvider<void>((ref) => null);

    expect(
      container.read(provider),
      isA<AsyncError>().having((e) => e.error, 'exception', isAssertionError),
    );
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
    int lastValue;
    dynamic lastError;
    StackTrace lastStack;
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
