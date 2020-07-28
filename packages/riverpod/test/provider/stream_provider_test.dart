import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('StreamProvider.autoDispose', () async {
    var stream = Stream.value(42);
    final onDispose = DisposeMock();
    final provider = StreamProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return stream;
    });
    final container = ProviderContainer();
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    stream = Stream.value(21);

    provider.watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('StreamProvider.autoDispose.family override', () async {
    final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
      return Stream.value(a * 2);
    });
    final container = ProviderContainer();
    final listener = ListenerMock();

    provider(21).watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('StreamProvider.autoDispose.family override', () async {
    final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
      return Stream.value(a * 2);
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, a) => Stream.value(a * 4)),
    ]);
    final listener = ListenerMock();

    provider(21).watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(84))).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('StreamProvider.family', () async {
    final provider = StreamProvider.family<String, int>((ref, a) {
      return Stream.value('$a');
    });
    final container = ProviderContainer();

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await Future<void>.value();

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
      provider.overrideWithProvider((ref, a) => Stream.value('override $a')),
    ]);

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await Future<void>.value();

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

  test('subscribe exposes loading synchronously then value on change',
      () async {
    final container = ProviderContainer();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(const AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(const AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    await controller.close();
    container.dispose();
  });

  test('errors', () async {
    final container = ProviderContainer();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();
    final error = Error();
    final stack = StackTrace.current;

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.addError(error, stack);

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(AsyncValue.error(error, stack)));
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(const AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    await controller.close();
    container.dispose();
  });

  test('stops subscription', () async {
    final container = ProviderContainer();
    final controller = StreamController<int>(sync: true);
    final dispose = DisposeMock();
    final provider = StreamProvider((ref) {
      ref.onDispose(dispose);
      return controller.stream;
    });
    final listener = ListenerMock();

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verifyNoMoreInteractions(listener);
    sub.flush();
    verify(listener(const AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
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
      final container = ProviderContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });

      container.listen(dependent);

      expect(callCount, 1);

      controller.add(42);
      // just making sure the dependent isn't updated asynchronously
      await Future<void>.value();

      expect(callCount, 1);
    });
    test('update dependents when the future changes', () async {
      final streamProvider = StateProvider((ref) => Stream.value(42));
      // a StreamProvider that can rebuild with a new future
      final provider = StreamProvider((ref) => ref.watch(streamProvider).state);
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });
      final container = ProviderContainer();
      final streamController = container.read(streamProvider);

      await expectLater(container.read(dependent), emits(42));
      expect(callCount, 1);

      streamController.state = Stream.value(21);

      await expectLater(container.read(dependent), emits(21));
      expect(callCount, 2);
    });
    test('.name is the listened name.future', () {
      expect(
        StreamProvider<int>((ref) async* {}, name: 'hey').stream.name,
        'hey.stream',
      );
      expect(
        StreamProvider<int>((ref) async* {}).stream.name,
        null,
      );
    });
  });
  group('StreamProvider.autoDispose().future', () {
    test('.name is the listened name.future', () {
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

    test('update dependents when the future changes', () async {
      final streamProvider = StateProvider((ref) => Stream.value(42));
      // a StreamProvider that can rebuild with a new future
      final provider =
          StreamProvider.autoDispose((ref) => ref.watch(streamProvider).state);
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });
      final container = ProviderContainer();
      final streamController = container.read(streamProvider);

      await expectLater(container.read(dependent), emits(42));
      expect(callCount, 1);

      streamController.state = Stream.value(21);

      await expectLater(container.read(dependent), emits(21));
      expect(callCount, 2);
    });
    test('does not update dependents when the future completes', () async {
      final controller = StreamController<int>(sync: true);
      addTearDown(controller.close);
      final provider = StreamProvider.autoDispose((_) => controller.stream);
      final container = ProviderContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.stream);
      });

      container.listen(dependent);

      expect(callCount, 1);

      controller.add(42);
      // just making sure the dependent isn't updated asynchronously
      await Future<void>.value();

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
      final container = ProviderContainer();
      final sub = container.listen(provider.stream);

      expect(didDispose, false);

      await Future<void>.value();
      expect(didDispose, false);

      sub.close();

      await Future<void>.value();
      expect(didDispose, true);
    });
  });

  group('StreamProvider.last', () {
    group('from StreamProvider', () {
      test('read currentValue before first value', () async {
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.last);

        controller.add(42);

        await expectLater(future, completion(42));

        await controller.close();
      });
      test('read currentValue before after value', () async {
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        final future = container.read(provider.last);

        await expectLater(future, completion(42));

        await controller.close();
      });
      test('read currentValue before first error', () async {
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final future = container.read(provider.last);

        controller.addError(42);

        await expectLater(future, throwsA(42));

        await controller.close();
      });
      test('read currentValue before after error', () async {
        final container = ProviderContainer();
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
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final stream = container.read(provider.stream);

        controller.add(42);

        await expectLater(stream, emits(42));

        await controller.close();
      });
      test('read currentValue before after value', () async {
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        controller.add(42);

        final stream = container.read(provider.stream);

        await expectLater(stream, emits(42));

        await controller.close();
      });
      test('read currentValue before first error', () async {
        final container = ProviderContainer();
        final controller = StreamController<int>();
        final provider = StreamProvider<int>((_) => controller.stream);

        final stream = container.read(provider.stream);

        controller.addError(42);

        await expectLater(stream, emitsError(42));

        await controller.close();
      });
      test('read currentValue before after error', () async {
        final container = ProviderContainer();
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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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
    test('loading immediatly then loading', () async {
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue<int>.loading());

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue<int>.loading()),
      ]);

      expect(sub.flush(), false);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(sub.read(), const AsyncValue.data(42));

      await expectLater(stream, emits(42));

      container.dispose();

      await expectLater(stream, emitsDone);
    });
    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = StreamProvider<int>((_) async* {});
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue<int>.error(42, stackTrace)),
      ]);
      final stream = container.read(provider.stream);

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

      final sub = container.listen(provider);

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

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class DisposeMock extends Mock {
  void call();
}
