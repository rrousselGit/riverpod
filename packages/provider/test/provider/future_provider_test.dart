import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/framework/framework.dart' show AlwaysAliveProvider;
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

    final example = FutureProvider((state) async {
      final otherValue = await state.dependOn(other).future;

      return '${state.dependOn(simple).value} $otherValue';
    });

    final listener = StringListenerMock();

    example.watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
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

    FutureProvider((_) => completer.future).watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    completer.complete(42);

    verify(listener(AsyncValue.data(42))).called(1);
    verifyNoMoreInteractions(listener);
    owner.dispose();
  });
  test('listener watchOwner not called anymore if result function called', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();

    final removeListener = FutureProvider((_) => completer.future) //
        .watchOwner(owner, listener);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    removeListener();
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
