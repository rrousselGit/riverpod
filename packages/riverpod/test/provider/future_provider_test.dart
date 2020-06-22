import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart'
    show AlwaysAliveProviderBase;
import 'package:test/test.dart';

void main() {
  test('FutureProviderFamily override', () async {
    final provider = FutureProviderFamily<String, int>((ref, a) {
      return Future.value('$a');
    });
    final owner = ProviderStateOwner();

    expect(provider(0).readOwner(owner), const AsyncValue<String>.loading());

    await Future<void>.value();

    expect(
      provider(0).readOwner(owner),
      const AsyncValue<String>.data('0'),
    );
  });
  test('FutureProviderFamily override', () async {
    final provider = FutureProviderFamily<String, int>((ref, a) {
      return Future.value('$a');
    });
    final owner = ProviderStateOwner(overrides: [
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
    final owner = ProviderStateOwner();

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
    final owner = ProviderStateOwner();

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
    final owner = ProviderStateOwner();
    final completer = Completer<int>.sync();
    final other = FutureProvider((_) => completer.future);
    final simple = Provider((_) => 21);

    final example = FutureProvider((ref) async {
      final otherValue = await ref.read(other).future;

      return '${ref.read(simple).value} $otherValue';
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

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, completion(42));

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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, completion(42));

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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, completion(42));

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
      final owner = ProviderStateOwner(overrides: [
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

      final dep = owner.ref.read(provider);
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

      owner.updateOverrides([
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);

      verify(listener(AsyncValue.error(42, stackTrace))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.read(provider);
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

      owner.updateOverrides([
        provider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);

      verifyNoMoreInteractions(listener);

      owner.updateOverrides([
        provider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, completion(42));
    });
    test('error immediatly then different error', () async {
      final stackTrace = StackTrace.current;
      final provider = FutureProvider((_) async => 0);
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, throwsA(42));

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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, throwsA(42));

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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, throwsA(42));

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
      final owner = ProviderStateOwner(overrides: [
        provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
      ]);
      final listener = ListenerMock();

      final dep = owner.ref.read(provider);
      await expectLater(dep.future, throwsA(42));

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

class StringListenerMock extends Mock {
  void call(AsyncValue<String> value);
}
