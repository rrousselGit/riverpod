import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('Provider.autoDispose.family', () {
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
  });

  test('Provider.autoDispose.family', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      ref.onDispose(onDispose);
      return '$value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(provider(0), listener, fireImmediately: true);

    verifyOnly(listener, listener('0'));

    sub.close();

    verifyZeroInteractions(onDispose);

    await container.pump();

    verifyOnly(onDispose, onDispose());
  });

  test('Provider.autoDispose.family override', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      return '$value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((value) {
        return Provider.autoDispose<String>((ref) {
          ref.onDispose(onDispose);
          return '$value override';
        });
      })
    ]);
    addTearDown(container.dispose);

    final sub = container.listen(provider(0), listener, fireImmediately: true);

    verifyOnly(listener, listener('0 override'));

    sub.close();

    verifyZeroInteractions(onDispose);

    await container.pump();

    verifyOnly(onDispose, onDispose());
  });
}
