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

    final sub = example.subscribe(owner, (read) => listener(read()));

    expect(sub.read(), const AsyncValue<int>.loading());
    verifyNoMoreInteractions(listener);

    completer.complete(42);

    verify(listener(AsyncValue.data('21 42'))).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
  });
  test('exposes data', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();

    final sub = FutureProvider((_) => completer.future)
        .subscribe(owner, (read) => listener(read()));

    expect(sub.read(), const AsyncValue<int>.loading());
    verifyNoMoreInteractions(listener);

    completer.complete(42);

    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('listener not called anymore if subscription is closed', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();

    final sub = FutureProvider((_) => completer.future) //
        .subscribe(owner, (read) => listener(read()));

    expect(sub.read(), const AsyncValue<int>.loading());
    verifyNoMoreInteractions(listener);

    sub.close();
    completer.complete(42);

    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
}

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class StringListenerMock extends Mock {
  void call(AsyncValue<String> value);
}
