import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';

void main() {
  // TODO handle null
  test('is AlwaysAliveProvider', () {
    final provider = FutureProvider((_) async => 42);

    expect(provider, isA<AlwaysAliveProvider>());
  });
  test('subscribe exposes loading synchronously then value on change',
      () async {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    await controller.close();
    owner.dispose();
  });

  test('errors', () async {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();
    final error = Error();
    final stack = StackTrace.current;

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.addError(error, stack);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(AsyncValue.error(error, stack)));
    verifyNoMoreInteractions(listener);

    controller.add(21);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(AsyncValue.data(21))).called(1);
    verifyNoMoreInteractions(listener);

    await controller.close();
    owner.dispose();
  });

  test('stops subscription', () async {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final dispose = DisposeMock();
    final provider = StreamProvider((ref) {
      ref.onDispose(dispose);
      return controller.stream;
    });
    final listener = ListenerMock();

    provider.watchOwner(owner, listener);

    verify(listener(const AsyncValue<int>.loading())).called(1);
    verifyNoMoreInteractions(listener);

    controller.add(42);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(dispose);

    owner.dispose();
    controller.add(21);

    verifyNoMoreInteractions(listener);
    owner.update();
    verify(dispose()).called(1);
    verifyNoMoreInteractions(dispose);
    verifyNoMoreInteractions(listener);

    await controller.close();
  });

  group('override with value', () {
    test('with value synchronously', () async {
      final provider = StreamProvider((_) => const Stream<int>.empty());
      final owner = ProviderStateOwner(
        overrides: [
          provider.debugOverrideWithValue(AsyncValue.data(21)),
        ],
      );
      final listener = ListenerMock();

      provider.watchOwner(owner, listener);

      verify(listener(AsyncValue<int>.data(21))).called(1);
      verifyNoMoreInteractions(listener);

      owner.update([
        provider.debugOverrideWithValue(AsyncValue.data(42)),
      ]);

      verify(listener(AsyncValue.data(42)));
      verifyNoMoreInteractions(listener);

      owner.dispose();
    });
    test('data to loading throws', () {
      // final provider = StreamProvider((_) async* {
      //   yield 42;
      // });
      // dynamic error;
      // final owner = ProviderStateOwner(
      //   overrides: [
      //     provider.debugOverrideWithValue(AsyncValue.data(21)),
      //   ]
      // );
      // final listener = ListenerMock();

      // final removeListener = provider.watchOwner(owner, listener);

      // verify(listener(AsyncValue<int>.data(21))).called(1);
      // verifyNoMoreInteractions(listener);
      // expect(onErrorCallCount, 0);

      // owner.update([
      //   provider.debugOverrideWithValue(const AsyncValue.loading()),
      // ]);

      // expect(onErrorCallCount, 1);
      // expect(error, isUnsupportedError);
      // verifyNoMoreInteractions(listener);

      // owner.dispose();
    }, skip: true);
    test('error to loading throws', () {
      // final expectedError = Error();
      // final provider = StreamProvider((_) async* {
      //   yield 42;
      // });
      // dynamic error;
      // var onErrorCallCount = 0;
      // final owner = ProviderStateOwner(
      //   overrides: [
      //     provider.debugOverrideWithValue(AsyncValue.error(expectedError)),
      //   ],
      //   onError: (dynamic err, _) {
      //     error = err;
      //     onErrorCallCount++;
      //   },
      // );
      // final listener = ListenerMock();

      // final removeListener = provider.watchOwner(owner, listener);

      // verify(listener(AsyncValue<int>.error(expectedError))).called(1);
      // verifyNoMoreInteractions(listener);
      // expect(onErrorCallCount, 0);

      // owner.update([
      //   provider.debugOverrideWithValue(const AsyncValue.loading()),
      // ]);

      // expect(onErrorCallCount, 1);
      // expect(error, isUnsupportedError);
      // verifyNoMoreInteractions(listener);

      // owner.dispose();
    }, skip: true);

    test('combine', () async {
      final provider = StreamProvider((_) => const Stream<int>.empty());
      final owner = ProviderStateOwner(
        overrides: [
          provider.debugOverrideWithValue(AsyncValue.data(21)),
        ],
      );

      Stream<int> stream;
      final combinedProvider = Provider<int>((ref) {
        final first = ref.dependOn(provider);
        stream = first.stream;
        return 42;
      });

      expect(combinedProvider.readOwner(owner), 42);

      owner
        ..update([
          provider.debugOverrideWithValue(AsyncValue.data(42)),
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
    final provider = StreamProvider((_) => expectedStream);

    Stream<int> stream;
    final combinedProvider = Provider<int>((ref) {
      final first = ref.dependOn(provider);
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
