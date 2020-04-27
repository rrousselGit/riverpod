import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:test/test.dart';

void main() {
  test('synchronously expose Loading', () {
    final owner = ProviderStateOwner();
    final listener = ListenerMock();
    final completer = Completer<int>.sync();
    final provider = FutureProvider((_) => completer.future);

    final removeListener = provider.watchOwner(owner, listener);
    expect(removeListener, isNotNull);
// TODO
  });
}

class ListenerMock extends Mock {
  void call(FutureProviderValue<int> value);
}
