import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
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

  test('FutureProvider.autoDispose.family override', () async {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
    });
    final container = createContainer();
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider(21), listener, fireImmediately: true);

    verifyOnly(listener, listener(const AsyncValue.loading()));

    await container.pump();

    verifyOnly(listener, listener(const AsyncValue.data(42)));
  });

  test('FutureProvider.autoDispose.family override', () async {
    final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
      return Future.value(a * 2);
    });
    final container = createContainer(overrides: [
      provider.overrideWithProvider((a) {
        return FutureProvider.autoDispose<int>((ref) async => a * 4);
      }),
    ]);
    final listener = Listener<AsyncValue<int>>();

    container.listen(provider(21), listener, fireImmediately: true);

    verify(listener(const AsyncValue.loading())).called(1);
    verifyNoMoreInteractions(listener);

    await container.pump();

    verify(listener(const AsyncValue.data(84))).called(1);
    verifyNoMoreInteractions(listener);
  });
}
