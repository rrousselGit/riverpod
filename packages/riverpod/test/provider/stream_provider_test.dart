import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework/framework.dart' show AlwaysAliveProvider;
import 'package:test/test.dart';

void main() {
  test('can specify name', () {
    final provider = StreamProvider(
      (_) => const Stream<int>.empty(),
      name: 'example',
    );

    expect(provider.name, 'example');

    final provider2 = StreamProvider((_) => const Stream<int>.empty());

    expect(provider2.name, isNull);
  });
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

    final sub = provider.addLazyListener(
      owner,
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
    owner.dispose();
  });

  test('errors', () async {
    final owner = ProviderStateOwner();
    final controller = StreamController<int>(sync: true);
    final provider = StreamProvider((_) => controller.stream);
    final listener = ListenerMock();
    final error = Error();
    final stack = StackTrace.current;

    final sub = provider.addLazyListener(
      owner,
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

    final sub = provider.addLazyListener(
      owner,
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

    owner.dispose();

    verify(dispose()).called(1);
    verifyNoMoreInteractions(dispose);

    // if the listener wasn't removed, this would throw because markNeedsNotifyListeners
    // cannot be called once the provider was disposed.
    controller.add(21);

    await controller.close();
  }, skip: true);

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

  group('mock as value', () {
    // TODO unskip
    // test('value immediatly then other value', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.data(42))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(42));

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(21)),
    //   ]);

    //   verify(listener(const AsyncValue.data(21))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(21));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('value immediatly then error', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.data(42))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(42));

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(21)),
    //   ]);

    //   verify(listener(AsyncValue.error(21))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(21));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('value immediatly then loading', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(42)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.data(42))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(42));

    //   Object error;
    //   runZonedGuarded(
    //     () => owner.update(overrides: [
    //       provider.debugOverrideWithValue(const AsyncValue.loading()),
    //     ]),
    //     (err, _) => error = err,
    //   );

    //   verifyNoMoreInteractions(listener);
    //   expect(error, isUnsupportedError);

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('loading immediatly then value', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.loading()),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.loading())).called(1);
    //   verifyNoMoreInteractions(listener);

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   verify(listener(const AsyncValue.data(42))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(42));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('loading immediatly then error', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.loading()),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.loading())).called(1);
    //   verifyNoMoreInteractions(listener);

    //   final stackTrace = StackTrace.current;

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
    //   ]);

    //   verify(listener(AsyncValue.error(42, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);

    //   await expectLater(stream, emitsError(42));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('loading immediatly then loading', () async {
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.loading()),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(const AsyncValue.loading())).called(1);
    //   verifyNoMoreInteractions(listener);

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.loading()),
    //   ]);

    //   verifyNoMoreInteractions(listener);

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(42)),
    //   ]);

    //   verify(listener(const AsyncValue.data(42))).called(1);
    //   verifyNoMoreInteractions(listener);

    //   await expectLater(stream, emits(42));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('error immediatly then different error', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(AsyncValue.error(42, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(42));

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(21, stackTrace)),
    //   ]);

    //   verify(listener(AsyncValue.error(21, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(21));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('error immediatly then different stacktrace', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(AsyncValue.error(42, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(42));

    //   final stackTrace2 = StackTrace.current;
    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(
    //       AsyncValue.error(42, stackTrace2),
    //     ),
    //   ]);

    //   verify(listener(AsyncValue.error(42, stackTrace2))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(42));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('error immediatly then data', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(AsyncValue.error(42, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(42));

    //   owner.update(overrides: [
    //     provider.debugOverrideWithValue(const AsyncValue.data(21)),
    //   ]);

    //   verify(listener(const AsyncValue.data(21))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emits(21));

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
    // test('error immediatly then loading', () async {
    //   final stackTrace = StackTrace.current;
    //   final provider = StreamProvider<int>((_) async* {});
    //   final owner = ProviderStateOwner(overrides: [
    //     provider.debugOverrideWithValue(AsyncValue.error(42, stackTrace)),
    //   ]);
    //   final listener = ListenerMock();
    //   final dep = owner.ref.dependOn(provider);
    //   final stream = dep.stream.asBroadcastStream();

    //   provider.watchOwner(owner, listener);

    //   verify(listener(AsyncValue.error(42, stackTrace))).called(1);
    //   verifyNoMoreInteractions(listener);
    //   await expectLater(stream, emitsError(42));

    //   Object error;
    //   runZonedGuarded(
    //     () => owner.update(overrides: [
    //       provider.debugOverrideWithValue(const AsyncValue.loading()),
    //     ]),
    //     (err, _) => error = err,
    //   );

    //   expect(error, isUnsupportedError);
    //   verifyNoMoreInteractions(listener);

    //   owner.dispose();

    //   await expectLater(stream, emitsDone);
    // });
  });
}

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class DisposeMock extends Mock {
  void call();
}
