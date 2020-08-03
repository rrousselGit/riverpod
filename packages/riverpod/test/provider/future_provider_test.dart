import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  test('FutureProvider.autoDispose', () async {
    var future = Future.value(42);
    final onDispose = OnDisposeMock();
    final provider = FutureProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return future;
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

    future = Future.value(21);

    provider.watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);
  });

    test('throwing inside "create" result in an AsyncValue.error', () {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((ref) => throw 42);
    final container = ProviderContainer();

    expect(
      container.read(provider),
      isA<AsyncError>().having((s) => s.error, 'error', 42),
    );
  });

  test('FutureProvider.autoDispose.family override', () async {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
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

  test('FutureProvider.autoDispose.family override', () async {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, a) => Future.value(a * 4)),
    ]);
    final listener = ListenerMock();

    provider(21).watchOwner(container, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(84))).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('FutureProvider.family override', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final container = ProviderContainer();

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await Future<void>.value();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('0'),
    );
  });

  test('FutureProvider.family override', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((ref, a) => Future.value('override $a')),
    ]);

    expect(container.read(provider(0)), const AsyncValue<String>.loading());

    await Future<void>.value();

    expect(
      container.read(provider(0)),
      const AsyncValue<String>.data('override 0'),
    );
  });

  test('can specify name', () {
    final provider = FutureProvider(
      (_) async => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = FutureProvider((_) async => 0);

    expect(provider2.name, isNull);
  });

  test('handle errors', () async {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((_) async => throw 42);
    final container = ProviderContainer();

    expect(container.read(provider), const AsyncValue<int>.loading());

    await Future<void>.value();

    expect(
      container.read(provider),
      isA<AsyncValue>().having(
        (s) => s.maybeWhen(error: (err, _) => err, orElse: () => null),
        'error',
        42,
      ),
    );
  });

  test('noop if fails after dispose', () async {
    // ignore: only_throw_errors
    final provider = FutureProvider<int>((_) async => throw 42);
    final container = ProviderContainer();

    expect(container.read(provider), const AsyncValue<int>.loading());

    container.dispose();
    await Future<void>.value();

    // No errors are reported to the zone
  });

  test('is AlwaysAliveProviderBase', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProviderBase>());
  });
  group('FutureProvider().future', () {
    test('returns a future identical to the one created', () {
      final completer = Completer<int>.sync();
      final provider = FutureProvider((_) => completer.future);
      final container = ProviderContainer();

      expect(container.read(provider.future), completer.future);
    });
    test('does not update dependents when the future completes', () async {
      final completer = Completer<int>.sync();
      final provider = FutureProvider((_) => completer.future);
      final container = ProviderContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.future);
      });

      final sub = container.listen(dependent);

      expect(sub.read(), completer.future);
      expect(callCount, 1);

      completer.complete(42);
      // just making sure the dependent isn't updated asynchronously
      await completer.future;

      expect(sub.read(), completer.future);
      expect(callCount, 1);
    });
    test('update dependents when the future changes', () {
      final futureProvider = StateProvider((ref) => Future.value(42));
      // a FutureProvider that can rebuild with a new future
      final provider = FutureProvider((ref) => ref.watch(futureProvider).state);
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = ProviderContainer();
      final futureController = container.read(futureProvider);

      expect(container.read(dependent), futureController.state);
      expect(callCount, 1);

      futureController.state = Future.value(21);

      expect(container.read(dependent), futureController.state);
      expect(callCount, 2);
    });
    test('.name is the listened name.future', () {
      expect(
        FutureProvider((ref) async {}, name: 'hey').future.name,
        'hey.future',
      );
      expect(
        FutureProvider((ref) async {}).future.name,
        null,
      );
    });
  });
  group('FutureProvider.autoDispose().future', () {
    test('.name is the listened name.future', () {
      expect(
        FutureProvider.autoDispose((ref) async {}, name: 'hey').future.name,
        'hey.future',
      );
      expect(
        FutureProvider.autoDispose((ref) async {}).future.name,
        null,
      );
    });

    test('update dependents when the future changes', () {
      final futureProvider = StateProvider((ref) => Future.value(42));
      // a FutureProvider that can rebuild with a new future
      final provider =
          FutureProvider.autoDispose((ref) => ref.watch(futureProvider).state);
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.future);
      });
      final container = ProviderContainer();
      final futureController = container.read(futureProvider);

      expect(container.read(dependent), futureController.state);
      expect(callCount, 1);

      futureController.state = Future.value(21);

      expect(container.read(dependent), futureController.state);
      expect(callCount, 2);
    });
    test('does not update dependents when the future completes', () async {
      final completer = Completer<int>.sync();
      final provider = FutureProvider.autoDispose((_) => completer.future);
      final container = ProviderContainer();
      var callCount = 0;
      final dependent = Provider((ref) {
        callCount++;
        return ref.watch(provider.future);
      });

      final sub = container.listen(dependent);

      expect(sub.read(), completer.future);
      expect(callCount, 1);

      completer.complete(42);
      // just making sure the dependent isn't updated asynchronously
      await completer.future;

      expect(sub.read(), completer.future);
      expect(callCount, 1);
    });
    test('returns a future identical to the one created', () {
      final completer = Completer<int>.sync();
      final provider = FutureProvider.autoDispose((ref) {
        return completer.future;
      });
      final container = ProviderContainer();
      final sub = container.listen(provider.future);

      expect(sub.read(), completer.future);
    });
    test('disposes the main provider when no-longer used', () async {
      final completer = Completer<int>.sync();
      var didDispose = false;
      final provider = FutureProvider.autoDispose((ref) {
        ref.onDispose(() => didDispose = true);
        return completer.future;
      });
      final container = ProviderContainer();
      final sub = container.listen(provider.future);

      expect(sub.read(), completer.future);
      expect(didDispose, false);

      await Future<void>.value();
      expect(didDispose, false);

      sub.close();

      await Future<void>.value();
      expect(didDispose, true);
    });
  });

  test('read', () {
    final container = ProviderContainer();
    final completer = Completer<int>.sync();
    final other = FutureProvider((_) => completer.future);
    final simple = Provider((_) => 21);

    final example = FutureProvider((ref) async {
      final otherValue = await ref.watch(other.future);

      return '${ref.watch(simple)} $otherValue';
    });

    final listener = StringListenerMock();

    final sub = example.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<String>.loading())).called(1);
    verifyNoMoreInteractions(listener);
    completer.complete(42);

    verifyNoMoreInteractions(listener);
    sub.flush();

    verify(listener(const AsyncValue.data('21 42'))).called(1);
    verifyNoMoreInteractions(listener);

    container.dispose();
  });

  test('exposes data', () {
    final container = ProviderContainer();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    final sub = provider.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    completer.complete(42);

    verifyNoMoreInteractions(listener);
    sub.flush();

    verify(listener(const AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    container.dispose();
  });

  test('listener not called anymore if subscription is closed', () {
    final container = ProviderContainer();
    final mayHaveChanged = MayHaveChangedMock<AsyncValue<int>>();
    final didChange = DidChangedMock<AsyncValue<int>>();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    final sub = container.listen(
      provider,
      mayHaveChanged: mayHaveChanged,
      didChange: didChange,
    );

    sub.close();

    completer.complete(42);

    verifyZeroInteractions(mayHaveChanged);
    verifyZeroInteractions(didChange);
  });

  group('mock as value', () {
    test('value immediatly then other value', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue.data(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(21)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(21),
      );
      expect(sub.read(), const AsyncValue.data(21));
    });
    test('value immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue.data(42));

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(21)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(21),
      );
      expect(sub.read(), AsyncValue<int>.error(21));
    });
    test('value immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      final future = container.read(provider.future);

      await expectLater(
        future,
        completion(42),
      );

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue<int>.data(42));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(container.read(provider.future), isNot(future));
      expect(sub.read(), const AsyncValue<int>.loading());
    });
    test('loading immediatly then value', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      final future = container.read(provider.future);

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue<int>.loading());

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(sub.read(), const AsyncValue<int>.data(42));

      await expectLater(future, completion(42));
    });
    test('loading immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      final future = container.read(provider.future);

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue<int>.loading());

      final stackTrace = StackTrace.current;

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      await expectLater(future, throwsA(42));
    });
    test('loading immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      final future = container.read(provider.future);

      final sub = container.listen(provider);

      expect(sub.read(), const AsyncValue<int>.loading());

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(sub.flush(), false);

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      expect(sub.read(), const AsyncValue<int>.data(42));

      await expectLater(future, completion(42));
    });
    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );

      final sub = container.listen(provider);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(21, stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(21),
      );
      expect(sub.read(), AsyncValue<int>.error(21, stackTrace));
    });
    test('error immediatly then different stacktrace', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      final future = container.read(provider.future);

      await expectLater(future, throwsA(42));

      final sub = container.listen(provider);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      final stack2 = StackTrace.current;

      container.updateOverrides([
        provider.overrideWithValue(AsyncValue.error(42, stack2)),
      ]);

      expect(
        container.read(provider.future),
        isNot(future),
      );
      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );
      expect(sub.read(), AsyncValue<int>.error(42, stack2));
    });
    test('error immediatly then data', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      await expectLater(
        container.read(provider.future),
        throwsA(42),
      );

      final sub = container.listen(provider);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.data(42)),
      ]);

      await expectLater(
        container.read(provider.future),
        completion(42),
      );
      expect(sub.read(), const AsyncValue<int>.data(42));
    });
    test('error immediatly then loading', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        provider.overrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      final future = container.read(provider.future);
      await expectLater(future, throwsA(42));

      final sub = container.listen(provider);

      expect(sub.read(), AsyncValue<int>.error(42, stackTrace));

      container.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(container.read(provider.future), isNot(future));
      expect(sub.read(), const AsyncValue<int>.loading());
    });
  });
}

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class OnDisposeMock extends Mock {
  void call();
}

class StringListenerMock extends Mock {
  void call(AsyncValue<String> value);
}
