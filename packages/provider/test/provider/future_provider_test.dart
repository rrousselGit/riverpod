import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test/test.dart';

void main() {
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
  });
}

class ListenerMock extends Mock {
  void call(AsyncValue<int> value);
}
