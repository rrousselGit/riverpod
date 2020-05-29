import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('SynchronousFuture', () {
    final futureProvider = FutureProvider((_) => SynchronousFuture(42));
    final owner = ProviderStateOwner();
    final listener = Listener();

    futureProvider.watchOwner(owner, listener);

    verify(listener(AsyncValue.data(42)));
    verifyNoMoreInteractions(listener);

    owner.update();

    verifyNoMoreInteractions(listener);
  });
}

class Listener extends Mock {
  void call(AsyncValue<int> value);
}
