import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';

void main() {
  test('can specify name', () {
    final provider = FutureProvider(
      (_) async => 0,
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = FutureProvider((_) async => 0);

    expect(provider2.name, isNull);
  });
  test('is AlwaysAliveProvider', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  test('dependOn', () {
    final owner = ProviderStateOwner();
    final completer = Completer<int>.sync();
    final other = FutureProvider((_) => completer.future);
    final simple = Provider((_) => 21);

    final example = FutureProvider((ref) async {
      final otherValue = await ref.dependOn(other).future;

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
    final owner = ProviderStateOwner();
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
    final owner = ProviderStateOwner();
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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
          provider.debugOverrideWithValue(const AsyncValue.data(21)),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('value immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
          provider.debugOverrideWithValue(AsyncValue.error(21)),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('value immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
          provider.debugOverrideWithValue(const AsyncValue.loading()),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('loading immediatly then value', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      owner.debugUpdate(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));
    });
    test('loading immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      final stackTrace = StackTrace.current;

      owner.debugUpdate(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, throwsA(42));
    });
    test('loading immediatly then loading', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      owner.debugUpdate(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);

      verifyNoMoreInteractions(listener);

      owner.debugUpdate(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));
    });
    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, throwsA(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.debugUpdate(overrides: [
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

class StringListenerMock extends Mock {
  void call(AsyncValue<String> value);
}
