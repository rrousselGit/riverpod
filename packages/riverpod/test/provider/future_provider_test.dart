import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart'
    show AlwaysAliveProviderBase;
import 'package:test/test.dart';

void main() {
  test('FutureProviderDependency can be assigned to ProviderDependency',
      () async {
    final provider = FutureProvider((ref) {
      return Future.value(42);
    });
    final owner = ProviderContainer();

    // ignore: omit_local_variable_types
    final ProviderDependency<Future<int>> dep = owner.ref.dependOn(provider);

    await expectLater(dep.value, completion(42));
  });
  test('FutureProvider.autoDispose', () async {
    var future = Future.value(42);
    final onDispose = OnDisposeMock();
    final provider = FutureProvider.autoDispose((ref) {
      ref.onDispose(onDispose);
      return future;
    });
    final owner = ProviderContainer();
    final listener = ListenerMock();

    final removeListener = provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();

    await Future<void>.value();

    verify(onDispose()).called(1);
    verifyNoMoreInteractions(onDispose);

    future = Future.value(21);

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);

    await Future<void>.value();

    verify(listener(const AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);
  });
  test('FutureProvider.autoDispose.family override', () async {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
    });
    final owner = ProviderContainer();
    final listener = ListenerMock();

    provider(21).watchOwner(owner, listener);

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
    final owner = ProviderContainer(overrides: [
      provider.overrideAs((ref, a) => Future.value(a * 4)),
    ]);
    final listener = ListenerMock();

    provider(21).watchOwner(owner, listener);

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
    final owner = ProviderContainer();

    expect(provider(0).readOwner(owner), const AsyncValue<String>.loading());

    await Future<void>.value();

    expect(
      provider(0).readOwner(owner),
      const AsyncValue<String>.data('0'),
    );
  });
  test('FutureProvider.family override', () async {
    final provider = FutureProvider.family<String, int>((ref, a) {
      return Future.value('$a');
    });
    final owner = ProviderContainer(overrides: [
      provider.overrideAs((ref, a) => Future.value('override $a')),
    ]);

    expect(provider(0).readOwner(owner), const AsyncValue<String>.loading());

    await Future<void>.value();

    expect(
      provider(0).readOwner(owner),
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
    final owner = ProviderContainer();

    expect(provider.readOwner(owner), const AsyncValue<int>.loading());

    await Future<void>.value();

    expect(
      provider.readOwner(owner),
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
    final owner = ProviderContainer();

    expect(provider.readOwner(owner), const AsyncValue<int>.loading());

    owner.dispose();
    await Future<void>.value();

    // No errors are reported to the zone
  });
  test('is AlwaysAliveProviderBase', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProviderBase>());
  });
  test('read', () {
    final owner = ProviderContainer();
    final completer = Completer<int>.sync();
    final other = FutureProvider((_) => completer.future);
    final simple = Provider((_) => 21);

    final example = FutureProvider((ref) async {
      final otherValue = await ref.dependOn(other).value;

      return '${ref.dependOn(simple).value} $otherValue';
    });

    final listener = StringListenerMock();

    final sub = example.addLazyListener(
      owner,
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

    owner.dispose();
  });
  test('exposes data', () {
    final owner = ProviderContainer();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    final sub = provider.addLazyListener(
      owner,
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
    owner.dispose();
  });
  test('listener not called anymore if subscription is closed', () {
    final owner = ProviderContainer();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    final sub = provider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    sub.close();
    completer.complete(42);

    verifyNoMoreInteractions(listener);
    sub.flush();

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });

  group('mock as value', () {
    test('value immediatly then other value', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(const AsyncValue.data(21)),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('value immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(AsyncValue.error(21)),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('value immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(const AsyncValue.loading()),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('loading immediatly then value', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      owner.updateOverrides([
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, completion(42));
    });
    test('loading immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      final stackTrace = StackTrace.current;

      owner.updateOverrides([
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, throwsA(42));
    });
    test('loading immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      owner.updateOverrides([
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);

      verifyNoMoreInteractions(listener);

      owner.updateOverrides([
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, completion(42));
    });
    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(AsyncValue.error(21, stackTrace)),
        ]),
        (err, _) => error = err,
      );

      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);
    });
    test('error immediatly then different stacktrace', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider
              .debugOverrideWithValue(AsyncValue.error(42, StackTrace.current)),
        ]),
        (err, _) => error = err,
      );

      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);
    });
    test('error immediatly then data', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(const AsyncValue.data(42)),
        ]),
        (err, _) => error = err,
      );

      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);
    });
    test('error immediatly then loading', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderContainer(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.value, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.updateOverrides([
          provider.debugOverrideWithValue(const AsyncValue.loading()),
        ]),
        (err, _) => error = err,
      );

      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);
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
