import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('SynchronousFuture', () {
    final futureProvider = FutureProvider((_) => SynchronousFuture(42));
    final owner = ProviderStateOwner();
    final listener = Listener();

    final sub = futureProvider.addLazyListener(
      owner,
      mayHaveChanged: () {},
      onChange: listener,
    );
    verify(listener(const AsyncValue.data(42)));
    verifyNoMoreInteractions(listener);

    sub.flush();

    verifyNoMoreInteractions(listener);
  });
}

class Listener extends Mock {
  void call(AsyncValue<int> value);
}
