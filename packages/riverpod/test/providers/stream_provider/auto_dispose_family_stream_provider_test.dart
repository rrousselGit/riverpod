import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  test('StreamProvider.autoDispose.family override', () async {
    final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
      return Stream.value(a * 2);
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider(21), listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    await container.pump();

    verifyOnly(listener, listener(const AsyncValue.data(42)));
  });

  test('StreamProvider.autoDispose.family override', () async {
    final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
      return Stream.value(a * 2);
    });
    final container = ProviderContainer(overrides: [
      provider.overrideWithProvider((a) {
        return StreamProvider.autoDispose((ref) => Stream.value(a * 4));
      }),
    ]);
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider(21), listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    await container.pump();

    verifyOnly(listener, listener(const AsyncValue.data(84)));
  });
}
