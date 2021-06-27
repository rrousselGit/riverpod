import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('StreamProvider.autoDispose', () {
    group('scoping an override overrides all the associated subproviders', () {
      test(
        'when passing the provider itself',
        () {},
        skip: true,
      );

      test(
        'when using provider.overrideWithValue',
        () {},
        skip: true,
      );

      test(
        'when using provider.overrideWithProvider',
        () {},
        skip: true,
      );
    });

    test('works', () async {
      var stream = Stream.value(42);
      final onDispose = OnDisposeMock();
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(onDispose);
        return stream;
      });
      final container = createContainer();
      final listener = Listener<AsyncValue<int>>();

      final sub = container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(const AsyncValue.loading()));

      sub.close();

      await container.pump();

      verifyOnly(onDispose, onDispose());

      stream = Stream.value(21);

      container.listen(
        provider,
        listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(const AsyncValue.loading()));

      await container.pump();

      verifyOnly(listener, listener(const AsyncValue.data(21)));
    });
  });
}
