import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('Provider.autoDispose.family', () async {
    final onDispose = OnDisposeMock();
    final provider = Provider.autoDispose.family<String, int>((ref, value) {
      ref.onDispose(onDispose);
      return '$value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final sub = container.listen(provider(0), listener);

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

    final sub = container.listen(provider(0), listener);

    verifyOnly(listener, listener('0 override'));

    sub.close();

    verifyZeroInteractions(onDispose);

    await container.pump();

    verifyOnly(onDispose, onDispose());
  });
}
