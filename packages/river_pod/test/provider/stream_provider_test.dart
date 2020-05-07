import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:river_pod/river_pod.dart';
import 'package:river_pod/src/framework/framework.dart'
    show AlwaysAliveProvider;
import 'package:test/test.dart';

void main() {
  // TODO handle null
  test('is AlwaysAliveProvider', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  test('watchOwner exposes loading synchronously then value on change', () {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verify(listener(AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    controller.close();
    owner.dispose();
  });

  test('errors', () {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();
    final error = Error();
    final stack = StackTrace.current;

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.addError(error, stack);

    verify(listener(AsyncValue.error(error, stack)));
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verify(listener(AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    controller.close();
    owner.dispose();
  });

  test('stops subscription', () {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final dispose = DisposeMock();
    final provider = StreamProvider((state) {
      state.onDispose(dispose);
      return controller.stream;
    });
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(dispose);

    owner.dispose();
    controller.add(21);

    verify(dispose()).called(1);
    verifyNoMoreInteractions(dispose);
    verifyNoMoreInteractions(listener);

    controller.close();
  });

  group('override with value', () {
    test('with value synchronously', () {
      final provider = StreamProvider((_) => const Stream<int>.empty());
      final owner = ProviderStateOwner(
        overrides: [
          provider.overrideWithValue(AsyncValue.data(21)),
        ],
      );
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.data(21)));
      verifyNoMoreInteractions(listener);

      owner.updateOverrides([
        provider.overrideWithValue(AsyncValue.data(42)),
      ]);

      verify(listener(AsyncValue.data(42)));
      verifyNoMoreInteractions(listener);

      owner.dispose();
    });
    test('data to loading throws', () {
      final provider = StreamProvider((_) async* {
        yield 42;
      });
      dynamic error;
      var onErrorCallCount = 0;
      final owner = ProviderStateOwner(
        overrides: [
          provider.overrideWithValue(AsyncValue.data(21)),
        ],
        onError: (dynamic err, _) {
          error = err;
          onErrorCallCount++;
        },
      );
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.data(21)));
      verifyNoMoreInteractions(listener);
      expect(onErrorCallCount, 0);

      owner.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(onErrorCallCount, 1);
      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);

      owner.dispose();
    });
    test('error to loading throws', () {
      final expectedError = Error();
      final provider = StreamProvider((_) async* {
        yield 42;
      });
      dynamic error;
      var onErrorCallCount = 0;
      final owner = ProviderStateOwner(
        overrides: [
          provider.overrideWithValue(AsyncValue.error(expectedError)),
        ],
        onError: (dynamic err, _) {
          error = err;
          onErrorCallCount++;
        },
      );
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue.error(expectedError)));
      verifyNoMoreInteractions(listener);
      expect(onErrorCallCount, 0);

      owner.updateOverrides([
        provider.overrideWithValue(const AsyncValue.loading()),
      ]);

      expect(onErrorCallCount, 1);
      expect(error, isUnsupportedError);
      verifyNoMoreInteractions(listener);

      owner.dispose();
    });

    test('combine', () async {
      final provider = StreamProvider((_) => const Stream<int>.empty());
      final owner = ProviderStateOwner(
        overrides: [
          provider.overrideWithValue(AsyncValue.data(21)),
        ],
      );

      Stream<int> stream;
      final combinedProvider = Provider<int>((state) {
        final first = state.dependOn(provider);
        stream = first.stream;
        return 42;
      });

      expect(combinedProvider.readOwner(owner), 42);

      owner
        ..updateOverrides([
          provider.overrideWithValue(AsyncValue.data(42)),
        ])
        ..dispose();

      await expectLater(
        stream,
        emitsInAnyOrder(<int>[21, 42]),
      );
    });
  });

  test('combine', () {
    final owner = ProviderStateOwner();
    const expectedStream = Stream<int>.empty();
    final provider = StreamProvider((state) => expectedStream);

    Stream<int> stream;
    final combinedProvider = Provider<int>((state) {
      final first = state.dependOn(provider);
      stream = first.stream;
      return 42;
    });

    expect(combinedProvider.readOwner(owner), 42);
    expect(stream, expectedStream);

    owner.dispose();
  });
}

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class DisposeMock extends Mock {
  void call();
}
