import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';

void main() {
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

    example.watchOwner(owner, listener);

    verify(listener(const AsyncValue<String>.loading())).called(1);
    verifyNoMoreInteractions(listener);
    completer.complete(42);

    verifyNoMoreInteractions(listener);
    owner.update();

    verify(listener(AsyncValue.data('21 42'))).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('exposes data', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();

    FutureProvider((_) => completer.future).watchOwner(owner, listener);

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    completer.complete(42);

    verifyNoMoreInteractions(listener);
    owner.update();

    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('listener not called anymore if subscription is closed', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();

    final removeListener = FutureProvider((_) => completer.future) //
        .watchOwner(owner, listener);

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();
    completer.complete(42);

    verifyNoMoreInteractions(listener);
    owner.update();

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });

  group('mock as value', () {
    test('value immediatly then other value', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.update([
          provider.debugOverrideWithValue(AsyncValue.data(21)),
        ]),
        (err, _) => error = err,
      );

      verifyNoMoreInteractions(listener);
      expect(error, isUnsupportedError);
    });
    test('value immediatly then error', () async {
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.update([
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
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.dependOn(provider);
      await expectLater(dep.future, completion(42));

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      Object error;
      runZonedGuarded(
        () => owner.update([
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

      owner.update([
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);

      verify(listener(AsyncValue.data(42))).called(1);
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

      owner.update([
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

      owner.update([
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);

      verifyNoMoreInteractions(listener);

      owner.update([
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);

      verify(listener(AsyncValue.data(42))).called(1);
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
        () => owner.update([
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
        () => owner.update([
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
        () => owner.update([
          provider.debugOverrideWithValue(AsyncValue.data(42)),
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
        () => owner.update([
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
